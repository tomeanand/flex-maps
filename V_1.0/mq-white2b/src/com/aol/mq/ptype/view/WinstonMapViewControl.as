package com.aol.mq.ptype.view
{
	import com.mapquest.Config;
	import com.mapquest.Constants;
	import com.mapquest.tilemap.*;
	import com.mapquest.tilemap.util.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import com.mapquest.tilemap.controls.oceanbreeze.OBDrawnBackgroundControl;
	
	/**
	 * 
	 * 
	 */
	public class WinstonMapViewControl extends OBDrawnBackgroundControl {
		private var _arrLoaders:Array = new Array();
		
		private var _topPadding:int = -5;
		
		private var _controlUrl:String = Config.CDN_URL + "mapviewcontrol-dotcom2.png";
		
		private var _streetImage:MaskedAssetLoader;
		private var _streetImageUrl:String = _controlUrl;
		private var _streetImageMask:Shape;
		private var _streetOffX:int = 0;
		private var _streetOverX:int = -84;
		private var _streetSelectedX:int = -168;
		
		private var _aerialImage:MaskedAssetLoader;
		private var _aerialImageUrl:String = _controlUrl;
		private var _aerialImageMask:Shape;
		private var _aerialOffX:int = 74;
		private var _aerialOverX:int = -11;
		private var _aerialSelectedX:int = -96;
		
		
		private var _checkboxLoader:Loader;
		private var _chkUrl:String = Config.CDN_URL + "checkbox.png";
		
		private var _checkboxImage:MaskedAssetLoader;
		private var _checkboxImageUrl:String = _controlUrl;
		private var _checkboxImageMask:Shape;
		
		
		private var _dropDownImage:Sprite;
		private var _dropDownMask:Sprite;
		
		private var _labelsSprite:Sprite;
		private var _labelsText:TextField;
		private var _labelsFormat:TextFormat;
		
		private var _dropDownHeight:int = 25;
		private var _dropDownWidth:int = 147;
		
		
		private var _tooltip:com.mapquest.tilemap.util.Tooltip;
		private var _useTooltip:Boolean;
		
		
		/**
		 * OBViewControl is a displayable control that contains
		 * streetmap and aerialmap buttons, and a checkbox for
		 * displaying hybrid map labels
		 * @constructor
		 */
		public function WinstonMapViewControl(useShadow:Boolean=false,useTooltip:Boolean=true) {
			
			super();
			
			_backgroundWidth = getWidth();
			_backgroundHeight = getHeight();
			
			this._position = new MapCornerPlacement(MapCorner.TOP_RIGHT, new Size(5, 30));
			
			this.draw();
			//this.visible = false;
			
			if (useShadow) {
				this.addChild(this._background.shadow);
			}
			this.addChild(this._background.background);
			
			
			this._streetImage = new MaskedAssetLoader(this._controlUrl,this._streetSelectedX,this._topPadding,this.checkAssetsLoaded,this.onSpriteLoadError);
			this.addChild(this._streetImage);
			this._arrLoaders.push(this._streetImage);
			this._streetImage.addEventListener(MouseEvent.CLICK, this.setModeMap);
			this._streetImage.addEventListener(MouseEvent.MOUSE_OVER, this.onStreetImageOver);
			this._streetImage.addEventListener(MouseEvent.MOUSE_OUT, this.onStreetImageOut);
			this._streetImageMask = this._streetImage.createMask(this._streetImage, 166, 0, 75, 25);
			
			
			this._aerialImage = new MaskedAssetLoader(this._controlUrl,this._aerialOffX,(this._topPadding - 27),this.checkAssetsLoaded,this.onSpriteLoadError);
			this.addChild(this._aerialImage);
			this._arrLoaders.push(this._aerialImage);
			this._aerialImage.addEventListener(MouseEvent.CLICK, this.setModeSat);
			this._aerialImage.addEventListener(MouseEvent.MOUSE_OVER, this.onAerialImageOver);
			this._aerialImage.addEventListener(MouseEvent.MOUSE_OUT, this.onAerialImageOut);
			this._aerialImageMask = this._aerialImage.createMask(this._aerialImage, -1, 30, 75, 22);
			
			
			this._checkboxImage = new MaskedAssetLoader(this._chkUrl,37,25,this.checkAssetsLoaded,this.onSpriteLoadError);
			this.addChild(this._checkboxImage);
			this._arrLoaders.push(this._checkboxImage);
			this._checkboxImage.addEventListener(MouseEvent.CLICK, this.onCheckBoxClick);
			this._checkboxImageMask = this._checkboxImage.createMask(this._checkboxImage, 0, 0, 10, 11);
			
			
			this._useTooltip = useTooltip;
			if (useTooltip) {		
				this._tooltip = new Tooltip();
			}
			
		}
		
		private function onSpriteLoadError(e:IOErrorEvent):void {
			throw new Error(e.text);
		}
		
		
		private function makeLabels():void {
			this._labelsFormat = new TextFormat();
			this._labelsFormat.color = 0xCCDDEE;
			this._labelsFormat.font = "Arial";
			this._labelsFormat.size = 12;
			this._labelsSprite = new Sprite();
			this._labelsText = new TextField();
			this._labelsText.height = this._dropDownHeight;
			this._labelsText.width = this._dropDownWidth;
			this._labelsText.text = "Show labels";
			this._labelsText.setTextFormat(this._labelsFormat);
			this._labelsSprite.x = this._checkboxImage.x + 11;
			this._labelsSprite.y = this._checkboxImage.y - 4;
			this._labelsSprite.addChild(this._labelsText);
			this._labelsSprite.height = this._dropDownHeight;
			this._labelsSprite.width = this._dropDownWidth;
			this.addChild(this._labelsSprite);				
		}
		
		
		private function checkAssetsLoaded(e:Event):void {
			if (this._map != null) {
				for (var i:int = 0; i < this._arrLoaders.length; i++) {
					if ( MaskedAssetLoader( this._arrLoaders[i] ).url == e.currentTarget.url) {
						//trace(e.currentTarget.url);
						this._arrLoaders.splice(i, 1);
						break;
					}
				}
				
				if (this._arrLoaders.length == 0) {
					this.makeLabels();
					if (this._useTooltip) {
						this.addChild(this._tooltip);
					}
					this.addEventListener(TileMapEvent.MAP_TYPE_CHANGED,this.onMapTypeChange);
					this._map.addEventListener(TileMapEvent.MAP_TYPE_CHANGED, this.onMapChange);
					var evt:TileMapEvent = new TileMapEvent(TileMapEvent.MAP_TYPE_CHANGED);
					this.onMapChange(evt);					
					//this.visible = true;	
				}
			}
		}	
		
		
		override public function initialize(map:TileMap):void {
			super.initialize(map);
		}
		
		
		private function onMapChange(e:TileMapEvent):void {
			switch(this._map.mapType) {
				case "sat":
					this.setModeSat(e as MouseEvent);
					break;
				case "hyb":
					this.setModeHyb(e as MouseEvent);
					break;
				case "map":
					this.setModeMap(e as MouseEvent);
					break;
				case "none":
				case "custom":
					this.setModeNoneCustom(e as MouseEvent);
					break;
			}
		}
		
		
		private function setModeNoneCustom(evt:MouseEvent):void {
			this._streetImage.x = this._streetOffX;
			this._aerialImage.x = this._aerialOffX;
			this._backgroundHeight = 19;
			if (this.contains(this._checkboxImage)) {
				this.removeChild(this._checkboxImage);
				this.removeChild(this._labelsSprite);
			}
			this.redraw();
			if (_useTooltip) {	
				_tooltip.hide();
			}
		}
		
		
		private function setModeSat(evt:MouseEvent):void {
			this._streetImage.x = this._streetOffX;
			this._aerialImage.x = this._aerialSelectedX;
			this._backgroundHeight = 40;
			
			if (!this.contains(this._checkboxImage)) {
				this.addChild(this._checkboxImage);
				this.addChild(this._labelsSprite);
			}
			if (this._checkboxImage.x != 27) {
				this._checkboxImage.x = 27;
			}
			this.redraw();
			
			if(this._map.mapType != "sat") {
				this._map.mapType = ('sat');
			}
			if (_useTooltip) {	
				_tooltip.hide();
			}
		}
		
		private function getSatHyb(e:MouseEvent):void {
			if(this._map.mapType == "sat") {
				this.setModeSat(e);
			}
			else {
				this.setModeHyb(e);
			}
		}
		
		private function setModeHyb(evt:MouseEvent):void {
			this._streetImage.x = this._streetOffX;
			this._aerialImage.x = this._aerialSelectedX;
			this._backgroundHeight = 40;
			
			if (!this.contains(this._checkboxImage)) {
				this.addChild(this._checkboxImage);
				this.addChild(this._labelsSprite);
			}
			if (this._checkboxImage.x != 37) {
				this._checkboxImage.x = 37;
			}	
			
			this.redraw();
			
			if(this._map.mapType != "hyb") {
				this._map.mapType = ('hyb');
			}
			if (_useTooltip) {	
				_tooltip.hide();
			}
		}
		
		private function onAerialImageOver(evt:MouseEvent):void {
			if (this._aerialImage.x != this._aerialSelectedX) {
				this._aerialImage.x = this._aerialOverX;
				if (_useTooltip) {	
					this._tooltip.show(evt,"View Aerial Map");
				}
			}
		}
		
		private function onAerialImageOut(evt:MouseEvent):void {
			if (this._aerialImage.x != this._aerialSelectedX) {
				if (this._aerialImage.x == this._aerialOverX) {
					this._aerialImage.x = this._aerialOffX;
				}
			}
			if (_useTooltip) {	
				this._tooltip.hide();
			} 
		}
		
		private function setModeMap(evt:MouseEvent):void {
			this._streetImage.x = this._streetSelectedX;
			this._aerialImage.x = this._aerialOffX;
			this._backgroundHeight = 19;
			if (this.contains(this._checkboxImage)) {
				this.removeChild(this._checkboxImage);
				this.removeChild(this._labelsSprite);
			}
			this.redraw();
			
			if (this._map.mapType != "map") {
				this._map.mapType = ('map');
			}
		}
		
		private function onStreetImageOver(evt:MouseEvent):void {
			if (this._streetImage.x != this._streetSelectedX) {
				this._streetImage.x = this._streetOverX;
				if (_useTooltip) {	
					this._tooltip.show(evt,"View Street Map");
				}
			}
		}
		
		private function onStreetImageOut(evt:MouseEvent):void {
			if (this._streetImage.x != this._streetSelectedX) {
				if (this._streetImage.x == this._streetOverX) {
					this._streetImage.x = this._streetOffX;
				}
			}
			if (_useTooltip) {	
				this._tooltip.hide(); 
			}
		}
		
		
		override public function getHeight():int {
			return 19;
		}
		
		/**
		 * Get the width of the control
		 */
		override public function getWidth():int {
			return 145;
		}
		
		override protected function draw():void {
			this._type = Constants.CONTROL_TYPE;
			
			super.draw();
		}
		
		private function onCheckBoxClick(evt:MouseEvent):void {
			if (this._checkboxImage.x != 27) {
				this._checkboxImage.x = 27;
				if (this._map.mapType != "sat") {
					this._map.mapType = ('sat');
				}
			}
			else {
				this._checkboxImage.x = 37;
				if (this._map.mapType != "hyb") {
					this._map.mapType = ('hyb');
				}
			}
		}
		
		private function onMapTypeChange(e:TileMapEvent):void {
			switch(this._map.mapType) {
				
			}
		}
		
	}	// End Class
	
}
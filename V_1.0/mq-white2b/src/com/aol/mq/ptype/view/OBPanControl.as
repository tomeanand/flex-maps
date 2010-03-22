package com.aol.mq.ptype.view
{
	import com.mapquest.Config;
	import com.mapquest.Constants;
	import com.mapquest.tilemap.*;
	import com.mapquest.tilemap.util.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;	
	import com.mapquest.tilemap.controls.oceanbreeze.OBDrawnBackgroundControl;
	
	/**
	 * 
	 * 
	 */	
	public class OBPanControl extends OBDrawnBackgroundControl {
		private var _image:MaskedAssetLoader;
		private var _imageMask:Shape;
		private var _imageUrl:String = "http://www.aolcdn.com/widgetsmapquest/zoomcontrols.png"//Config.CDN_URL + "slidezoom_sprite.png";
		
		private var _imageX:Number = -45;
		private var _imageY:Number = -1;
		
		private var _northButton:Sprite;
		private var _eastButton:Sprite;
		private var _westButton:Sprite;
		private var _southButton:Sprite;
		private var _centerButton:Sprite;
		
		private var _topPadding:int = -1;
		private var _leftPadding:int = 2;
		
		private var _tooltip:com.mapquest.tilemap.util.Tooltip;
		private var _useTooltip:Boolean;
		
		/**
		 * OBPanControl is a displayable control that contains
		 * a compass rose that allows Panning North, South, East and West.
		 * @constructor
		 */
		public function OBPanControl(useShadow:Boolean=false,useTooltip:Boolean=true) {
			
			super();
			_backgroundWidth = getWidth();
			_backgroundHeight = getHeight();
			this.draw();
			
			//this.visible = false;
			
			if (useShadow) {
				this.addChild(this._background.shadow);
			}
			this.addChild(this._background.background);
			
			this._type = Constants.CONTROL_PAN;
			this._position = new MapCornerPlacement(MapCorner.TOP_LEFT, new Size(5, 30));
			
			this._image = new MaskedAssetLoader(this._imageUrl,this._imageX,this._imageY,this.checkAssetsLoaded,this.onSpriteLoadError);
			this.addChild(this._image);
			this._imageMask = this._image.createMask(this._image, 46, 4, 36, 36);
			
			this.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
			
			this._useTooltip = useTooltip;
			if (useTooltip) {		
				this._tooltip = new Tooltip();
			}
		}
		
		
		private function createButtons():void {
			this._northButton = new Sprite();
			this.setupButton(this._northButton, 55, 3, 17, 10, this.onNorthClick, this.onNorthOver);
			
			this._southButton = new Sprite();
			this.setupButton(this._southButton, 55, 29, 17, 10, this.onSouthClick, this.onSouthOver);
			
			this._westButton = new Sprite();
			this.setupButton(this._westButton, 47, 14, 10, 17, this.onWestClick, this.onWestOver);
			
			this._eastButton = new Sprite();
			this.setupButton(this._eastButton, 72, 14, 10, 17, this.onEastClick, this.onEastOver);
			
			this._centerButton = new Sprite();
			this.setupButton(this._centerButton, 57, 13, 12, 15, this.onCenterClick, this.onCenterOver);			
		}
		
		
		private function onSpriteLoadError(e:IOErrorEvent):void {
			throw new Error(e.text);
		}
		
		
		private function checkAssetsLoaded(e:Event):void {
			if (e.currentTarget.url == this._imageUrl) {
				//trace(e.currentTarget.url);
				this.createButtons();
				if (_useTooltip) {
					this.addChild(this._tooltip);
				}	
				//this.visible = true;
			}
		}		
		
		override protected function draw():void {
			this._type = Constants.CONTROL_PAN;
			
			this._position = new MapCornerPlacement(MapCorner.TOP_LEFT, new Size(5, 30));
			super.draw();
		}
		
		private function setupButton(b:Sprite, x:int, y:int, w:int, h:int, clickHandler:Function, overHandler:Function):void {
			b.graphics.clear();
			b.graphics.beginFill(0xffffff, 0);
			b.graphics.drawRect(0, 0, w, h);
			b.x = x + this._image.x;
			b.y = y + this._image.y;
			b.addEventListener(MouseEvent.CLICK, clickHandler);
			b.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			this.addChild(b);
		}
		
		private function onRollOut(evt:MouseEvent):void {
			this._image.y = this._topPadding;
			if (_useTooltip) {	
				this._tooltip.hide();
			} 
		}
		
		private function onNorthClick(evt:MouseEvent):void {
			this._map.panNorth(50);
		}
		
		private function onEastClick(evt:MouseEvent):void {
			this._map.panEast(50);
		}
		
		private function onWestClick(evt:MouseEvent):void {
			this._map.panWest(50);
		}
		
		private function onSouthClick(evt:MouseEvent):void {
			this._map.panSouth(50);
		}
		
		private function onCenterClick(evt:MouseEvent):void {
			//TODO:does this do anything?
		}
		
		private function onNorthOver(evt:MouseEvent):void {
			this._image.y = this._topPadding - 36;
			if (_useTooltip) {	
				this._tooltip.show(evt,"Pan North",0,-8);
			}
		}
		
		private function onEastOver(evt:MouseEvent):void {
			this._image.y = this._topPadding - 72;
			if (_useTooltip) {	
				this._tooltip.show(evt,"Pan East",0,-8);
			}
		}
		
		private function onWestOver(evt:MouseEvent):void {
			this._image.y = this._topPadding - 144;
			if (_useTooltip) {	
				this._tooltip.show(evt,"Pan West",0,-8);
			}
		}
		
		private function onSouthOver(evt:MouseEvent):void {
			this._image.y = this._topPadding - 108;
			if (_useTooltip) {	
				this._tooltip.show(evt,"Pan South",0,-8);
			}
		}
		
		private function onCenterOver(evt:MouseEvent):void {
			this._image.y = this._topPadding - 180;
		}
		
		/**
		 * Get the height of the control
		 */
		override public function getHeight():int {
			return 40;
		}
		
		/**
		 * Get the width of the control
		 */
		override public function getWidth():int {
			return 40;
		}
	}	// End Class

}
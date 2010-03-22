package com.aol.mq.ptype.view
{
	import com.mapquest.Constants;
	import com.mapquest.tilemap.*;
	import com.mapquest.tilemap.controls.oceanbreeze.OBDrawnBackgroundControl;
	import com.aol.mq.ptype.view.OBPanControl;
	import com.mapquest.tilemap.util.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	public class WinstonMapZoomControl extends  OBDrawnBackgroundControl {
		private var _arrLoaders:Array = new Array();
		
		private var _panImage:MaskedAssetLoader;
		private var _panMask:Shape;
		private var _panUrl:String = "http://www.aolcdn.com/widgetsmapquest/zoomcontrols.png"//Config.CDN_URL + "slidezoom_sprite.png";
		private var _panImageX:Number = -45;
		private var _panImageY:Number = -1;
		
		private var _northButton:Sprite;
		private var _eastButton:Sprite;
		private var _westButton:Sprite;
		private var _southButton:Sprite;
		private var _centerButton:Sprite;
		
		
		private var _imgUrl:String = "http://www.aolcdn.com/widgetsmapquest/zoomcontrols.png"//Config.CDN_URL + "slidezoom_sprite.png";
		
		private var _zoomIn:MaskedAssetLoader;
		private var _zoomInMask:Shape;
		
		private var _zoomOut:MaskedAssetLoader;
		private var _zoomOutMask:Shape;
		
		private var _zoomBar:MaskedAssetLoader;
		private var _zoomBarMask:Shape;
		
		private var _zoomIndicator:MaskedAssetLoader;
		private var _zoomIndicatorMask:Shape;
		
		private var _zoomIndicatorHolder:Sprite;
		
		private var _panControl:OBPanControl;
		
		
		//private var arrZoomIndicatorY:Array = [0,202,192,182,172,162,152,142,132,122,112,102,92,82,72,62,52];
		private var _arrZoomIndicatorY:Array = [0,202,192,182,172,162,152,142,132,122,112,102,92,82,72,62,52];
		
		private var _dragRect:Rectangle = new Rectangle(0, 52, 0, 150);//holder contains height of 52px so 202-52 = 150
		
		private var _topPadding:int = -1;
		
		private var _tooltip:com.mapquest.tilemap.util.Tooltip;
		private var _useTooltip:Boolean;
		private var _showShadow:Boolean;
		
		/**
		 * OBLargeZoomControl is a displayable control that contains
		 * a 16 position zoom bar, zoom in/out buttons and a pan bar.
		 * @constructor
		 */
		public function WinstonMapZoomControl(useShadow:Boolean=false,useTooltip:Boolean=true) {
			super();
			_backgroundWidth = getWidth();
			_backgroundHeight = getHeight();
			this.draw();
			//this.visible = false;
			
			this._showShadow = useShadow;
			if (this._showShadow) {
				this.addChild(this._background.shadow);
			}
			
			this._type = Constants.CONTROL_PANZOOM;
			this._position = new MapCornerPlacement(MapCorner.TOP_LEFT, new Size(5, 30));
			
			this._zoomIndicator = new MaskedAssetLoader(this._imgUrl,-81,0,this.checkAssetsLoaded,this.onSpriteLoadError);
			this._arrLoaders.push(this._zoomIndicator);
			this.addChild(this._zoomIndicator);
			this._zoomIndicator.addEventListener(MouseEvent.MOUSE_OVER,this.onZoomIndicatorOver);
			this._zoomIndicatorMask = this._zoomIndicator.createMask(this._zoomIndicator, 90, 8, 21, 9);
			
			this.addEventListener(MouseEvent.MOUSE_OUT,this.onControlOut);
			
			this._zoomBar = new MaskedAssetLoader(this._imgUrl,-3,-3,this.checkAssetsLoaded,this.onSpriteLoadError);
			this.addChild(this._zoomBar);
			this._arrLoaders.push(this._zoomBar);
			this._zoomBar.addEventListener(MouseEvent.CLICK, this.onZoomBarClick);
			this._zoomBarMask = this._zoomBar.createMask(this._zoomBar, 0, 0, 43, 253);
			
			this._zoomIn = new MaskedAssetLoader(this._imgUrl,-81,0,this.checkAssetsLoaded,this.onSpriteLoadError);
			this.addChild(this._zoomIn);
			this._arrLoaders.push(this._zoomIn);
			this._zoomIn.addEventListener(MouseEvent.CLICK, this.onZoomInClick);
			this._zoomIn.addEventListener(MouseEvent.MOUSE_OVER, this.onZoomInOver);
			this._zoomIn.addEventListener(MouseEvent.MOUSE_OUT, this.onZoomInOut);
			this._zoomInMask = this._zoomIn.createMask(this._zoomIn, 92, 41, 17, 17);
			
			this._zoomOut = new MaskedAssetLoader(this._imgUrl,-81,145,this.checkAssetsLoaded,this.onSpriteLoadError);
			this.addChild(this._zoomOut);
			this._arrLoaders.push(this._zoomOut);
			this._zoomOut.addEventListener(MouseEvent.CLICK, this.onZoomOutClick);
			this._zoomOut.addEventListener(MouseEvent.MOUSE_OVER, this.onZoomOutOver);
			this._zoomOut.addEventListener(MouseEvent.MOUSE_OUT, this.onZoomOutOut);
			this._zoomOutMask = this._zoomOut.createMask(this._zoomOut, 92, 81, 17, 17);
			
			
			
			this.makeZoomIndicatorHolder();
			
			this._panControl = new OBPanControl();
			this._panControl.includeBackground = (false);
			this.addChild(this._panControl);
			
			this._useTooltip = useTooltip;
			if (useTooltip) {
				this._tooltip = new Tooltip();
			}
			
			
		}
		
		
		private function onSpriteLoadError(e:IOErrorEvent):void {
			throw new Error(e.text);
		}
		
		
		private function makeZoomIndicatorHolder():void {
			this._zoomIndicatorHolder = new Sprite();
			this._zoomIndicatorHolder.alpha = 1;
			this._zoomIndicatorHolder.graphics.beginFill(0x00FF00);
			this._zoomIndicatorHolder.graphics.drawRect(0, 0, 0, 0);
			this._zoomIndicatorHolder.graphics.endFill();
			this._zoomIndicatorHolder.y = this._arrZoomIndicatorY[1];
			this._zoomIndicatorHolder.addEventListener(MouseEvent.MOUSE_DOWN, this.onIndicatorDown);
			this._zoomIndicatorHolder.addEventListener(MouseEvent.MOUSE_UP, this.onIndicatorUp);
			this._zoomIndicatorHolder.addChild(this._zoomIndicator);
			this._zoomIndicatorHolder.addChild(this._zoomIndicatorMask);
			this.addChild(this._zoomIndicatorHolder);
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
					if (_useTooltip) {
						this.addChild(this._tooltip);
					}
					this._map.addEventListener(TileMapEvent.ZOOM_END, this.onZoomChange);
					var evt:TileMapEvent = new TileMapEvent(TileMapEvent.ZOOM_END);
					this.onZoomChange(evt);
					//this.visible = true;
				}
			}
		}
		
		
		override protected function draw():void {
			this._type = Constants.CONTROL_PANZOOM;
			
			this._position = new MapCornerPlacement(MapCorner.TOP_LEFT, new Size(5, 30));
			super.draw();
		}
		
		/**
		 * Called by AddControl function after attaching to a map window.
		 * @private
		 */
		override public function initialize(map:TileMap):void {
			super.initialize(map);
			this._panControl.initialize(map);
		}
		
		
		
		private function onZoomChange(e:TileMapEvent):void {
			this._zoomIndicatorHolder.y = this._arrZoomIndicatorY[this._map.zoomLevel];
		}
		
		private function onControlOut(e:MouseEvent):void {
			if (_useTooltip) {
				this._tooltip.hide();
			}
			if (e.relatedObject != this._zoomIndicatorHolder) {
				this.stopIndicatorDrag();
			}
		}
		
		private function onZoomIndicatorOver(e:MouseEvent):void {
			if (_useTooltip) {
				this._tooltip.show(e,"Zoom Level " + this._map.zoomLevel,107, this._zoomIndicatorHolder.y);
			}
		}
		
		private function onIndicatorDown(e:MouseEvent):void {
			if (_useTooltip) {
				this._tooltip.hide();
			}
			this._zoomIndicatorHolder.useHandCursor = true;
			this._zoomIndicatorHolder.startDrag(false,this._dragRect);
		}
		
		
		private function onIndicatorUp(e:MouseEvent):void {
			this.stopIndicatorDrag();
		}
		
		private function stopIndicatorDrag():void {
			if (_map == null) return;
			
			this._zoomIndicatorHolder.stopDrag();
			this._zoomIndicatorHolder.useHandCursor = false;
			
			var dropY:int = this._zoomIndicatorHolder.y;
			
			if (dropY > this._arrZoomIndicatorY[2]) { //handle ZL1
				this._map.zoomLevel = (1);
				this._zoomIndicatorHolder.y = this._arrZoomIndicatorY[this._map.zoomLevel];
			}
			else if (dropY < this._arrZoomIndicatorY[15]) { //handle ZL16
				this._map.zoomLevel = (16);
				this._zoomIndicatorHolder.y = this._arrZoomIndicatorY[this._map.zoomLevel];
			}
			else {	//all other ZLs
				for (var i:int = 1; i <= this._arrZoomIndicatorY.length; i++) {
					
					if (dropY < this._arrZoomIndicatorY[i] && dropY > this._arrZoomIndicatorY[(i+1)]) {
						if ((dropY - this._arrZoomIndicatorY[(i+1)]) < (this._arrZoomIndicatorY[i]-dropY)) {
							//closer to the smaller one, lets use it.
							i++;
						}
						this._map.zoomLevel = (i);
						this._zoomIndicatorHolder.y = this._arrZoomIndicatorY[this._map.zoomLevel];
					}
				}
			}
		}
		
		
		private function onZoomBarClick(e:MouseEvent):void {
			var offset:int = 16;
			var clickY:int = e.localY;
			
			for (var i:int = 1; i <= this._arrZoomIndicatorY.length; i++) {
				if (clickY >= 65 && clickY <= 224) {
					if (clickY <= (this._arrZoomIndicatorY[i] + offset) && clickY >= (this._arrZoomIndicatorY[(i+1)] + offset)) {
						this._map.zoomLevel = (i);
						this._zoomIndicatorHolder.y = this._arrZoomIndicatorY[i];
					}
					else if (clickY < (this._arrZoomIndicatorY[16] + offset)) {
						this._map.zoomLevel = (16);
						this._zoomIndicatorHolder.y = this._arrZoomIndicatorY[16];
					}
					else if (clickY > (this._arrZoomIndicatorY[1] + offset)) {
						this._map.zoomLevel = (1);
						this._zoomIndicatorHolder.y = this._arrZoomIndicatorY[1];
					}
				}
			}
		}
		
		
		
		private function onZoomOutClick(evt:MouseEvent):void {
			this._map.zoomOut();
		}
		
		private function onZoomOutOver(evt:MouseEvent):void {
			this._zoomOut.y = this._zoomOutMask.y - 21;
			if (_useTooltip) {
				this._tooltip.show(evt,"Zoom Out", 110, 96);
			}
		}
		
		private function onZoomOutOut(evt:MouseEvent):void {
			this._zoomOut.y = this._zoomOutMask.y;
			if (_useTooltip) {
				this._tooltip.hide();
			}
		}
		
		private function onZoomInClick(evt:MouseEvent):void {
			this._map.zoomIn();
		}
		
		private function onZoomInOver(evt:MouseEvent):void {
			this._zoomIn.y = this._zoomInMask.y - 21;
			if (_useTooltip) {
				this._tooltip.show(evt,"Zoom In", 110, 55);
			}
		}
		
		private function onZoomInOut(evt:MouseEvent):void {
			this._zoomIn.y = this._zoomInMask.y;
			if (_useTooltip) {
				this._tooltip.hide();
			}
		}
		
		/**
		 *get the height of the control 
		 * @return 
		 * 
		 */
		override public function getHeight():int {
			return 250;
		}
		
		/**
		 * Get the width of the control
		 */
		override public function getWidth():int {
			return 40;
		}
		
	}	// End Class

}
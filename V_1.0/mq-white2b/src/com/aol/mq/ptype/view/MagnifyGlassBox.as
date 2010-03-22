package com.aol.mq.ptype.view
{
	
	import com.mapquest.tilemap.TileMap;
	import com.mapquest.tilemap.controls.oceanbreeze.OBDrawnBackgroundControl;
	
	import mx.controls.Button;
	
	public class MagnifyGlassBox extends OBDrawnBackgroundControl
	{
		public function MagnifyGlassBox(map:TileMap)
		{
			
			super();
			super.initialize(map);
			init()
		}
		private function init():void	{
		var btn:Button = new Button();
		this.addChild(btn);
			
		}
		
		
	}
}
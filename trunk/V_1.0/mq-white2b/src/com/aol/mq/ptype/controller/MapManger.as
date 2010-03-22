package com.aol.mq.ptype.controller
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MapManger extends EventDispatcher
	{
		private static var _instance:MapManger;
		
		public function MapManger(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function getInstance():MapManger	{
			if(_instance == null)	{
				_instance = new MapManger();
			}
			return _instance;
		}
	}
}
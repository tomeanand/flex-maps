package com.aol.mq.ptype.events
{
	import flash.events.Event;
	
	public class WinstonEvent extends Event
	{
		public var data : *;
		
		public function WinstonEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}
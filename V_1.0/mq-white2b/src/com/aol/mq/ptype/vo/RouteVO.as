package com.aol.mq.ptype.vo
{
	import mx.collections.ArrayCollection;

	public class RouteVO
	{
		public var distance:String;
		public var time:String;
		public var formattedTime:String;
		public var maneuver:ArrayCollection;
		
		public function RouteVO(distance:String,
		time:String, formatTime:String, maneuvers:ArrayCollection)
		{
			this.distance = distance;
			this.time = time;
			this.formattedTime = formatTime;
			this.maneuver = maneuvers;
		}
	}
}
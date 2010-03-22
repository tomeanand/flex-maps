package com.aol.mq.ptype.vo
{
	import com.mapquest.LatLng;

	public class SearchVO
	{
		public var slNo:Number
		public var id:Number;
		public var name:String;
		public var title:String;
		public var address:String;
		public var city:String;
		public var state:String;
		public var zip:String;
		public var country:String;
		public var phone:String;
		public var website:String;
		public var latlng:LatLng;
		public function SearchVO(sl:Number,id:Number,name:String,title:String,address:String,city:String,state:String,zip:String,country:String,phone:String,web:String,latlng:LatLng)
		{
			this.slNo = sl;
			this.id = id;
			this.name = name;
			this.title = title;
			this.address = address;
			this.city =city;
			this.state = state;
			this.zip = zip;
			this.country = country;
			this.phone = phone;
			this.website = web;
			this.latlng =latlng;
		}
		
		
	}
}
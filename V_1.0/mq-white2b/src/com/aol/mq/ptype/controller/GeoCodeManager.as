package com.aol.mq.ptype.controller
{
	import com.aol.mq.ptype.events.WinstonEvent;
	import com.mapquest.services.geocode.Geocoder;
	import com.mapquest.services.geocode.GeocoderEvent;
	import com.mapquest.services.geocode.GeocoderLocation;
	import com.mapquest.services.geocode.GeocoderOptions;
	import com.mapquest.services.geocode.GeocoderResponse;
	import com.mapquest.tilemap.TileMap;
	import com.aol.mq.ptype.utils.Constant;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class GeoCodeManager extends EventDispatcher
	{
		private var geocoder:Geocoder;
		private var locations:Array;
		private var locationCollection:ArrayCollection;
		private var index:Number = 0;
		
		public function GeoCodeManager(tileMap:TileMap)
		{
			var geoeOption:GeocoderOptions = new GeocoderOptions(6,true,null,true);
			geocoder = new Geocoder(tileMap,geoeOption);
			geocoder.addEventListener(GeocoderEvent.GEOCODE_RESPONSE,onGeoCode);
			geocoder.addEventListener(GeocoderEvent.REVERSE_GEOCODE_RESPONSE,onReverseGeoCode);
			geocoder.addEventListener(GeocoderEvent.GEOCODE_ERROR_EVENT,onErroGeoCode);
		}
		
		private function onGeoCode(event:GeocoderEvent):void	{
			var geoRes:GeocoderResponse = event.geocoderResponse as GeocoderResponse;
			if(geoRes.locations.length<0)	{
				locationCollection.addItem([new GeocoderLocation(locations[index])])
			}
			else	{
				locationCollection.addItem(geoRes.locations);
			}
			index++;
			trace(index + "  -------  \n\n")
			if(index<locations.length)	{
				geocoder.geocode(locations[index]);
				
			}
			else	{
				
				this.dispatchEvent(new WinstonEvent(Constant.EVENT_GEOCODED_AMBIGUITIES,locationCollection));
				index = 0;
			}
			
		}
		private function onReverseGeoCode(event:GeocoderEvent):void	{
			
		}
		private function onErroGeoCode(event:GeocoderEvent):void	{
			
		}
		
		public function batchGeoCode(locations:Array):void	{
			index = 0;
			locationCollection = new ArrayCollection();
			this.locations = locations;
			geocoder.geocode(locations[index]);
		}
	}
}
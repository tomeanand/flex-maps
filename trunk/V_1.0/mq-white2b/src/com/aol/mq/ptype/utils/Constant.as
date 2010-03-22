package com.aol.mq.ptype.utils
{
	public class Constant
	{
		public static const BUSINESS_SEARCH_API:String = "http://corrosion:48000/sapi.v2/mqxmlv6?query=businessQuery%27s&location=searchInLocation&hits=totalResults&offset=0&resubmitflags=8050&sortby=rp_geo_bbd&sortdirection=descending&qtf_geosearch:radius=25&qtf_geosearch:unit=mi&geo_type_circular=on&clientid=6703&engine=GSS&geocodeMode=2Box"
		// replacing the above strings in the businessQuery searchInLocation,totalResults
		public static const EVENT_SEARCH_PLACE : String = "SearchPlace";
		public static const EVENT_SEARCH_BUSINESS : String = "SearchBusiness";
		public static const EVENT_SEARCH_DIRECTIONS : String = "SearchDirections";
		public static const EVENT_SHOW_DIRECTIONS : String = "ShowDirections";
		public static const EVENT_DELETE_QUERY : String = "DeleteQuery";
		public static const EVENT_GEOCODED_AMBIGUITIES : String = "GeoAmbiguitis";
		public static const EVENT_DISAMBIGUITIED : String = "DisAmbiguited";
		public static const EVENT_ROUTE_SELECT_SUCCESS : String = "RouteSelectSuccess";
		public static const EVENT_BUSINESS_LOCATED_SUCEESS : String = "BusinessLocated";
		
		public static const ROUTE_POINTS : Array = [{index:0,data:"A"},{index:1,data:"B"},{index:3,data:"C"},{index:4,data:"D"},{index:5,data:"E"},
			{index:6,data:"F"},{index:7,data:"G"},{index:8,data:"H"},{index:9,data:"I"},{index:10,data:"J"},{index:11,data:"K"},{index:12,data:"L"}]
			
		public static const ROW_PER_PAGE : Number = 5;
		public static const ROUTE_PER_PAGE : Number = 7;
		
		public static var MODE_SEARCH_BUSINESS : String = "SearchBusiness";
		public static var MODE_SEARCH_ROUTE : String = "SearchRoute";
		
		public static const MAP_KEY : String = "Dmjtd|lu612007nq%2C20%3Do5-50zah";//"Dmjtd%7Cluu721ua2g%2Cag%3Do5-5a8n5"//"mjtd%7Clu6y206bng%2C25%3Do5-lwbw0";
		
			
		// Images for Bizlocators		
		[Embed (source="assets/images/mq-white2b/bwestern.png")]
		public static const  IMGBESTWESTERN:Class;
		
		[Embed (source="assets/images/mq-white2b/gas.png")]
		public static const  IMGGAS:Class;
		
		[Embed (source="assets/images/mq-white2b/hospital.png")]
		public static const  IMGHOSPITAL:Class;
		
		[Embed (source="assets/images/mq-white2b/shield.png")]
		public static const  IMGSHIELD:Class;
		
		[Embed (source="assets/images/mq-white2b/movie.png")]
		public static const  IMGMOVIE:Class;
		
		[Embed (source="assets/images/mq-white2b/restaureant.png")]
		public static const  IMGRESTAURANT:Class;
		
		public static const BIZ_LOCATOR_LIST : Array = new Array(
			{name:"Best Western", img:IMGBESTWESTERN},
			{name:"Gas Station", img:IMGGAS},
			{name:"Hospital", img:IMGHOSPITAL},
			{name:"Salvation Army", img:IMGSHIELD},
			{name:"Movies", img:IMGMOVIE},
			{name:"Restaurant", img:IMGRESTAURANT}
			);
			
		//===============TILE SERVERS==============================
		/**
		 * @private
		 */
		private static var _MAPSERVER:Array = ["tile21.mqcdn.com", "tile22.mqcdn.com", "tile23.mqcdn.com", "tile24.mqcdn.com"];
		
		public static function get MAPSERVER():Array {
			return _MAPSERVER;
		}
		
		public static function set MAPSERVER( value:Array ) : void {
			_MAPSERVER = value;
		}
		
		
		/**
		 * @private
		 */
		private static var _HYBSERVER:Array = ["tile21.mqcdn.com", "tile22.mqcdn.com", "tile23.mqcdn.com", "tile24.mqcdn.com"];
		
		public static function get HYBSERVER():Array {
			return _HYBSERVER;
		}
		
		public static function set HYBSERVER( value:Array ) : void {
			_HYBSERVER = value;
		}
		
		
		/**
		 * @private
		 */
		private static var _SATSERVER:Array = ["tile21.mqcdn.com", "tile22.mqcdn.com", "tile23.mqcdn.com", "tile24.mqcdn.com"];
		
		public static function get SATSERVER():Array {
			return _SATSERVER;
		}
		
		public static function set SATSERVER( value:Array ) : void {
			_SATSERVER = value;
		}
		
		
		/**
		 * @private
		 */
		//production
		//public static var LOGSERVER:String = "btilelog.access.mapquest.com";
		//beta
		public static var LOG_SERVER:String = "btilelog.beta.mapquest.com";
		//dev
		//public static var LOGSERVER:String = "perish.office.aol.com:13700";
		//qa
		//public static var LOGSERVER:String = "perish.office.aol.com:12700";
		
		
		
		
		//=============COPYRIGHT INFO===========================
		/**
		 * @private
		 */
		private static var _COPYRIGHT_SERVER:String = "mq-dev-ll08.office.aol.com:16002";
		
		public static function get COPYRIGHT_SERVER():String {
			return _COPYRIGHT_SERVER;
		}
		
		public static function set COPYRIGHT_SERVER( value:String ):void{
			_COPYRIGHT_SERVER = value;
		}
		
		
		/**
		 * @private
		 */
		public static const COPYRIGHT_YEAR:String = "2010";
		
		
		
		
		//========= RESOURCES =================================
		/**
		 * @private
		 */
		private static var _RESOURCES_SERVER:String = "tile21.mqcdn.com";
		
		
		public static function get RESOURCES_SERVER():String {
			return _RESOURCES_SERVER;
		}
		
		public static function set RESOURCES_SERVER(value:String):void{
			_RESOURCES_SERVER = value;
		}
		
		
		/**
		 * @private
		 */
		private static var _RESOURCES_URL:String = "http://" + RESOURCES_SERVER + "/res/";
		
		public static function get RESOURCES_URL():String {
			return _RESOURCES_URL;
		}
		
		
		
		
		//==========TRAFFIC SERVER=====================================
		/**
		 * @private
		 */
		public static var TRAFFIC_SERVER:String = BETA_SERVER;
		
		/**
		 * @private
		 */
		public static const TRAFFIC_HELP_URL:String = "help.mapquest.com/jive/kbcategory.jspa?categoryID=66";
		
		private static const TRAFFIC_VERSION:String = "v1";
		
		private static const TRAFFIC_BASE_URL:String = "http://" + BETA_SERVER + "/traffic/" + TRAFFIC_VERSION + "/";
		
		public static const TRAFFIC_URL_INCIDENTS:String = TRAFFIC_BASE_URL + "incidents?";
		
		public static const TRAFFIC_URL_FLOW:String = TRAFFIC_BASE_URL + "flow?";
		
		public static const TRAFFIC_URL_MARKETS:String = TRAFFIC_BASE_URL + "markets?";
		
		
		//==========CONTENT DELIVERY NETWORK SERVER=====================
		/**
		 * @private
		 */
		public static const CDN_SERVER:String = "www.aolcdn.com";
		/**
		 * @private
		 */
		public static const CDN_PATH:String = "/mqtoolkit/";
		/**
		 * @private
		 */
		public static const CDN_URL:String = "http://" + CDN_SERVER + CDN_PATH;
		
		//www.aolcdn.com/mqtoolkit/mapviewcontrol-dotcom2.png
		
		//============PLATFORM SERVER=============================
		/**
		 * @private
		 */
		//prod
		public static const PLATFORM_SERVER:String = "www.mapquestapi.com";
		//beta
		//public static var PLATFORM_SERVER:String = "platform.beta.mapquest.com";
		//dev
		//public static var PLATFORM_SERVER:String = "mq-vm14.office.aol.com:6600";
		
		
		
		//============BETA SERVER=============================
		/**
		 * @private
		 */
		//prod
		public static const BETA_SERVER:String = "platform.beta.mapquest.com";
		
		
		
		//============DIRECTIONS INFORMATION=============================
		/**
		 * @private
		 */
		public static const DIRECTIONS_PATH:String = "directions";
		/**
		 * @private
		 */
		public static const DIRECTIONS_VERSION:String = "v1";
		
		
		
		
		//============SEARCH INFORMATION=============================
		//private static const SEARCH_BASE_URL:String = "http://10.167.98.158:2002/search/v1/";
		
		private static const SEARCH_VERSION:String = "v1";
		
		private static const SEARCH_BASE_URL:String = "http://" + BETA_SERVER + "/search/" + SEARCH_VERSION + "/";
		
		public static const SEARCH_URL_SEARCH:String = SEARCH_BASE_URL + "search?";
		
		public static const SEARCH_URL_RADIUS:String = SEARCH_BASE_URL + "radius?";
		
		public static const SEARCH_URL_RECTANGLE:String = SEARCH_BASE_URL + "rectangle?";
		
		public static const SEARCH_URL_POLYGON:String = SEARCH_BASE_URL + "polygon?";
		
		public static const SEARCH_URL_CORRIDOR:String = SEARCH_BASE_URL + "corridor?";
		
		public static const SEARCH_URL_RECORDINFO:String = SEARCH_BASE_URL + "recordInfo?";
		
		
		
		//============GEOCODE INFORMATION=============================
		public static const GEOCODE_VERSION:String = "v1";
		
		private static const GEOCODE_BASE_URL:String = "http://" + PLATFORM_SERVER + "/geocoding/" + GEOCODE_VERSION + "/";
		
		public static const GEOCODE_URL:String = GEOCODE_BASE_URL + "address?";
		
		public static const GEOCODE_URL_REVERSE:String = GEOCODE_BASE_URL + "reverse?";
		
		public static const GEOCODE_URL_BATCH:String = GEOCODE_BASE_URL + "batch?";
		
		
		
		
		
		//========  SDK VERSION  ==============================================================
		/**
		 * @private
		 */
		internal static var _SDK_VERSION:String = "6.0.0_RC9";
		
		/**
		 * @private
		 */
		public static function get SDK_VERSION():String{
			return _SDK_VERSION;
		}
		
		
		
		
		
		//====== assorted =========================
		/**
		 * @private
		 */
		public static var PIXERSPERLATDEGREE:Number = 315552459.66191697;
		/**
		 * @private
		 */
		public static var PIXERSPERLNGDEGREE:Number = 250344597.90989706;
		/**
		 * @private
		 */
		public static var SCALES:Array = [0, 88011773, 29337258, 9779086, 3520471, 1504475, 701289, 324767, 154950, 74999, 36000, 18000, 9000, 4700, 2500, 1500, 1000];
		/**
		 * @private
		 */
		public static var MODS:Array = [0, 4, 12, 36, 100, 234, 502, 1084, 2272, 4694, 9778, 19558, 39116, 74900, 140818, 234698, 352047];
		/**
		 * @private
		 */
		public static var TILESIZE:int = 256;		
		

		
	}
}
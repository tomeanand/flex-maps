package com.aol.mq.ptype.model
{
	import com.aol.mq.ptype.utils.Constant;
	import com.aol.mq.ptype.view.MapPanel;
	import com.aol.mq.ptype.view.comps.AmbiguitiesBox;
	import com.aol.mq.ptype.vo.RouteVO;
	import com.mapquest.tilemap.ShapeCollection;
	
	import mx.collections.ArrayCollection;

	[Bidnable]
	public class ModelLocator
	{
		private static var _instance:ModelLocator;
		
		public var bizData:ArrayCollection;
		public var routeVO:RouteVO;
		public var isRoute:Boolean = false;
		public var mapMode:String
		public var ambigutiy:AmbiguitiesBox;
		public var totalAmbiguites:Number = 0;
		
		public var searchQueryStr:String = "";
		public var searchOrigin:String = "";
		public var shapeCollection:ShapeCollection;
		
		public var mapPanel:MapPanel;
		
		
		public static function getInstance():ModelLocator	{
			if(_instance == null)	{
				_instance = new ModelLocator();
			}
			return _instance;
		}
		public function getPageBizData(index:Number):ArrayCollection	{
			var data:ArrayCollection = new ArrayCollection();
			var startIndex:Number = index * Constant.ROW_PER_PAGE
			var endIndex:Number = index * Constant.ROW_PER_PAGE + Constant.ROW_PER_PAGE
			endIndex = endIndex > this.bizData.length ? this.bizData.length : endIndex;
			for(var i:Number = startIndex; i<endIndex; i++)	{
				data.addItem(bizData[i]);
			}
			//var data:Array = this.bizData.getItemAt(slice(startIndex,endIndex)
			return data;
		}
		public function getPageManvrData(index:Number):ArrayCollection	{
			var data:ArrayCollection = new ArrayCollection();
			var startIndex:Number = index * Constant.ROUTE_PER_PAGE
			var endIndex:Number = index * Constant.ROUTE_PER_PAGE + Constant.ROUTE_PER_PAGE
			endIndex = endIndex > this.routeVO.maneuver.length ? this.routeVO.maneuver.length : endIndex;
			for(var i:Number = startIndex; i<endIndex; i++)	{
				data.addItem(routeVO.maneuver[i]);
			}
			//var data:Array = this.bizData.getItemAt(slice(startIndex,endIndex)
			return data;
		}		
		
		
	}
}
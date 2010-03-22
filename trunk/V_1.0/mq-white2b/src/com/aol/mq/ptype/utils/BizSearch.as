package com.aol.mq.ptype.utils
{
	import com.aol.mq.ptype.controller.MapManger;
	import com.aol.mq.ptype.events.WinstonEvent;
	import com.aol.mq.ptype.model.ModelLocator;
	import com.aol.mq.ptype.vo.SearchVO;
	import com.mapquest.LatLng;
	import com.mapquest.tilemap.ShapeCollection;
	import com.mapquest.tilemap.pois.MapIcon;
	import com.mapquest.tilemap.pois.Poi;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class BizSearch implements IEventDispatcher
	{
		private var httpService:HTTPService;
		private var count:Number = 0;
		private var isBizLocator:Boolean = false;
		private var bizItem:Object;
		
		public function BizSearch()
		{
			init();
		}
		
		public function init():void	{
			httpService = new HTTPService();
			httpService.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			httpService.addEventListener(ResultEvent.RESULT,onResult);
			httpService.addEventListener(FaultEvent.FAULT,onError);
		}
		private function onResult(event:ResultEvent):void	{
			var model:ModelLocator = ModelLocator.getInstance();
			count = 0;
			var biz:XML
			var bizCollection:ArrayCollection = new ArrayCollection();
			var xml:XML = new XML(event.result)
			var data:XMLList = xml.SearchResponse.resultset.results;
			if(!isBizLocator)	{
				for each(biz in data.result)	{
					var bizVO:SearchVO = createSearchData(biz);
					bizCollection.addItem(bizVO);
				}
				model.bizData = bizCollection;
				if(bizCollection.length != 0)	{
					//checking the origination of search
					if(model.searchOrigin == Constant.SEARCH_FROM_BOX)	{
						MapManger.getInstance().dispatchEvent(new WinstonEvent(Constant.EVENT_SEARCH_BUSINESS,bizCollection.getItemAt(0)));
					}
					else	{
						MapManger.getInstance().dispatchEvent(new WinstonEvent(Constant.EVENT_SEARCH_BUSINESS_FROM_MAP,bizCollection));
					}
						
				}
			}
			
			else	{
				var shapCollection:ShapeCollection = new ShapeCollection();
				for each(biz in data.result)	{
					var bizVO:SearchVO = createSearchData(biz);
					bizCollection.addItem(bizVO);
					shapCollection.add(createPOI(biz));
				}
				MapManger.getInstance().dispatchEvent(new WinstonEvent(Constant.EVENT_BUSINESS_LOCATED_SUCEESS,shapCollection));
				MapManger.getInstance().dispatchEvent(new WinstonEvent(Constant.EVENT_SEARCH_BUSINESS_FROM_MAP,bizCollection));
			}
			
		}
		private function onError(event:FaultEvent):void	{
			
		}
		private function createPOI(result:XML):Poi	{
			var latlng:LatLng = new LatLng();
			var mapIcon:MapIcon = new MapIcon();
			var altIcon:MapIcon = new MapIcon();
			mapIcon.setImage(new bizItem.img,22,22);
			altIcon.setImage(new bizItem.img,15,15);

			latlng.setLatLng(Number(result.latitude),Number(result.longitude));
			var poi:Poi = new Poi(latlng);
			poi.icon = mapIcon;
			poi.altIcon = altIcon;
			poi.label = String(bizItem.name).substring(0,1).toUpperCase();
			poi.infoTitle = result.address+" - "+bizItem.name;
			poi.infoContent =result.address+", "+ result.city+", "+result.state+"\n"+result.zip+"\n Phone : "+result.phone
			return poi;
		}
		private function createSearchData(result:XML):SearchVO	{
			count++
			var latlng:LatLng = new LatLng();
			latlng.setLatLng(Number(result.latitude),Number(result.longitude));
			var vo:SearchVO = new SearchVO(count,Number(result.id),
				String(result.name),
				String(result.title),
				String(result.address),
				String(result.city),
				String(result.state),
				String(result.zip),
				String(result.country),
				String(result.phone),
				String(result.website),
				latlng)
				return vo;
		}
		public function doSearch(bizQuery:String,location:String = "",resultCount:Number = 10):void	{
			isBizLocator = false;
			var url:String = Constant.BUSINESS_SEARCH_API.replace("businessQuery",bizQuery);
			url = url.replace("searchInLocation",location);
			url = url.replace("totalResults",resultCount.toString());
			//var newurl:String = "http://sls.access.mapquest.com/sapi.v2/mqxmlv5?clientID=9014&geocodeMode=2BOX&query="+bizQuery+"&location="+location+"&units=mi&sortBy=geo_sort_filter&sortDirection=ascending&hits=5&offset=0&resubmitflags=8050"
			//var url:String = "http://10.146.178.100:8888/mail/mqproxy?location="+encodeURIComponent(location)+"&bizQuery="+encodeURIComponent(bizQuery)+"&resultCount="+resultCount.toString();
			
			httpService.url = url;
			httpService.send();
		}
		
		public function doLocateBusiness(bizQuery:String,location:String = "",resultCount:Number = 10, bizItem:Object = null):void	{
			isBizLocator = true;
			this.bizItem = bizItem;
			var url:String = Constant.BUSINESS_SEARCH_API.replace("businessQuery",bizQuery);
			url = url.replace("searchInLocation",location);
			url = url.replace("totalResults",resultCount.toString());
			//var newurl:String = "http://sls.access.mapquest.com/sapi.v2/mqxmlv5?clientID=9014&geocodeMode=2BOX&query="+bizQuery+"&location="+location+"&units=mi&sortBy=geo_sort_filter&sortDirection=ascending&hits=5&offset=0&resubmitflags=8050"
			//var url:String = "http://10.146.178.100:8888/mail/mqproxy?location="+encodeURIComponent(location)+"&bizQuery="+encodeURIComponent(bizQuery)+"&resultCount="+resultCount.toString();
			
			httpService.url = url;
			httpService.send();
		}		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
	}
}
package com.aol.mq.ptype.view
{
	import com.aol.mq.ptype.controller.GeoCodeManager;
	import com.aol.mq.ptype.controller.MapManger;
	import com.aol.mq.ptype.events.WinstonEvent;
	import com.aol.mq.ptype.model.ModelLocator;
	import com.aol.mq.ptype.utils.BizSearch;
	import com.aol.mq.ptype.utils.Constant;
	import com.aol.mq.ptype.vo.ManeuverVO;
	import com.aol.mq.ptype.vo.RouteVO;
	import com.aol.mq.ptype.vo.SearchVO;
	import com.mapquest.*;
	import com.mapquest.services.directions.Directions;
	import com.mapquest.services.directions.DirectionsEvent;
	import com.mapquest.services.directions.DirectionsOptions;
	import com.mapquest.services.geocode.Geocoder;
	import com.mapquest.services.geocode.GeocoderEvent;
	import com.mapquest.services.geocode.GeocoderLocation;
	import com.mapquest.services.traffic.Traffic;
	import com.mapquest.tilemap.*;
	import com.mapquest.tilemap.controls.oceanbreeze.*;
	import com.mapquest.tilemap.pois.*;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.core.UIComponent;

	public class MapPanel extends UIComponent
	{
		
		
		public function MapPanel()
		{
			model.mapPanel = this;
			init();
		}

		public var map:TilemapComponent;
		
		[Bidnable]
		public var widthVal:Number = 770;
			
		[Embed (source="assets/images/mq-white2b/bwestern.png")]
		private var imgBestWestern:Class;
		
		[Embed (source="assets/images/mq-white2b/gas.png")]
		private var imgGas:Class;
		
		//embedded image resources
		[Embed (source="assets/images/mq-white2b/hospital.png")]
		private var imgHospital:Class;
		
		[Embed (source="assets/images/mq-white2b/shield.png")]
		private var imgShield:Class;
		
		[Embed (source="assets/images/mq-white2b/movie.png")]
		private var imgMovie:Class;
		
		[Embed (source="assets/images/mq-white2b/restaureant.png")]
		private var imgRestaurent:Class;
		
		private var bizSearch:BizSearch;
		private var carousel : OBCarouselControl;
		
		[Bindable]
		private var carouselItems : Array = new Array();
		
		private var direction:Directions;
		private var geoCoder:Geocoder;
		
		private var geoManager:GeoCodeManager
		private var model:ModelLocator = ModelLocator.getInstance();

		private var poi:Poi;
		private var poiCollection:ShapeCollection
		private var traffic:Traffic;
		
		private var selectedBusiness:String;
		private var selectedCarousalItem:OBCarouselItem
		
		private function  init():void	{
			map = new TilemapComponent();
			map.key = Constant.MAP_KEY;
			//map.width = 770;
			//map.height = 600;
			this.addChild(map);
			
			
			geoCoder = new Geocoder(map.tileMap);
			geoManager = new GeoCodeManager(map.tileMap);
			
			this.map.setCenter(new LatLng(39.430599,-77.808483),12);
			
			traffic =  new Traffic(this.map.tileMap);
			traffic.flowOpacity = 0.2;
			
			this.map.addControl(new WinstonMapZoomControl());
			this.map.addControl(new OBViewControl());
			map.addControl(new WinstonMapViewControl());
			
			this.poi = new Poi(this.map.center);
			this.map.addShape(this.poi);
			
			initialiseBizLocator();
			carousel = new OBCarouselControl( carouselItems, carouselItems.length );
			carousel.addEventListener(OBCarouselEvent.EVENT_ITEM_CLICK,onBizLocatorClick);
			map.addControl(carousel, new MapCornerPlacement(MapCorner.BOTTOM_LEFT,new Size(5,5)) );
			
			/*var mfGlass:MagnifyGlassBox = new MagnifyGlassBox(this.map.tileMap);
			this.map.addControl(mfGlass,new MapCornerPlacement(MapCorner.BOTTOM_LEFT,new Size(15,15)));*/
			
			this.map.addEventListener(TileMapEvent.ZOOM_END,onMapZoom);
			
			geoCoder.addEventListener(GeocoderEvent.REVERSE_GEOCODE_RESPONSE,onReverseGeoResponse);
			geoCoder.addEventListener(GeocoderEvent.HTTP_ERROR_EVENT,onHttpError);
			geoCoder.addEventListener(GeocoderEvent.GEOCODE_ERROR_EVENT,onGeoError);
			
			/**
			 *
			 * 
			 * */
			bizSearch = new BizSearch();
			MapManger.getInstance().addEventListener(Constant.EVENT_SEARCH_PLACE,showPlace);
			MapManger.getInstance().addEventListener(Constant.EVENT_SEARCH_BUSINESS,showBusiness);
			MapManger.getInstance().addEventListener(Constant.EVENT_BUSINESS_LOCATED_SUCEESS,businessLocated);
			MapManger.getInstance().addEventListener(Constant.EVENT_SEARCH_DIRECTIONS,geoCodeDirections);
			MapManger.getInstance().addEventListener(Constant.EVENT_ROUTE_SELECT_SUCCESS,showDirections);

		}

		private function onDirectionSuccessHandler(event:DirectionsEvent):void	{
			var manvrList:ArrayCollection = new ArrayCollection();
			var routeVO:RouteVO;
			var streetsStr:String = "";
			var latlng:LatLng
			if(event.type == DirectionsEvent.DIRECTIONS_SUCCESS)	{
				if(event.routeType == "route")	{
					var route:XML = event.legsXml as XML;
					
					var maneuvers:XMLList = route.leg.maneuvers.maneuver;
					
					for each(var manuervs:XML in maneuvers)	{
						latlng = new LatLng(Number(manuervs.startPoint.lat),Number(manuervs.startPoint.lng));
						streetsStr = ""
						if(manuervs.streets.street.length()>0)	{
							for each(var strt:XML in manuervs.streets.street) {
								streetsStr+= strt+", "; 
							}
						}						
						var manVO:ManeuverVO = new ManeuverVO(latlng,
							manuervs.distance,
							manuervs.time,
							manuervs.attributes,
							manuervs.turnType,
							manuervs.narrative,
							manuervs.direction,
							manuervs.directionName,
							manuervs.index,
							streetsStr,
							manuervs.iconUrl,
							manuervs.mapUrl);
						manvrList.addItem(manVO);
					}
					routeVO = new RouteVO(route.leg.distance,route.leg.time,route.leg.formattedTime,manvrList);
					model.routeVO = routeVO;
					MapManger.getInstance().dispatchEvent(new WinstonEvent(Constant.EVENT_SHOW_DIRECTIONS,null));
				}
			}
		}
		private function onGeoError(event:GeocoderEvent):void	{
			
		}
		
		private function onReverseGeoResponse(event:GeocoderEvent):void	{
			
			var locations:Array = event.geocoderResponse.locations as Array;
			if(locations.length>0)	{
				var geoLoc:GeocoderLocation = locations[0] as GeocoderLocation;
				bizSearch.doLocateBusiness(selectedBusiness,geoLoc.city+","+geoLoc.state,10,getClickedBizItem())
			}
			
		}
		private function onHttpError(event:GeocoderEvent):void	{
			
		}
		private function onMapZoom(event:TileMapEvent):void	{
			if (map.zoomLevel>= 8) {
				traffic.addFlow();
				traffic.addIncidents();
			}
			else	{
				traffic.removeFlow();
				traffic.removeIncidents();
			}
		}
		private function showBusiness(event:WinstonEvent):void	{
			var biz:ArrayCollection = model.bizData;
			var cursor:IViewCursor = biz.createCursor();
			var vo:SearchVO;
			map.removeShapes();
			
			poiCollection != null ? map.removeShapeCollection(poiCollection) : null;
			direction != null ? direction.removeRoute() : null;
		
			poiCollection = new ShapeCollection();
			while(!cursor.afterLast)	{
				vo = cursor.current as SearchVO;
				
				var poi:Poi = new Poi(vo.latlng);
				poi.infoTitle = vo.name+" "+vo.title;
				poi.infoContent = vo.address +"\n"+vo.phone
				//map.addShape(poi);
				poiCollection.add(poi)
				cursor.moveNext();
			}
			map.setCenter(vo.latlng,7);
			map.addShapeCollection(poiCollection);
			
		}
		private function geoCodeDirections(event:WinstonEvent):void	{
			map.removeShapes();
			poiCollection != null ? map.removeShapeCollection(poiCollection) : null;
			direction != null ? direction.removeRoute() : null;
			//geoCoder.geocode(event.data);
			geoManager.batchGeoCode(event.data)
				
		}
		private function showDirections(event:WinstonEvent):void	{
			map.removeShapes();
			poiCollection != null ? map.removeShapeCollection(poiCollection) : null;
			direction != null ? direction.removeRoute() : null;
			
			var dirOption:DirectionsOptions = new DirectionsOptions();
			dirOption.narrativeType = "html"; 
			
			direction = new Directions(this.map.tileMap,event.data.loc,dirOption);
			direction.addEventListener(DirectionsEvent.DIRECTIONS_SUCCESS,onDirectionSuccessHandler)
			direction.route();
		}
		public function removeAllShapes():void	{
			direction != null ? direction.removeRoute() : null;
			poiCollection != null ? map.removeShapeCollection(poiCollection) : null;
			map.removeShapes();
		}
		private function showPlace(event:WinstonEvent):void	{
			map.removeShapes();
			var query:Array = String(event.data).split(",");
			bizSearch.doSearch(query[0],query[1]+","+query[2],10);
				
		}
		/**
		 * 
		 * 
		 * 
		 * 
		 * */
		private function initialiseBizLocator():void	{
			var data:Array = Constant.BIZ_LOCATOR_LIST
			var icon : ImageMapIcon;
			var ci:OBCarouselItem;
			var shapeCollection:ShapeCollection;
			for(var i:Number = 0; i<data.length; i++)	{
				icon = new ImageMapIcon();
				icon.setImage(new data[i].img,30,30);
				shapeCollection = new ShapeCollection();
				ci = new OBCarouselItem(shapeCollection,data[i].name,icon);
				carouselItems.push(ci);
			}
		}
		
		private function onBizLocatorClick(event:OBCarouselEvent):void	{
			this.selectedBusiness = event.carouselItem.label
			
			geoCoder.reverseGeocode(map.center);
			
		}
		
		private function businessLocated(event:WinstonEvent):void	{
			/**
			 * Kludge
			 * Just to see the pois on the map
			 * will have to fix it in this point.
			 * */
			var ci:OBCarouselItem
			var bls:Array = Constant.BIZ_LOCATOR_LIST;
			for(var i:Number = 0; i<bls.length; i++)	{
				ci = carouselItems[i] as OBCarouselItem
				if(bls[i].name == this.selectedBusiness)	{
					ci.shapeCollection = event.data as ShapeCollection;
					map.addShapeCollection(event.data);
					ci.selected = true;
				}
				else	{
					map.removeShapeCollection(ci.shapeCollection);
					ci.selected = false;
				}
			}
			map.zoom = 5;
			
		}
		
		private function getClickedBizItem():Object	{
			var data:Array = Constant.BIZ_LOCATOR_LIST;
			var item:Object
			for(var i:Number = 0; i<data.length; i++)	{
				if(data[i].name == this.selectedBusiness)	{
					item =  data[i];
					break;
				}
			}
			return item;
		}
	}
}
package com.aol.mq.ptype.view
{
	import com.aol.mq.ptype.model.ModelLocator;
	import com.aol.mq.ptype.utils.Constant;
	import com.aol.mq.ptype.vo.SearchVO;
	import com.mapquest.tilemap.ShapeCollection;
	import com.mapquest.tilemap.pois.MapIcon;
	import com.mapquest.tilemap.pois.Poi;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;

	public class BaseResultBox extends Group
	{

		public var searchQueryStr:String="";
		[Bindable]
		public var isLoaded:Boolean=false;
		public var showMode:String;
		public var bizCollection:ArrayCollection;
		public var model:ModelLocator=ModelLocator.getInstance();

		public function BaseResultBox()
		{
			super();

		}

		public function minimize():void
		{
			model.mapPanel.removeAllShapes();
			model.mapPanel.map.removeShapeCollection(model.shapeCollection);
		}

		public function showBusiness():void
		{
			var bizFlag:Boolean = (this.showMode == Constant.MODE_BIZ_LOCATE_BOX ? true : false);
			
			var svo:SearchVO;
			var poi:Poi;
			var shapeCollection:ShapeCollection = new ShapeCollection();
			if (bizCollection != null)
			{
				for (var i:Number=0; i < bizCollection.length; i++)
				{
					

					svo=bizCollection[i] as SearchVO;
					if(!bizFlag)	{
						poi=new Poi(svo.latlng);
						poi.latLng=svo.latlng;
						poi.infoTitle=svo.address + " - " + svo.name;
						poi.infoContent=svo.address + ", " + svo.city + ", " + svo.state + "\n" + svo.zip + "\n Phone : " + svo.phone;
					}
					else	{
						poi = createPOI(svo);
					}
					shapeCollection.add(poi);
				}
				model.shapeCollection=shapeCollection;
				model.mapPanel.map.addShapeCollection(shapeCollection);
				model.mapPanel.map.setCenter(poi.latLng,8)
			}
		}
		
		private function createPOI(svo:SearchVO):Poi	{
			
			var mapIcon:MapIcon = new MapIcon();
			var altIcon:MapIcon = new MapIcon();
			var bizItem:Object = getClickedBizItem();
			mapIcon.setImage(new bizItem.img,22,22);
			altIcon.setImage(new bizItem.img,15,15);
			
			
			var poi:Poi = new Poi(svo.latlng);
			poi.icon = mapIcon;
			poi.altIcon = altIcon;
			poi.label = String(bizItem.name).substring(0,1).toUpperCase();
			poi.infoTitle = svo.address+" - "+svo.name;
			poi.infoContent =svo.address+", "+ svo.city+", "+svo.state+"\n"+svo.zip+"\n Phone : "+svo.phone
			return poi;
		}
		
		protected function getClickedBizItem():Object	{
			var data:Array = Constant.BIZ_LOCATOR_LIST;
			var item:Object
			for(var i:Number = 0; i<data.length; i++)	{
				if(data[i].name == this.searchQueryStr)	{
					item =  data[i];
					break;
				}
			}
			return item;
		}

	}
}
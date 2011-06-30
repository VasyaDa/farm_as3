package utils{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	import plants.*;
	
	public class Field extends DrawnIsoTile{
		
		private var INIT_clover:clover;
		private var INIT_potato:potato;
		private var INIT_sunflower:sunflower;
		
		public var _bgimage:String;
		public var _step:int;
		public var tile:DrawnIsoTile;
		public var bgBitmap:Bitmap;
		private var _storedObjects:Object;
		public var myPlant:main;
		public var indexAt:int;
		
		public function Field(fieldSize:int, bgcolor:uint, bgimage:String, storedObjects:Object, step:int):void
		{
			super(fieldSize,bgcolor);
			_storedObjects = storedObjects;
			_step = step;
			if (bgimage != '')
			{
				_bgimage = bgimage;
				drawBg();
			}
		}
		public function drawBg():void
		{
			var plantClass:Class = getDefinitionByName('plants.'+_bgimage) as Class; 
			myPlant = (new plantClass() as main);
			myPlant._imageStore = _storedObjects;
			myPlant.step = _step;
			addChild(myPlant);
		}
		public function errorLoadBg(e:IOErrorEvent):void
		{
			trace('Ошибка загрузки файла');
		}
	}
}
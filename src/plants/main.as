package plants
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import utils.LoadImageEvent;
	import utils.MyLoader;

	public class main extends Sprite
	{
		protected var _step:int = 0;
		public var _image:Loader;
		public var _imageStore:Object;
		public var _imageLoader:MyLoader;
		protected var _typePlant:String;
		public var offsets:Array;
		protected var _url:String;
		public function main(typePlant:String,offset:Array)
		{
			offsets = offset;
			_typePlant = typePlant;
		}
		public function set step(value:int):void
		{
			if ((_step != value) && (_typePlant != ''))
			{
				_step = value;
				updateScreenImage();
			}
		}
		public function set typePlant(value:String):void
		{
			_typePlant = value;
		}
		public function get step():int
		{
			return _step;
		}
		protected function updateScreenImage():void
		{
			_url = _typePlant+'/'+_step+'.png';
			
			_imageLoader = new MyLoader(_url,_imageStore);
			_imageLoader.addEventListener(LoadImageEvent.IMAGE_LOAD_COMPLETE,onImageComplete);
			_imageLoader.loadObject();
		}
		public function onImageComplete(e:LoadImageEvent):void
		{
			if (e.url == _url)
			{
				if (_image != null)
				{
					removeChild(_image);
				}
				
				_imageLoader.removeEventListener(LoadImageEvent.IMAGE_LOAD_COMPLETE,onImageComplete);
				_image = Loader(e.target);
				_image.x -= offsets[_step-1][0];
				_image.y -= offsets[_step-1][1];
				addChild(_image);
			}
		}
	}
}
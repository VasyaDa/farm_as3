package utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class MyLoader extends Loader
	{
		private static const BASE_URL:String = 'images/'; 
		private var objectURL:String; 
		private var urlRequest:URLRequest;
		private var storedObjects:Object;
		private var inCache:Boolean = false;
		private var loadProgress:Boolean = false;
		private var loadAtempt:int = 1;
		
		public function MyLoader(url:String,_imageStore:Object)
		{
			objectURL = url;
			storedObjects = _imageStore;
			if (storedObjects[objectURL] != null)
			{
				inCache = true;
			}
			else
			{
				storedObjects[objectURL] = 'progress';
				
				inCache = false;
				urlRequest = new URLRequest(BASE_URL+objectURL);
			}
		}
		public function loadObject():void
		{
				if (inCache)
				{
					if (storedObjects[objectURL] != 'progress')
					{
						contentLoaderInfo.addEventListener(Event.COMPLETE, onObjectLoad);
						loadBytes(storedObjects[objectURL]);
					}
					else if (loadAtempt <= 20)
					{
						setTimeout(loadObject,10*loadAtempt);
						loadAtempt++;
					}
				}
				else
				{
					contentLoaderInfo.addEventListener(Event.COMPLETE, onObjectLoad);
					load(urlRequest);
				}
		}
		private function onObjectLoad(e:Event):void
		{
			contentLoaderInfo.removeEventListener(Event.COMPLETE, onObjectLoad);
			storedObjects[objectURL] = contentLoaderInfo.bytes;
			dispatchEvent(new LoadImageEvent(LoadImageEvent.IMAGE_LOAD_COMPLETE,objectURL) );
		}
	}
}
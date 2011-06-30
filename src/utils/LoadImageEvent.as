package utils
{
	import flash.events.Event;
	public class LoadImageEvent extends Event
	{
		public static const IMAGE_LOAD_COMPLETE:String = 'imageLoadComplete';
		public var url:String;
		public function LoadImageEvent(type:String, _url:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			url = _url;
			super(type, bubbles, cancelable);
		}
		public override function toString():String { 
			return formatToString("loadImageEvent");
		}
	}
}
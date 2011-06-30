package utils
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	public class CustomButton extends SimpleButton
	{
		private var upColor:uint   = 0x999999;
		private var overColor:uint = 0x7C7C7C;
		private var downColor:uint = 0x9C9C9C;
		private var sizeX:uint      = 170;
		private var sizeY:uint      = 30;
		
		public function CustomButton(text:String,upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			downState      = new ButtonDisplayState(downColor, sizeX, sizeY, text);
			overState      = new ButtonDisplayState(overColor, sizeX, sizeY, text);
			upState        = new ButtonDisplayState(upColor, sizeX, sizeY, text);
			hitTestState   = new ButtonDisplayState(upColor, sizeX, sizeY, text);
			useHandCursor  = true;
			
			super(upState,overState,downState,hitTestState);
		}
		public function set text(value:String):void
		{
			ButtonDisplayState(downState).text = value;
			ButtonDisplayState(overState).text = value;
			ButtonDisplayState(upState).text = value;
			ButtonDisplayState(hitTestState).text = value;
		}
	}
}
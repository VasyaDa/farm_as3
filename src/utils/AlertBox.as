package utils
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class AlertBox extends Sprite
	{
		protected var box:Shape;
		protected var yesBtn:Sprite;
		
		public function AlertBox($:Rectangle,text:String):void
		{			
			box = new Shape();
			yesBtn = new Sprite();
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.align = 'left';
			txtFormat.font = 'Arial';
			txtFormat.size = 13;
			txtFormat.bold = true;
			txtFormat.color = 0xFFFFFF;
			
			var message:TextField = new TextField();
			message.text = text;
			message.setTextFormat(txtFormat);
			message.multiline = true;
			message.wordWrap = true;
			message.width = $.width-10;
			message.height = $.height-10;
			message.x = 5;
			message.y = 5;
			message.selectable = false;
			
			addChild(message);
			with (box.graphics)
			{
				lineStyle(1);
				beginFill(0, 0.4);
				drawRect($.x, $.y, $.width, $.height);
				endFill();
			}
			
			with (yesBtn.graphics)
			{
				lineStyle(1, 0xCCCCCC);
				beginFill(0xCCCCCC, 0.4);
				drawRect($.x+$.width-100, $.y+$.height-40, 80, 20);
				endFill();
			}
			message = new TextField();
			message.text = 'OK';
			txtFormat.align = 'center';
			txtFormat.color = 0;
			message.setTextFormat(txtFormat);
			message.width = 80;
			message.height = 20;
			message.x = $.x+$.width-100;
			message.y = $.y+$.height-40;
			message.selectable = false;
			
			yesBtn.addChild(message);
			addChild(yesBtn)
			
			yesBtn.buttonMode = true;
			yesBtn.mouseChildren = false;
			yesBtn.useHandCursor = true;
			
			yesBtn.addEventListener(MouseEvent.CLICK, yesClickHandler, false, 0, true);
			
			graphics.lineStyle(1);
			graphics.beginFill(0, 0.4);
			graphics.drawRect($.x, $.y, $.width, $.height);
			graphics.endFill();
			
			addChild(box);
		}
		
		protected function yesClickHandler($:MouseEvent):void
		{
			($.target as Sprite).parent.parent.removeChild(($.target as Sprite).parent);
		}
	}
}
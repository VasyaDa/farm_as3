package utils
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CRadioGroup extends Sprite
	{
		private var selectedR:Sprite;
		
		public var currentState:String = "";
		
		public var radioButtons:Array = new Array();
		
		public function CRadioGroup(radioList:Object)
		{
			var button:Sprite;
			for each (var i:Object in radioList) {
				button = createRadio(i['name'],i['label'],i['offset']);
				radioButtons.push(button);
				addChild(button);
				if (currentState == "")
				{
					currentState = i['name'];
				}
			}
			
			selectedR = new Sprite();
			with (selectedR.graphics)
			{
				beginFill(0x030303,1);
				lineStyle(2,0x030303);
				drawRect(3,6,4,4);
				endFill();
			}
			
			(radioButtons[0] as Sprite).addChild(selectedR);
		}
		public function createRadio(radioVal:String, label:String ,offsetY:int):Sprite
		{
			var radioSpr:RadioButton = new RadioButton(radioVal);
			with (radioSpr.graphics)
			{
				lineStyle(2,0);
				drawRect(0,3,10,10);
			}
			with (radioSpr)
			{
				buttonMode = true;
				useHandCursor = true;
				mouseChildren = false;
				x = 0;
				y = offsetY;
				addChild(addText(label));
				addEventListener(MouseEvent.CLICK,radioClick);
			}
			return radioSpr;
		}
		public function radioClick(e:MouseEvent):void
		{
			(e.target as Sprite).addChild(selectedR);
			currentState = (e.target as RadioButton).value;
		}
		public function addText(txt:String):TextField
		{
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = 'Arial';
			txtFormat.indent = 15;
			txtFormat.size = 12;
			txtFormat.bold = true;
			txtFormat.color = 0x000000;
			
			var text:TextField = new TextField();
			text.text = txt;
			text.selectable = false;
			text.setTextFormat(txtFormat);
			return text;
		}
	}
}
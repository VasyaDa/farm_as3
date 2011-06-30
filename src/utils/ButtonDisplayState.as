package utils
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ButtonDisplayState extends Sprite {
		private var bgColor:uint;
		private var sizeX:uint;
		private var sizeY:uint;
		private var txt:TextField;
		private var _text:String;
		private var txtFormat:TextFormat;
		
		public function ButtonDisplayState(bgColor:uint, sizeX:uint, sizeY:uint, text:String) {
			this.bgColor = bgColor;
			this.sizeX    = sizeX;
			this.sizeY    = sizeY;
			_text = text;
			draw();
		}
		
		private function draw():void {
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(sizeX, sizeY, (Math.PI/180)*90, 0, 00);
			
			graphics.beginGradientFill(GradientType.LINEAR,[0xFFFFFF,bgColor,bgColor],[1,1,1],[0,125,255],matrix);
			graphics.lineStyle(1,0xCCCCCC);
			graphics.drawRoundRect(0, 0, sizeX, sizeY, 3, 3);
			graphics.endFill();
			
			txtFormat = new TextFormat();
			txtFormat.align = 'center';
			txtFormat.font = 'Arial';
			txtFormat.size = 13;
			txtFormat.bold = true;
			txtFormat.color = 0x303030;
			
			txt = new TextField();
			txt.text = _text;
			txt.x = 0;
			txt.y = 7;
			txt.setTextFormat(txtFormat);
			txt.width = sizeX;
			txt.height = sizeY;
			
			addChild(txt);
		}
		public function set text(value:String):void
		{
			_text = value;
			txt.text = _text;
			txt.setTextFormat(txtFormat);
			txt.width = sizeX;
			txt.height = sizeY;
		}
	}
}
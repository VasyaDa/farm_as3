package {   
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.DeleteObjectSample;
	
	import utils.AlertBox;
	import utils.CustomButton;
	import utils.IsoUtils;
	import utils.Point3D;
	import utils.CRadioGroup;
	import utils.Field;
	import utils.MyLoader;
	
	public class farm extends Sprite {
		public var world:Sprite;
		
		private var fieldsX:int = 11;
		private var fieldsY:int = 11;
		private var fieldSize:int = 50;
		private var imageLdr:MyLoader;
		private var bg_image:Bitmap;
		private var dragableField:Field;
		private var tileArray:Array = new Array();
		private var oldPos:Point3D;
		
		private var buttonCollect:CustomButton;
		private var buttonPlant:CustomButton;
		private var buttonGrow:CustomButton;
		
		private var plantBegin:Boolean = false;
		private var collectBegin:Boolean = false;
		
		private var selectTile:Field;
		private var plantsType:CRadioGroup;
		
		public static var storedObjects:Object = {};
		
		public function farm() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE,worldInit);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,loadError);
			xmlLoader.load(new URLRequest("game/init.xml"));
		}
		public function worldInit(e:Event):void
		{
			var worldXML:XML = new XML(e.currentTarget.data);
			
			fieldsX = worldXML.@fieldsX;
			fieldsY = worldXML.@fieldsY;
			fieldSize = worldXML.@fieldSize;
			
			world = new Sprite();
			
			imageLdr = new MyLoader('BG.jpg',{});
			imageLdr.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageComplete);
			imageLdr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
			imageLdr.loadObject();
			
			var xmlField:XMLList;
			
			for (var i:int = 0; i < fieldsX ; i++)
			{
				for (var j:int = 0; j < fieldsY; j++)
				{
					var r:int = Math.round(Math.random()*3+1);
					var name_plant:String = '';
					var step:int = 0;
					xmlField = worldXML.field.(@id == (i * fieldsY + j));
					if (xmlField != null)
					{
						name_plant = xmlField.@plant;
						step = xmlField.@growth;
					}
					var tile:Field = new Field(fieldSize, 0xCCCCCC, name_plant, storedObjects, step);
					tileArray.push(tile);
					tile.indexAt = (i * fieldsY + j);
					tile.position = new Point3D(i*fieldSize , 0, j*fieldSize);
					world.addChild(tile);
				}
			}
			
			world.addEventListener(MouseEvent.MOUSE_DOWN,initStartDrag);
			world.addEventListener(MouseEvent.MOUSE_UP,initStopDrag);
			world.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			
			world.x = stage.stageWidth / 2;
			world.y = stage.stageHeight / 2-world.height/2;
			
			stage.showDefaultContextMenu = false;
			stage.addEventListener(Event.RESIZE,resizeStage);
		}
		public function returnFieldFromIndex(indexTargetField:int):Field
		{
			var targetField:Field = null;
			sortTile("indexAt");
			targetField = tileArray[indexTargetField];
			sortTile();
			return targetField;
		}
		public function returnFieldFromCoord():Field
		{
			var screenPoint:Point = new Point(world.mouseX,world.mouseY);
			var pos:Point3D = IsoUtils.screenToIso(screenPoint);
			var targetField:Field = null;
			pos.x = Math.round(pos.x / fieldSize) * fieldSize;
			pos.y = Math.round(pos.y / fieldSize) * fieldSize;
			pos.z = Math.round(pos.z / fieldSize) * fieldSize;
			if ((pos.x >= 0 && pos.x < fieldsX*fieldSize) && (pos.z >= 0 && pos.z < fieldsY*fieldSize))
			{
				var indexTargetField:int = pos.x/50*fieldsX+pos.z/50;
				sortTile("indexAt");
				targetField = tileArray[indexTargetField];
				sortTile();
			}
			return targetField;
		}
		public function mouseMove(e:MouseEvent):void
		{
			if ((collectBegin) || (plantBegin))
			{
				var targetField:Field = returnFieldFromCoord();
				if (targetField != null)
				{
					world.addChild(selectTile);
					selectTile.position = targetField.position;
				}
				else
				{
					if (world.contains(selectTile)){world.removeChild(selectTile);}
				}
			}
		}
		public function initStartDrag(e:MouseEvent):void
		{
			var targetField:Field = returnFieldFromCoord();	
			if ((collectBegin) || (plantBegin))
			{
				
				var xmlLoader:URLLoader = new URLLoader(); 
				
				if (plantBegin)
				{
					xmlLoader.addEventListener(Event.COMPLETE,plantResponse);
					xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,loadError);
					xmlLoader.load(new URLRequest("game/plant.xml?field_id="+targetField.indexAt+"&plant="+plantsType.currentState));					
				}
				if (collectBegin)
				{
					xmlLoader.addEventListener(Event.COMPLETE,collectResponse);
					xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,loadError);
					xmlLoader.load(new URLRequest("game/collect.xml?field_id="+targetField.indexAt));
				}
				return;
			}
			if (targetField == null) {return;}
			if (targetField.myPlant != null)
			{
				dragableField = targetField; 
				oldPos = dragableField.position;
				dragableField.parent.addChild( dragableField );
				dragableField.startDrag(true);
			}
			
		}
		public function alert(label:String):void
		{
			var Alert:AlertBox = new AlertBox(new Rectangle(0,0,200,100),label);
			addChild(Alert);
			Alert.x = stage.stageWidth / 2 - Alert.width/2;
			Alert.y = stage.stageHeight / 2 - Alert.height/2;
		}
		public function collectResponse(e:Event):void
		{
			var collectXML:XML = new XML(e.currentTarget.data);
			if (collectXML.error != undefined)
			{
				alert(collectXML.error);
			}
			else
			{
				var targetField:Field = returnFieldFromIndex(collectXML.fieldId);
				if (targetField.myPlant != null)
				{
					targetField.myPlant.removeChild(targetField.myPlant._image);
					targetField._step = 0;
					targetField._bgimage = '';
					targetField.myPlant = null;
				}
				buttonCollect.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		public function growthResponse(e:Event):void
		{
			var growthXML:XML = new XML(e.currentTarget.data);
			if (growthXML.error != undefined)
			{
				alert(growthXML.error);
			}
			else
			{
				for each (var _field:XML in growthXML.*)
				{
					var targetField:Field = returnFieldFromIndex(_field.fieldId);
					if (targetField.myPlant != null)
					{
						targetField.myPlant.step = _field.growth; 
					}
				}
			}
		}
		public function plantResponse(e:Event):void
		{
			var plantXML:XML = new XML(e.currentTarget.data);
			if (plantXML.error != undefined)
			{
				alert(plantXML.error);
			}
			else
			{
				var targetField:Field = returnFieldFromIndex(plantXML.fieldId);
				if (targetField.myPlant == null)
				{
					targetField._step = plantXML.growth
					targetField._bgimage = plantXML.plant;
					targetField.drawBg(); 
				}
				
				buttonPlant.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		public function sortTile(type:String = "depth"):void
		{
			tileArray.sortOn(type, Array.NUMERIC);
			
			for(var i:int = 0; i < tileArray.length; i++)
			{
				world.setChildIndex(tileArray[i], i);
			}
		}
		public function initStopDrag(e:MouseEvent):void
		{
			if (dragableField != null)
			{
				var targetField:Field = returnFieldFromCoord();
				if (targetField != null)
				{
					var xmlLoader:URLLoader = new URLLoader();
					xmlLoader.addEventListener(Event.COMPLETE,swapResponse);
					xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,loadError);
					xmlLoader.load(new URLRequest("game/swplant.xml?source_id="+dragableField.indexAt+"&dest_id="+targetField.indexAt));
				}
				else
				{
					dragableField.stopDrag();
					dragableField.position = oldPos;
					dragableField = null;
					sortTile();
				}
			}
		}
		public function swapResponse(e:Event):void
		{
			var swapXML:XML = new XML(e.currentTarget.data);
			if (swapXML.error != undefined)
			{
				alert(swapXML.error);
			}
			else
			{
				var targetField:Field = returnFieldFromIndex(swapXML.destField);				
				var ti:int = targetField.indexAt;
				dragableField.stopDrag();
				dragableField.position = targetField.position;
				targetField.indexAt = dragableField.indexAt;
				dragableField.indexAt = ti;
				targetField.position = oldPos;
				sortTile();
				dragableField = null;
			}
		}
		public function resizeStage(e:Event):void
		{
			world.x = stage.stageWidth / 2;
			world.y = stage.stageHeight / 2-world.height/2;
			
			if (bg_image != null)
			{
				bg_image.x = stage.stageWidth / 2 - bg_image.bitmapData.width/2;
				bg_image.y = stage.stageHeight / 2 - bg_image.bitmapData.height/2;
			}
		}
		public function onImageComplete(e:Event):void
		{
			imageLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageComplete);
			imageLdr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
			
			bg_image = Bitmap(e.target.content);
			
			bg_image.x = stage.stageWidth / 2 - bg_image.bitmapData.width/2;
			bg_image.y = stage.stageHeight / 2 - bg_image.bitmapData.height/2;
			
			addChild(bg_image);
			addChild(world);
			
			buttonGrow = new CustomButton('Вырастить на ед. роста');
			buttonGrow.x = 50;
			buttonGrow.y = 50;
			buttonGrow.addEventListener(MouseEvent.CLICK,buttonClick);
			
			buttonPlant = new CustomButton('Посадить растение');
			buttonPlant.x = 50;
			buttonPlant.y = 90;
			buttonPlant.addEventListener(MouseEvent.CLICK,plantClick);
			
			buttonCollect = new CustomButton('Собрать растение');
			buttonCollect.x = 50;
			buttonCollect.y = 130;
			buttonCollect.addEventListener(MouseEvent.CLICK,collectClick);
			
			addChild(buttonGrow);
			addChild(buttonPlant);
			addChild(buttonCollect);
			
			var radioList:Object = new Object();
			
			radioList = {
				a:{name:'potato',label:'Potato',offset:0},
				b:{name:'clover',label:'Clover',offset:20},
				c:{name:'sunflower',label:'Sunflower',offset:40}
			}
			
			plantsType = new CRadioGroup(radioList);
			
			plantsType.x = 240;
			plantsType.y = 77;
			
			plantsType.visible = false;
			
			addChild(plantsType);
			
			selectTile = new Field(fieldSize, 0x999999, '', storedObjects, 0);
		}
		public function collectClick(e:MouseEvent):void
		{
			if (collectBegin != true)
			{
				collectBegin = true;
				
				buttonGrow.visible = false;
				buttonPlant.visible = false;
				
				buttonCollect.text = 'Отменить';
			}
			else
			{
				collectBegin = false;
				
				if (world.contains(selectTile)){world.removeChild(selectTile);}
				
				buttonGrow.visible = true;
				buttonPlant.visible = true;
				
				buttonCollect.text = 'Собрать растение';
			}
		}
		public function plantClick(e:MouseEvent):void
		{
			if (plantBegin != true)
			{
				plantBegin = true;
				
				buttonGrow.visible = false;
				buttonCollect.visible = false;
				
				plantsType.visible = true;
				
				buttonPlant.text = 'Отменить';
			}
			else
			{
				plantBegin = false;
				
				if (world.contains(selectTile)){world.removeChild(selectTile);}
				
				buttonGrow.visible = true;
				buttonCollect.visible = true;
				
				plantsType.visible = false;
				
				buttonPlant.text = 'Посадить растение';
			}
		}
		public function buttonClick(e:MouseEvent):void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE,growthResponse);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,loadError);
			xmlLoader.load(new URLRequest("game/growth.xml"));
		}
		public function loadError(e:IOErrorEvent):void
		{
			alert(e.text);
		}
	}
}
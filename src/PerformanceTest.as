package
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.framework.movieclipbitmap.display.MovieSheet;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	[SWF(width='760',height='660',frameRate='24')]
    /**
     * 性能演示，1800头猪，同一资源，三种尺寸，24帧(inter i7 2.6G)
     * @author Rakuten
     *
     */
	public class PerformanceTest extends Sprite
	{
		public function PerformanceTest()
		{
			initDisplay();
			loadMc("resources/pig_1_0_0.swf", "Pig_1_0_0");
		}

		private var loaderLib:Dictionary = new Dictionary();
		private var pigLayer:Sprite = new Sprite();

		private function loadMc(path:String, clzName:String):void
		{
			pigIdLabel.text = "PigID:"+clzName;
			var loader:Loader = new Loader();
			loaderLib[loader.contentLoaderInfo] = clzName;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.load(new URLRequest(path));
		}

		private function createSourceMc(clz:Class, claName:String, posX:Number = 0, posY:Number = 0, size:Number=1):MovieClip
		{
			var sourceMc:MovieClip = new clz() as MovieClip;
			sourceMc.name = claName;
			//原动画
			sourceMc.gotoAndStop(3);
			sourceMc.scaleX = size;
			sourceMc.scaleY = size;
			sourceMc.x = posX;
			sourceMc.y = posY;
			sourceMc.gotoAndStop(1);
			pigLayer.addChild(sourceMc);
			return sourceMc;
		}

		private function createOptimizeMc(clz:Class, claName:String, posX:Number = 0, posY:Number = 0, size:Number=1):*
		{
			var sourceMc:MovieClip = new clz() as MovieClip;
			sourceMc.name = claName;

			sourceMc.scaleX = size;
			sourceMc.scaleY = size;

			//BMP动画
			var mc:MovieSheet = new MovieSheet(sourceMc);
			mc.x = posX;
			mc.y = posY;
			mc.gotoAndStop(1);
			pigLayer.addChild(mc);
			return mc
		}

		private function createScaleMc(clz:Class, claName:String, posX:Number = 0, posY:Number = 0, size:Number=1):*
		{
			//BMP动画
			var sourceMc:MovieClip = new clz() as MovieClip;
			sourceMc.name = claName;

			var mc:MovieSheet = new MovieSheet(sourceMc);
			mc.x = posX;
			mc.y = posY;
			mc.gotoAndStop(1);

			mc.scaleX = size;
			mc.scaleY = size;
			pigLayer.addChild(mc);
			return mc
		}

		private function loader_completeHandler(event:Event):void
		{
			frameLabel.text = "frame:1";
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			info.removeEventListener(Event.COMPLETE, loader_completeHandler);
			var clzName:String = loaderLib[info];
			var clz:* = info.applicationDomain.getDefinition(clzName);
//			trace("loader complete:"+loaderLib[info])


			for (var i:uint = 0; i<600; i++)
			{
//				createSourceMc(clz, clzName, 700*Math.random()+25,600*Math.random()+25, 0.75);
//				createSourceMc(clz, clzName, 700*Math.random()+25,600*Math.random()+25, 1);
//				createSourceMc(clz, clzName, 700*Math.random()+25,600*Math.random()+25, 1.5);

				createOptimizeMc(clz, clzName, 700*Math.random()+25,600*Math.random()+25, 0.75);
				createOptimizeMc(clz, clzName, 700*Math.random()+25,600*Math.random()+25, 1);
				createOptimizeMc(clz, clzName, 700*Math.random()+25,600*Math.random()+25, 1.5);
			}


		}
		private var pigIdLabel:Label;
		private var frameLabel:Label;
		private function initDisplay():void
		{
			addChild(pigLayer);
			addChild(new Stats());
			pigIdLabel = new Label(this, 140, 50);
			frameLabel = new Label(this, 240, 50)

			var firstBtn:PushButton = new PushButton(this, 80, 10, "First Frame", firstBtn_clickHandler);
			var prevBtn:PushButton = new PushButton(this, 190, 10, "Prev Frame",prevBtn_clickHandler);
			var nextBtn:PushButton = new PushButton(this, 300, 10, "Next Frame",nextBtn_clickHandler);

			var netxPigBtn:PushButton = new PushButton(this, 410, 10, "Next Pig", nextPigBtn_clickHandler)
		}

		private function firstBtn_clickHandler(event:MouseEvent):void
		{
			var len:uint = pigLayer.numChildren;
			for (var i:uint = 0; i<len; i++)
			{
				var mc:MovieClip = pigLayer.getChildAt(i) as MovieClip;
				mc.gotoAndStop(1);
			}
			frameLabel.text = "frame:1";
		}
		private function prevBtn_clickHandler(event:MouseEvent):void
		{
			var frameIndex:int = 0;
			var len:uint = pigLayer.numChildren;
			for (var i:uint = 0; i<len; i++)
			{
				var mc:MovieClip = pigLayer.getChildAt(i) as MovieClip;
				mc.prevFrame();
				frameIndex = mc.currentFrame;
			}
			frameLabel.text = "frame:"+frameIndex;
			trace("frameIndex:"+frameIndex)
		}
		private function nextBtn_clickHandler(event:MouseEvent):void
		{
			var frameIndex:int = 0;
			var len:uint = pigLayer.numChildren;
			for (var i:uint = 0; i<len; i++)
			{
				var mc:MovieClip = pigLayer.getChildAt(i) as MovieClip;
				mc.nextFrame();
				frameIndex = mc.currentFrame;
			}
			frameLabel.text = "frame:"+frameIndex+"/"+mc.totalFrames;
			trace("frame:"+frameIndex, "/ "+mc.totalFrames)
		}
		private var pigIndex:uint = 2;
		private function nextPigBtn_clickHandler(event:MouseEvent):void
		{

			for (var i:uint = 0; i<pigLayer.numChildren; i++)
			{
				var obj:DisplayObject = pigLayer.getChildAt(i);
				if (obj is MovieSheet)
				{
					MovieSheet(obj).dispose();
				}
			}
			pigLayer.removeChildren();
			var str:String = ""+pigIndex%3+"_0_0";
			trace("load index:"+pigIndex,"file:"+str)
			loadMc("resources/pig_"+str+".swf", "Pig_"+str);
			pigIndex++;
		}

	}
}
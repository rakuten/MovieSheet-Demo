package
{
import com.bit101.components.HBox;
import com.framework.movieclipbitmap.display.MovieSheet;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;

[SWF(width='760',height='660',frameRate='24')]
/**
 *
 * @author Rakuten
 *
 */
public class SimpleDemo extends Sprite
{
    public function SimpleDemo()
    {
        super();
        initLoader();
    }

    private function initLoader():void
    {
        //加载swf文件
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
        loader.load(new URLRequest("resources/pig_1_0_0.swf"));

    }
    /**
     * swf资源加载完成
     * @param event
     *
     */
    private function loader_completeHandler(event:Event):void
    {
        var info:LoaderInfo = event.currentTarget as LoaderInfo;
        info.removeEventListener(Event.COMPLETE, loader_completeHandler);

        //从Loader中获取MovieClip
        var clz:* = info.applicationDomain.getDefinition("Pig_1_0_0");


        createDemo(clz, "Pig_1");
        scaleDemo(clz, "Pig_1");

    }

    /**
     * 三种实例化方式
     * @param clz
     * @param mcName
     *
     */
    private function createDemo(clz:Class, mcName:String):void
    {
        //布局用
        var demoBox:HBox = new HBox();
        demoBox.x = 60;
        demoBox.y = 60;
        addChild(demoBox);

        //原始MC用法
        var sourceMc:MovieClip = new clz();
        //为相同内容的mc设置同一个名字即可使用共享内存
        sourceMc.name = mcName;
        sourceMc.gotoAndStop(1);
        sourceMc.scaleX = 1.25;
        sourceMc.scaleY = 1.25
        demoBox.addChild(sourceMc)

        //实例化方式一
        var sourceMc1:MovieClip = new clz();
        sourceMc1.name = mcName;
        var mc1:MovieClip = new MovieSheet(sourceMc1);
//        mc1.gotoAndStop(1);
        demoBox.addChild(mc1);

        //实例化方式二(与"实例化一"使用同一个源MC)
        var mc2:MovieClip = new MovieSheet(sourceMc1);
//        mc1.gotoAndStop(1);
        demoBox.addChild(mc2);

        //实例化方式三(直接调用共享内存)
        var emptyMc:MovieClip = new MovieClip();
        //同一个名字即可使用共享内存
        emptyMc.name = mcName;

        var mc3:MovieClip = new MovieSheet(emptyMc);
//        mc3.gotoAndStop(1);
        demoBox.addChild(mc3);
    }

    private function scaleDemo(clz:Class, mcName:String):void
    {
        //布局用
        var demoBox:HBox = new HBox();
        demoBox.x = 60;
        demoBox.y = 120;
        addChild(demoBox);


        //缩放方式一(预先缩放):
        var sourceMc1:MovieClip = getMc(clz, "Pig_1");
        sourceMc1.scaleX = 0.5;
        sourceMc1.scaleY = 0.5;

        var mc1:MovieClip = new MovieSheet(sourceMc1);
//        mc.x = posX;
//        mc.y = posY;
//        mc1.gotoAndStop(1);
        demoBox.addChild(mc1);

        //缩放方式二(延迟缩放):
        var sourceMc2:MovieClip = getMc(clz, "Pig_1");
        //实例化时第二个参数传入false则将在调用scale后能触发Event.COMPLETE事肵
        var mc2:MovieSheet = new MovieSheet(sourceMc2, false);
        mc2.addEventListener(Event.COMPLETE, mc2_completeHandler);

        mc2.scale = 0.5;
//        mc.x = posX;
//        mc.y = posY;
//        mc1.gotoAndStop(1);
        demoBox.addChild(mc2);
    }

    private function mc2_completeHandler(event:Event):void
    {
        trace("mc2绘制完成")
    }

    private function getMc(clz:Class, mcName:String):MovieClip
    {
        var sourceMc1:MovieClip = new clz() as MovieClip;
        //为相同内容的mc设置同一个名字即可使用共享内存
        sourceMc1.name = "Pig_1";
        return sourceMc1;
    }
}
}
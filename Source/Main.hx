package ;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import org.flixel.FlxGame;
import net.hires.debug.Stats;
import nme.events.Event;
import nme.Lib;

//test
/**
 * @author Aaron
 */
class Main extends Sprite {
	
	var game:FlxGame;
	var stats:Stats;
	
	public function new () {
        super ();
        addEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
    }
	
	private function this_onAddedToStage(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);
		construct();
	}
	
	public function construct () {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		game = new Game();
		addChild(game);
				
		/*#if (debug)
		stats = new Stats();
		addChild(stats);
		#end*/
		
		stage.addEventListener(Event.RESIZE, resizeEventHandler);
		
		resize();
	}
	
	private function resizeEventHandler(e:Event):Void {
			resize();
	}
	
	private function resize():Void 
	{
		var wideScale:Float = Lib.current.stage.stageWidth / Vars.flixelWindowWidth;
		var highScale:Float = Lib.current.stage.stageHeight / Vars.flixelWindowHeight;
		var scale:Float = Math.min(wideScale, highScale);
		
		game.scaleY = scale;
		game.scaleX = scale;
		
		game.x = (Lib.current.stage.stageWidth - Vars.flixelWindowWidth * scale) / 2;
		game.y = (Lib.current.stage.stageHeight - Vars.flixelWindowHeight * scale) / 2;
		
		
		/*#if (flash && debug)
		stats.x = Lib.current.stage.stageWidth -stats.width;
		stats.y = 16;
		#end*/
	}
	
	// Entry point
	public static function main () {
		Lib.current.addChild (new Main());
	}
	
	
}
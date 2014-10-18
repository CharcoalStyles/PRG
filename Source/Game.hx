package ;
import com.charcoalStyles.eti.GenVars;
import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import com.charcoalStyles.eti.Menu;

/**
 * ...
 * @author Aaron
 */

class Game extends FlxGame
{

	#if flash
	public static var SoundExtension:String = ".mp3";
	#else
	public static var SoundExtension:String = ".wav";
	#end
	
	public static var SoundOn:Bool = true;
	
	public function new()
	{
		var stageWidth:Int = Vars.flixelWindowWidth;
		var stageHeight:Int = Vars.flixelWindowHeight;
		forceDebugger = true;
		GenVars.setup();
		
		super(stageWidth, stageHeight, Menu, 1, 60, 30);
		
		#if mobile
		FlxG.mobile = true;
		#else
		FlxG.mobile = false;
		#end
	}
}

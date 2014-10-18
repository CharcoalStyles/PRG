package ;
import nme.Assets;
import nme.Lib;

class Vars 
{
	
	private static function getHeadingFontSize():Int {
		return 72;
	}
	public static var headingFontSize(getHeadingFontSize, null):Int;
	
	private static function getNormalFontSize():Int {
		return 32;
	}
	public static var normalFontSize(getNormalFontSize, null):Int;
	
	private static function getSmallestFontSize():Int {
		return 16;
	}
	public static var smallestFontSize(getSmallestFontSize, null):Int;
	
	private static function getFlixelWidth():Int {
		#if blackberry
		return 1024;
		#else
		return 1280;
		#end
	}
	public static var flixelWindowWidth(getFlixelWidth, null):Int;
	
	private static function getFlixelHeight():Int {
		#if blackberry
		return 600;
		#else
		return 720;
		#end

	}
	public static var flixelWindowHeight(getFlixelHeight, null):Int;
	
	private static function getFont_Visitor():String {
		return "fonts/visitor2.ttf";
	}
	
	public static var fontVisitor(getFont_Visitor, null):String;
	
	private static function getFont_Paskowy():String {
		return "fonts/Paskowy.ttf";
	}
	
	public static var fontPaskowy(getFont_Paskowy, null):String;
	
}

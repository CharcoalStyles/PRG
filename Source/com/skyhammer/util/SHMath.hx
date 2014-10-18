package com.skyhammer.util;
import org.flixel.FlxObject;

/**
 * ...
 * @author Aaron
 */

class SHMath 
{

	public static function fLerp(f1:Float, f2:Float, t:Float):Float {
		var f:Float = (f2 - f1) * t + f1;
		return f;
	}
	
	public static function iLerp(i1:Int, i2:Int, t:Float):Int {
		return Std.int(fLerp(i1, i2, t));
	}
	
	/* Gets the magnitude of the distance between two objects.
	 * 
	 * The reason why I'm doing a big equation like this instead of using the Math.pwr() function is because
	 * the math lib does a really dumb and inefficient power algorithm. This is just more optimal, but a shitload
	 * of perenthesis.
	 * @author Alex
	 */
	public static function getDistance(obj1:FlxObject, obj2:FlxObject) : Float
	{
		var d:Float = ( Math.sqrt(((obj1.x - obj2.x) * (obj1.x - obj2.x)) + ((obj1.y - obj2.y) * (obj1.y - obj2.y))));
		return d;
	}
	
	/*
	 * Get the distance between one object to another on the X Axis.
	 */
	public static function getXVector(obj1:FlxObject, obj2:FlxObject):Float {
		var d:Float = obj2.x - obj1.x;
		return d;
	}
	
	/*
	 * Get the distance between one object to another on the Y Axis.
	 */
	public static function getYVector(obj1:FlxObject, obj2:FlxObject):Float {
		var d:Float = obj2.y - obj1.y;
		return d;
	}
}
package com.skyhammer.entites;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;

/**
 * ...
 * @author Aaron
 */

class ShSprite extends FlxSprite
{
	public var isAnimated:Bool;
	
	private var assetString:String;
	
	private var loadedBitmap:Bool;
	
	public function new() 
	{
		super();
		loadedBitmap = false;
	}
	
	override public function draw():Void 
	{
		if(loadedBitmap)
			super.draw();
	}
	
	private function loadBitmap(value:String):String
	{
		assetString = value;
		loadGraphic(value);
		updateTileSheet();
		loadedBitmap = true;
		return value;
	}
	
	private function setFrameSize(value:FlxPoint):FlxPoint
	{
		loadGraphic(assetString, true, false, Std.int(value.x), Std.int(value.y));
		updateTileSheet();
		loadedBitmap = true;
		return value;
	}
	
	public var bitmapString(null, loadBitmap):String;
	
	public var frameSize(null, setFrameSize):FlxPoint;
}
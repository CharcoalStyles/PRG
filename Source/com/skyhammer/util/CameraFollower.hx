package com.skyhammer.util;
import org.flixel.FlxCamera;
import org.flixel.FlxObject;
import org.flixel.FlxRect;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Aaron
 */

class CameraFollower extends FlxSprite
{
	private var bounds:FlxRect;
	public var camera:FlxCamera;
	
	private var target:FlxSprite;
	
	public function new(cam:FlxCamera, ?X:Float = 0, ?Y:Float = 0, ?Width:Float = 0, ?Height:Float = 0) 
	{
		super();
		
		target = new FlxSprite();
		target.makeGraphic(2, 2, 0xff80ffff);
		
		camera = cam;
		
		camera.follow(target);
		
		camera.zoom = 2;
		
		makeGraphic(4, 4, 0xffff80ff);
		if (bounds == null)
		{
			bounds = new FlxRect();
		}
		bounds.make(X, Y, Width, Height);
	}
	
	override public function update():Void 
	{
		super.update();
		
		target.x = x + (camera.zoom - 1) * camera.width / 2;
		target.y = y + (camera.zoom - 1) * camera.height / 2;
		
		if (x < bounds.x + camera.width / 2)
			x = bounds.x + camera.width / 2;
		if (y < bounds.y + camera.height / 2)
			y = bounds.y + camera.height / 2;
			
		if (x > bounds.width - camera.width / 2)
			x = bounds.width - camera.width / 2;
		if (y > bounds.height - camera.height / 2)
			y = bounds.height - camera.height / 2;
	}
	
	override public function draw():Void 
	{
		super.draw();
		target.draw();
	}
}
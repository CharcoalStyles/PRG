package com.skyhammer.entites;
import org.flixel.FlxObject;

/**
 * ...
 * @author Aaron
 */

class TriggerZone extends Switch
{

	public function new() 
	{
		super();
		bitmapString = "assets/Entities/DeathZone.png";
	}
	
	override public function Activate():Void 
	{
		super.Activate();
		for (i in children)
			i.Activate();
	}
	
	override public function Deactivate():Void 
	{
		super.Deactivate();
		for (i in children)
			i.Deactivate();
	}
	
	override public function OnEnter(object:FlxObject):Void 
	{
		super.OnEnter(object);
		if (numObjects > 0)
			Activate();
	}
	
	override public function OnExit(object:FlxObject):Void 
	{
		super.OnExit(object);
		if (numObjects <= 0)
			Deactivate();
	}
	
	override public function draw():Void 
	{
		//super.draw();
	}
}
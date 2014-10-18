package com.skyhammer.util;
import org.flixel.FlxBasic;
import org.flixel.FlxG;

/**
 * ...
 * @author Aaron
 */

class ShTimer extends FlxBasic 
{
	private var timerStarted:Bool;
	private var repeatTimer:Bool;
	private var currentTime:Float;
	private var maxTime:Float;
	
	private var onTimerComplete:Dynamic;
	
	private var addedToState:Bool;
	
	public function new() 
	{
		super ();
		timerStarted = false;
		currentTime = 0;
		maxTime = 0;
		addedToState = false;
	}
	
	public function startTimer(length:Float, onComplete:Dynamic)
	{
		timerStarted = true;
		currentTime = 0;
		maxTime = length;
		
		if (!addedToState)
		{
			FlxG.state.add(this);
			addedToState = true;
		}
		
		onTimerComplete = onComplete;
	}
	
	public function getPercentageComplete():Float
	{
		return currentTime / maxTime;
	}
	
	override public function update():Void 
	{
		super.update();
		if (timerStarted)
		{
			currentTime += FlxG.elapsed;
			if (currentTime >= maxTime)
				timerComplete();
		}
	}
	
	private function timerComplete():Void
	{
		timerStarted = false;
		
		onTimerComplete();
	}
}
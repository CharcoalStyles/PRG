package com.skyhammer.entites;
import com.skyhammer.util.ShTimer;

/**
 * ...
 * @author Aaron
 */

class TimerSwitch extends Switch
{
	private var timer:ShTimer;
	
	private var timeLength:Float;
	
	private var isLooping:Bool;
	
	private var sendingActivate:Bool;

	public function new()
	{
		super();
		timer = new ShTimer();
		timeLength = 1000;
		isLooping = false;
		
		sendingActivate = true;
	}
	
	override public function Activate():Void 
	{
		super.Activate();
		sendingActivate = true;
		timer.startTimer(timeLength, onTimerComplete);
	}
	
	override public function Deactivate():Void 
	{
		super.Deactivate();
		sendingActivate = false;
		timer.startTimer(timeLength, onTimerComplete);
	}
	
	private function onTimerComplete():Void
	{
		for (i in 0...children.length)
		{
			if (sendingActivate)
				children[i].Activate();
			else
				children[i].Deactivate();
		}
		
		if (isLooping)
			Activate();
	}
	
	private function set_timePeriod(value:Float):Float
	{
		timeLength = value;
		return value;
	}
	
	public var timePeriod(null, set_timePeriod):Float;
	
	private function set_startOnSpawn(value:Bool):Bool
	{
		if (value)
			Activate();
			
		return value;
	}
	
	public var startOnSpawn(null, set_startOnSpawn):Bool;
	
	private function set_loop(value:Bool):Bool
	{
		isLooping = value;
			
		return value;
	}
	
	public var loop(null, set_loop):Bool;
	
	
}
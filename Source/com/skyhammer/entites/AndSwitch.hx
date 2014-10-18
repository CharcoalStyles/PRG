package com.skyhammer.entites;

/**
 * ...
 * @author Aaron
 */

class AndSwitch extends Switch
{
	public function new() 
	{
		super();
	}
	
	override public function Activate():Void
	{
		checkCondition();
	}
	
	override public function Deactivate():Void
	{
		checkCondition();
	}
	
	public function checkCondition():Void
	{
		var trigger:Bool = true;
		for (i in 0...parents.length)
		{
			if (!parents[i].isActivated())
				trigger = false;
		}
		
		if (trigger)
		{
			for (i in 0...children.length)
			{
				children[i].Activate();
			}
		}
		else
		{
			
			for (i in 0...children.length)
			{
				children[i].Deactivate();
			}
		}
		
		activated = trigger;
	}
		
	override public function draw():Void 
	{
		//super.draw();
	}
	
}
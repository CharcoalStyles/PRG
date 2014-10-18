package com.skyhammer.entites;

/**
 * COMMIT 101: More to UML specs (Although it goes straight from LAJEntity, which SHOULD be changed soon! 
 * @author Aaron
 */

class OrSwitch extends Switch
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
		var trigger:Bool = false;
		for (i in 0...parents.length)
		{
			if (parents[i].isActivated())
				trigger = true;
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
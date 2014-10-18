package com.skyhammer.entites;
import org.flixel.FlxG;
import org.flixel.FlxText;

/**
 * ...
 * @author Aaron
 */

class ToggleSwitch extends Switch
{
	private var justActivated:Bool;
	
	private var onChildren:Bool;
	
	public function new() 
	{
		super();
		
		justActivated = false;
		onChildren = false;
	}
	
	override public function Activate():Void 
	{
		Toggle();
	}
	
	override public function Deactivate():Void 
	{
		Toggle();
	}
	
	public function Toggle():Void 
	{
		if (!justActivated)
		{
			justActivated = true;
			activated = !activated;
			
			if (onChildren)
			{
				for (i in children)
				{
					if (i.isActivated())
						i.Deactivate();
					else
						i.Activate();
				}
			}
			else
			{
				if (activated)
				{
					for (i in children)
					{
						i.Activate();
					}
				}
				else
				{
					for (i in children)
					{
						i.Deactivate();
					}
				}
			}
		}	
	}
	
	override public function preUpdate():Void 
	{
		super.preUpdate();
		justActivated = false;
	}
	override public function postUpdate():Void 
	{
		super.postUpdate();
		justActivated = false;
	}
	
	private function set_toggleChildren(value:Bool):Bool
	{
		onChildren = value;
		
		return value;
	}
	
	public var toggleChildren(null, set_toggleChildren):Bool;
}
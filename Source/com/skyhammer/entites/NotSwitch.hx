package com.skyhammer.entites;

/**
 * ...
 * @author Aaron
 */

class NotSwitch extends Switch
{

	public function new() 
	{
		super();
	}
	
	override public function Activate():Void 
	{
		super.Activate();
		for (i in children)
			i.Deactivate();
	}
	
	override public function Deactivate():Void 
	{
		super.Deactivate();
		for (i in children)
			i.Activate();
	}
	
}
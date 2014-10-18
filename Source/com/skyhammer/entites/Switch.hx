package com.skyhammer.entites;

/**
 * ...
 * @author Aaron
 */

class Switch extends Area
{
	
	public var parents:Array<Switch>;
	public var children:Array<ShEntity>;
	
	public function new() 
	{
		super();
		activated = false;
		parents = new Array<Switch>();
		children = new Array<ShEntity>();
	}
		
	override public function Activate() : Void
	{
		activated = true;
	}
	
	override public function Deactivate() : Void
	{
		activated = false;
	}
	
}
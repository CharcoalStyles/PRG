package com.skyhammer.entites;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Aaron
 * COMMIT 101: Set up to UML Specifications. - Alex
 */

class ShEntity extends ShSprite
{	
	private var activated:Bool;
	
	public function new() 
	{
		super();
		activated = false;
	}
	
	public function Activate() : Void
	{
		activated = true;
	}
	
	public function Deactivate() : Void
	{
		activated = false;
	}
	
	public function isActivated():Bool
	{
		return activated;
	}
}
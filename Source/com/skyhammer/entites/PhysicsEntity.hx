package com.skyhammer.entites;

import org.flixel.FlxObject;
/**
 * ...
 * @author Alex Breskin
 */

interface PhysicsEntity 
{

	public function update():Void;
	public function collideObject(o:FlxObject):Void;
	
}
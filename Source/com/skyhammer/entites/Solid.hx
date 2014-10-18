package com.skyhammer.entites;
import org.flixel.FlxObject;

/**
 * A Solid Object, such as a door or (in the game's case) a laser.
 * @author Alex Breskin
 */

interface Solid 
{
	function onHit(object:FlxObject):Void;
}
package com.skyhammer.entites;
import org.flixel.FlxObject;
import org.flixel.FlxG;

/**
 * COMMIT 101: Added this as per UML Specifications. Assumptions made include how to resize the object and setting the object,
 * as it defines a certain area.
 * @author Alex Breskin
 */

class Area extends ShEntity 
{
	
	private var objectsInArea:Array<FlxObject>;
	private var objectsInAreaThisFrame:Array<FlxObject>;
	
	private var numObjects:Int;
	
	public function new()	//Default 
	{
		super();
		
		objectsInArea = new Array<FlxObject>();
		objectsInAreaThisFrame = new Array<FlxObject>();
		
		FlxG.watch(objectsInArea, "length");
		
		numObjects = 0;
	}
	
	/*public function Resize(MaxX : Int, MaxY : Int, MinX : Int, MinY : Int) : Void
	{
		//Resize the area. MinX, MinY should be the origin point. If error checking needs to be implemented, this is
		//the best place to add it.
	}*/
	
	public function OnEnter(object : FlxObject) : Void
	{
		numObjects++;
	}
	
	public function OnExit(object : FlxObject) : Void
	{
		numObjects--;
	}
	
	public function OverlapArea(object : FlxObject):Void
	{
		objectsInAreaThisFrame.push(object);
	}
	
	override public function update():Void 
	{
		super.update();
		
		handleObjects();
	
		objectsInAreaThisFrame = new Array<FlxObject>();
	}
	
	private function handleObjects():Void 
	{
		var objectHasNotTransitioned:Bool;
		var tempNewObjects:Array<FlxObject> = new Array<FlxObject>();
		
		//test if Object has entered, then store
		for (i in objectsInAreaThisFrame)
		{
			objectHasNotTransitioned = false;
			for (j in objectsInArea)
			{
				if (i == j)
					objectHasNotTransitioned = true;
			}
			if (!objectHasNotTransitioned) //new object!
				tempNewObjects.push(i);
		}
		
		var tempGoneObjects:Array<FlxObject> = new Array<FlxObject>();
		
		//test if Object has left, then store
		for (i in objectsInArea)
		{
			objectHasNotTransitioned = false;
			for (j in objectsInAreaThisFrame)
			{
				if (j == i)
					objectHasNotTransitioned = true;
			}
			if (!objectHasNotTransitioned) //new object!
				tempGoneObjects.push(i);
		}
		
		//handle the old objects
		//call OnExit on all, then remove from objectsInArea
		for (i in tempGoneObjects)
		{
			OnExit(i);
			objectsInArea.remove(i);
		}
		
		//handle the new objects
		//Call OnEnter, then add to objectsInArea
		for (i in tempNewObjects)
		{
			OnEnter(i);
			objectsInArea.push(i);
		}
	}
	
}
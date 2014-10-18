package com.skyhammer.util;

import org.flixel.FlxBasic;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxG;

/**
 * ...
 * @author Aaron
 */

class SHEmitter extends FlxGroup
{
	private var x:Float;
	private var y:Float;
	
	private var enabled:Bool;
	
	private var lifespan:FlxPoint;
	
	private var initVelocityX:FlxPoint;
	private var initVelocityY:FlxPoint;
	private var initAccelerationX:FlxPoint;
	private var initAccelerationY:FlxPoint;
	
	private var initAlpha:FlxPoint;
	private var endAlpha:FlxPoint;
	
	private var initScale:FlxPoint;
	private var endScale:FlxPoint;
	
	private var rotation:FlxPoint;
	
	private var emitRate:Float;
	private var emitTimer:Float;
	
	private var living:Int;
	
	public function new() 
	{
		super();
		
		setPosition(0,0);
		
		setLifespan(1,1);
		
		setVelocity(0, 0, 0, 0);
		setAcceleration(0, 0, 0, 0);
		
		setAlpha(1, 1, 0, 0);
		
		setScale(1, 1, 1, 1);
		
		setRotation(0, 0);
		
		enabled = false;
		emitRate = 0;
		emitTimer = 0;
		living = 0;
	}
	
	public function makeParticles(sprite:String, num:Int):Void
	{
		for (i in 0...num)
		{
			var p:SHParticle = new SHParticle();
			p.loadGraphic(sprite);
			add(p);
		}
	}
	
	override public function update():Void 
	{
		living = countLiving();
		super.update();
		if (enabled)
		{
			emitTimer += FlxG.elapsed;
			if (emitTimer >= emitRate)
			{
				emitTimer = 0;
				emit();
			}
		}
	}
	
	public function emit():Void
	{
		if (countDead() > 0)
		{
			var particle:SHParticle = cast(getFirstDead(), SHParticle);
			particle.reset(x, y);
			particle.maxLife = SHMath.fLerp(lifespan.x, lifespan.y, FlxG.random());
			particle.velocity = new FlxPoint(SHMath.fLerp(initVelocityX.x, initVelocityX.y, FlxG.random()),
											SHMath.fLerp(initVelocityY.x, initVelocityY.y, FlxG.random()));
			particle.acceleration = new FlxPoint(SHMath.fLerp(initAccelerationX.x, initAccelerationX.y, FlxG.random()),
												SHMath.fLerp(initAccelerationY.x, initAccelerationY.y, FlxG.random()));
			particle.startAlpha = SHMath.fLerp(initAlpha.x, initAlpha.y, FlxG.random());
			particle.endAlpha = SHMath.fLerp(endAlpha.x, endAlpha.y, FlxG.random());
			particle.startScale = SHMath.fLerp(initScale.x, initScale.y, FlxG.random());
			particle.endScale = SHMath.fLerp(endScale.x, endScale.y, FlxG.random());
			particle.angularVelocity = SHMath.fLerp(rotation.x, rotation.y, FlxG.random());
		}
	}
	
	public function start(emit:Float, ?burst:Bool = false):Void 
	{
		enabled = true;
		emitRate = emit;
		emitTimer = 0;
	}
	
	public function end():Void
	{
		enabled = false;
	}
	
	public function setPosition(X:Float, Y:Float):Void 
	{
		x = X;
		y = Y;
	}
	
	public function setLifespan(min:Float,max:Float):Void 
	{
		lifespan = new FlxPoint(min,max);
	}
	
	public function setVelocity(minX:Float, maxX:Float, minY:Float, maxY:Float):Void 
	{
		initVelocityX = new FlxPoint(minX, maxX);
		initVelocityY = new FlxPoint(minY, maxY);
	}
	
	public function setAcceleration(minX:Float, maxX:Float, minY:Float, maxY:Float):Void 
	{
		initAccelerationX = new FlxPoint(minX, maxX);
		initAccelerationY = new FlxPoint(minY, maxY);
	}
	
	public function setAlpha(initMin:Float, initMax:Float, endMin:Float, endMax:Float):Void 
	{
		initAlpha = new FlxPoint(initMin, initMax);
		endAlpha = new FlxPoint(endMin, endMax);
	}
	
	public function setScale(initMin:Float, initMax:Float, endMin:Float, endMax:Float):Void 
	{
		initScale = new FlxPoint(initMin, initMax);
		endScale = new FlxPoint(endMin, endMax);
	}
	public function setRotation(min:Float,max:Float):Void 
	{
		rotation = new FlxPoint(min,max);
	}
	
}
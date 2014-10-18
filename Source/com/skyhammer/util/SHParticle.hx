package com.skyhammer.util;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

/**
 * ...
 * @author Aaron
 */

class SHParticle extends FlxSprite
{
	private var _maxLife:Float;
	private var aliveTimer:Float;
	
	private var lifeScale:Float;
	
	private var _startAlpha:Float;
	private var _endAlpha:Float;
	
	private var _startScale:Float;
	private var _endScale:Float;
	
	public function new() 
	{
		super();
		
		kill();
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		aliveTimer = 0;
	}
	
	override public function update():Void 
	{
		aliveTimer += FlxG.elapsed;
		lifeScale = aliveTimer / _maxLife;
		
		if (_maxLife <= aliveTimer)
			kill();
		
		if (alive)
		{
			alpha = SHMath.fLerp(_startAlpha, _endAlpha, lifeScale);
			scale.x = SHMath.fLerp(_startScale, _endScale, lifeScale);
			scale.y = scale.x;
		}
		
		super.update();
	}
		
	
	//property setters
	private function set_startAlpha(value:Float):Float 
	{
		return _startAlpha = value;
	}
	
	public var startAlpha(null, set_startAlpha):Float;
	
	private function set_endAlpha(value:Float):Float 
	{
		return _endAlpha = value;
	}
	
	public var endAlpha(null, set_endAlpha):Float;
	
	private function set_startScale(value:Float):Float 
	{
		return _startScale = value;
	}
	
	public var startScale(null, set_startScale):Float;
	
	private function set_endScale(value:Float):Float 
	{
		return _endScale = value;
	}
	
	public var endScale(null, set_endScale):Float;
	
	private function set_maxLife(value:Float):Float 
	{
		return _maxLife = value;
	}
	
	public var maxLife(null, set_maxLife):Float;
	
}
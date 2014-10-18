package com.charcoalStyles.eti;

import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;

/**
 * ...
 * @author Aaron
 */

class Menu extends FlxState
{
	
	public function new() 
	{
		super();
		
	}
	
	override public function create():Void 
	{
		super.create();
		
		if (FlxG.mobile)
			FlxG.mouse.load("assets/null.png");
		else
			FlxG.mouse.show();
		
		var b:FlxSprite = new FlxSprite();
		b.makeGraphic(FlxG.width, FlxG.height);
		add(b);
		
		//version
		var text:FlxText = new FlxText(0, FlxG.height - 16- Vars.normalFontSize, FlxG.width, "v0.90");
		text.setFormat(Vars.fontPaskowy, Vars.normalFontSize + 6, 0x2060a0, "left");
		add(text);
		
		text  = new FlxText(0, 16, FlxG.width, "ETI");
		text.setFormat(Vars.fontVisitor, Vars.headingFontSize, 0xaaaaaa, "center");
		add(text);
		
		var button:FlxButton = new FlxButton(FlxG.width / 2, FlxG.height / 2  - 48, "Rogue", onClickRogue);
		button.x = (FlxG.width - button.width) / 2;
		add(button);
		var button:FlxButton = new FlxButton(FlxG.width / 2, FlxG.height / 2, "CA", onClickCA);
		button.x = (FlxG.width - button.width) / 2;
		add(button);
		var button:FlxButton = new FlxButton(FlxG.width / 2, FlxG.height / 2  + 48, "Hybrid", onClickH);
		button.x = (FlxG.width - button.width) / 2;
		add(button);
		
		
	}
	
	private function onClickRogue():Void
	{
		FlxG.switchState(new RogueSetup());
	}
	private function onClickCA():Void
	{
		FlxG.switchState(new CaSetup());
	}
	private function onClickH():Void
	{
		FlxG.switchState(new HybridMapGen());
	}
	
	
}
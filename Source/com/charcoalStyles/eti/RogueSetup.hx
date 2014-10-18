package com.charcoalStyles.eti;

import org.flixel.FlxButton;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxG;
/**
 * ...
 * @author Aaron
 */

class RogueSetup extends FlxState
{
	private var gW:Int;
	private var gH:Int;
	
	private var gWt:FlxText;
	private var gHt:FlxText;

	public function new() 
	{
		super();
		gW = GenVars.rlGridWidth;
		gH = GenVars.rlGridHeight;
	}
	
	override public function create():Void 
	{
		super.create();
		
		var yCounter:Int = 0;
		//Title
		var txt:FlxText = new FlxText(0, 0, FlxG.width, "Rogue-like setup");
		txt.setFormat(Vars.fontVisitor, Vars.headingFontSize, 0xffffff, "center");
		add(txt);
		
		yCounter += Std.int(Vars.headingFontSize * 1.2);
		
		//Cell width
		txt = new FlxText (0, yCounter, FlxG.width, "Supercell Width");
		txt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xffffff, "center");
		add(txt);
		yCounter += Vars.normalFontSize;
		
		gWt = new FlxText(0, yCounter, FlxG.width, Std.string(gW));
		gWt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xa0a0a0, "center");
		add(gWt);
		
		var b:FlxButton = new FlxButton(FlxG.width / 2 - 160, yCounter, "<", cwd);
		add(b);
		b = new FlxButton(FlxG.width / 2 + 80, yCounter, ">", cwu);
		add(b);
		yCounter += Std.int(Vars.normalFontSize * 1.5);
		
		//Cell height
		txt = new FlxText (0, yCounter, FlxG.width, "Supercell Height");
		txt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xffffff, "center");
		add(txt);
		yCounter += Vars.normalFontSize;
		
		gHt = new FlxText(0, yCounter, FlxG.width, Std.string(gH));
		gHt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xa0a0a0, "center");
		add(gHt);
		
		b = new FlxButton(FlxG.width / 2 - 160, yCounter, "<", chd);
		add(b);
		b = new FlxButton(FlxG.width / 2 + 80, yCounter, ">", chu);
		add(b);
		
		
		b = new FlxButton(FlxG.width / 2 - 40, FlxG.height - 30, "Start", start);
		add(b);
	}
	
	private function start():Void
	{
		GenVars.rlGridWidth = gW;
		GenVars.rlGridHeight = gH;
		FlxG.switchState(new RogueMapGen(gW,gH));
	}
	
	private function cwd():Void
	{
		gW--;
		if (gW < 1)
			gW = 1;
		gWt.text = Std.string(gW);
	}
	private function cwu():Void
	{
		gW++;
		if (gW > 10)
			gW = 10;
		gWt.text = Std.string(gW);
	}
	
	private function chd():Void
	{
		gH--;
		if (gH < 1)
			gH = 1;
		gHt.text = Std.string(gH);
	}
	private function chu():Void
	{
		gH++;
		if (gH > 10)
			gH = 10;
		gHt.text = Std.string(gH);
	}
}
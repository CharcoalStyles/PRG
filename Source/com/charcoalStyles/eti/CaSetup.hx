package com.charcoalStyles.eti;

import org.flixel.FlxButton;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxG;

/**
 * ...
 * @author Aaron
 */

class CaSetup extends FlxState
{
	private var r:Float;
	private var m:Int;
	private var t:Int;
	private var n:Int;
	private var border:Int;
	
	private var rT:FlxText;
	private var mT:FlxText;
	private var tT:FlxText;
	private var nT:FlxText;
	private var borderT:FlxText;

	public function new() 
	{
		super();
		r = GenVars.caR;
		n = GenVars.caN;
		m = GenVars.caM;
		t = GenVars.caT;
		border = GenVars.caBorder;
	}
	
	override public function create():Void 
	{
		super.create();
		
		var yCounter:Int = 0;
		
		//Title
		var txt:FlxText = new FlxText(0, 0, FlxG.width, "Cellular Automata Setup");
		txt.setFormat(Vars.fontVisitor, Vars.headingFontSize, 0xffffff, "center");
		add(txt);
		
		yCounter += Std.int(Vars.headingFontSize * 1.2);
		
		//R
		txt = new FlxText (0, yCounter, FlxG.width, "r - What percent of the grid will be randomly filled with floor");
		txt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xffffff, "center");
		add(txt);
		yCounter += Vars.normalFontSize;
		
		rT = new FlxText(0, yCounter, FlxG.width, Std.string(Std.int(r * 100))+"%");
		rT.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xa0a0a0, "center");
		add(rT);
		
		var b:FlxButton = new FlxButton(FlxG.width / 2 - 160, yCounter, "<", rd);
		add(b);
		b = new FlxButton(FlxG.width / 2 + 80, yCounter, ">", ru);
		add(b);
		yCounter += Std.int(Vars.normalFontSize * 1.5);
		
		//N
		txt = new FlxText (0, yCounter, FlxG.width, "n - Number of times to pass over the map");
		txt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xffffff, "center");
		add(txt);
		yCounter += Vars.normalFontSize;
		
		nT = new FlxText(0, yCounter, FlxG.width, Std.string(n));
		nT.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xa0a0a0, "center");
		add(nT);
		
		b = new FlxButton(FlxG.width / 2 - 160, yCounter, "<", nd);
		add(b);
		b = new FlxButton(FlxG.width / 2 + 80, yCounter, ">", nu);
		add(b);
		yCounter += Std.int(Vars.normalFontSize * 1.5);
		
		//M
		txt = new FlxText (0, yCounter, FlxG.width, "m - The \"Manhattan\" distance to evaluate around the tile");
		txt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xffffff, "center");
		add(txt);
		yCounter += Vars.normalFontSize;
		
		mT = new FlxText(0, yCounter, FlxG.width, Std.string(m));
		mT.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xa0a0a0, "center");
		add(mT);
		
		b = new FlxButton(FlxG.width / 2 - 160, yCounter, "<", md);
		add(b);
		b = new FlxButton(FlxG.width / 2 + 80, yCounter, ">", mu);
		add(b);
		yCounter += Std.int(Vars.normalFontSize * 1.5);
		
		//t
		txt = new FlxText (0, yCounter, FlxG.width, "t - The threshold of wall tile neighbours");
		txt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xffffff, "center");
		add(txt);
		yCounter += Vars.normalFontSize;
		
		tT = new FlxText(0, yCounter, FlxG.width, Std.string(t));
		tT.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xa0a0a0, "center");
		add(tT);
		
		b = new FlxButton(FlxG.width / 2 - 160, yCounter, "<", td);
		add(b);
		b = new FlxButton(FlxG.width / 2 + 80, yCounter, ">", tu);
		add(b);
		yCounter += Std.int(Vars.normalFontSize * 1.5);
		
		//t
		txt = new FlxText (0, yCounter, FlxG.width, "The size of the artifical border placed around the edge of the map");
		txt.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xffffff, "center");
		add(txt);
		yCounter += Vars.normalFontSize;
		
		borderT = new FlxText(0, yCounter, FlxG.width, Std.string(border));
		borderT.setFormat(Vars.fontVisitor, Vars.normalFontSize, 0xa0a0a0, "center");
		add(borderT);
		
		b = new FlxButton(FlxG.width / 2 - 160, yCounter, "<", bd);
		add(b);
		b = new FlxButton(FlxG.width / 2 + 80, yCounter, ">", bu);
		add(b);
		yCounter += Std.int(Vars.normalFontSize * 1.5);
		
		
		b = new FlxButton(FlxG.width / 2  - 40, FlxG.height - 32, "Start", start);
		add(b);
	}
	
	private function start():Void
	{
		GenVars.caR = r;
		GenVars.caN = n;
		GenVars.caM = m;
		GenVars.caT = t;
		GenVars.caBorder = border;
		FlxG.switchState(new CAMpGen(r,n,m,t,border));
	}
	
	private function rd():Void
	{
		r -= 0.05;
		if (r < 0.1)
			r = 0.1;
		rT.text = Std.string(Std.int(r * 100))+"%";
	}
	private function ru():Void
	{
		r += 0.05;
		if (r > 0.9)
			r = 0.9;
		rT.text = Std.string(Std.int(r * 100))+"%";
	}
	
	private function nd():Void
	{
		n--;
		if (n < 1)
			n = 1;
		nT.text = Std.string(n);
	}
	private function nu():Void
	{
		n++;
		if (n > 10)
			n = 10;
		nT.text = Std.string(n);
	}
	
	private function md():Void
	{
		m--;
		if (m < 1)
			m = 1;
		mT.text = Std.string(m);
	}
	private function mu():Void
	{
		m++;
		if (m > 4)
			m = 4;
		mT.text = Std.string(m);
	}
	
	private function td():Void
	{
		t--;
		if (t < 1)
			t = 1;
		tT.text = Std.string(t);
	}
	private function tu():Void
	{
		t++;
		if (t > 50)
			t = 50;
		tT.text = Std.string(t);
	}
	
	private function bd():Void
	{
		border--;
		if (border < 0)
			border = 0;
		borderT.text = Std.string(border);
	}
	private function bu():Void
	{
		border++;
		if (border > 6)
			border = 6;
		borderT.text = Std.string(border);
	}
}
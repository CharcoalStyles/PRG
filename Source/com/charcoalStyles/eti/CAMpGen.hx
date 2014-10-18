package com.charcoalStyles.eti;

import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxU;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.FlxButton;

/**
 * ...
 * @author Aaron
 */

class CAMpGen extends FlxState
{

	private var grid:FlxTilemap;
	
	//private static inline var gWidth:Int = 120;
	//private static inline var gHeight:Int = 60;
	private var gWidth:Int;
	private var gHeight:Int;
	
	private var mode:Int;
	private var modeFinished:Bool;
	private var timer:Float;
	private var counter:Int;
	private var passCounter:Int;
	
	private var r:Float;
	private var m:Int;
	private var t:Int;
	private var n:Int;
	private var border:Int;
	
	private var numTiles:Int;
	
	private var marker:FlxSprite;
	
	private var lastData:Array<Int>;
	
	private var currentMode:FlxText;
	
	public function new(inR:Float, inN:Int, inM:Int, inT:Int, inB:Int) 
	{
		super();
		r = inR;
		n = inN;
		m = inM;
		t = inT;
		border = inB;
	}
	
	override public function create():Void 
	{
		super.create();

		gWidth = Std.int(FlxG.width / 8);
		gHeight = Std.int((FlxG.height * 0.85) / 8);

		mode = 0;
		modeFinished = false;
		timer = 0;
		counter = 0;
		passCounter = 0;
		
		var txt:FlxText = new FlxText (0, FlxG.height - 64, FlxG.width, "Press 'Space' or mouse click to step through the generation sequence.");
		txt.setFormat(Vars.fontVisitor, 32, 0xa0a0a0, "left");
		add(txt);
		txt = new FlxText (0, FlxG.height - 32, FlxG.width, "Hold to speed up tile processing.");
		txt.setFormat(Vars.fontVisitor, 32, 0xa0a0a0, "left");
		add(txt);
		
		currentMode = new FlxText(0, FlxG.height - 106, FlxG.width, "");
		currentMode.setFormat(Vars.fontVisitor, 32, 0xffffff, "left");
		add(currentMode);
		
	}
	
	private function onClickQuit():Void
	{
		FlxG.switchState(new Menu());
	}
	
	override public function update():Void 
	{
		super.update();
		switch(mode)
		{
			case 0: //init;
				modeFinished = true;
			case 1: //make map
				if (!modeFinished)
				{
					currentMode.text = "1. Make Tilemap";
					createTileMap();
					modeFinished = true;
				}
			case 2: //generate random distro
				if (!modeFinished)
				{
					currentMode.text = "2. Fill map " + Std.string(Std.int(r * 100)) + "% with floor tiles";
					if (counter >= 0 && counter < gWidth)
					{
						for (y in 0...gHeight)
						{
							if (FlxG.random() < r)
								grid.setTile(counter, y, 0);
						}
					}
					counter++;
					if (counter == gWidth)
					{
						modeFinished = true;
						
						updateLastData();
						passCounter++;
					}
				}
			case 3:
				if (!modeFinished)
				{
					currentMode.text = "3. Process each tile. Pass " + Std.string(passCounter);
					
					for (loop in 0...((FlxG.keys.pressed("SPACE") || FlxG.mouse.pressed())? Std.int((gWidth * gHeight) * FlxG.elapsed * 0.25):1))
					{
						var baseX:Int = counter % gWidth;
						var baseY:Int = Std.int(counter / gWidth);
						
						marker.x = baseX * 8;
						marker.y = baseY * 8;
						
						numTiles = 0;
						
						for (evalY in (baseY - m)...(baseY + m + 1))
						{
							if (evalY >= 0 && evalY < gHeight)
							{
								for (evalX in (baseX - m)...(baseX + m + 1))
								{
									if (evalX >= 0 && evalX < gWidth)
									{
										numTiles += lastData[evalX + evalY * gWidth] == 2 ? 1 : 0;
									}
									else
										numTiles++;
								}
							}
							else 
								numTiles += m * 2 + 1;
						}
						
						grid.setTile(baseX, baseY, numTiles > t ? 2 : 0);
						
						counter++;
					}
					
					if (counter >= gWidth * gHeight)
						modeFinished = true;
				}
			case 4:
				if (!modeFinished)
				{
					currentMode.text = "4. Pass " + Std.string(passCounter) + " completed. " + Std.string(n - passCounter) + " passes left";
					updateLastData();
					
					if (n - passCounter != 0)
						mode = 2;
						
					passCounter++;
					modeFinished = true;
				}
			case 5:
				if (!modeFinished)
				{
					currentMode.text = "5. Place border.";
					if (counter < border || counter > gWidth - border - 1)
					{
						for (y in 0...gHeight)
						{
							grid.setTile(counter, y, 2);
						}
					}
					else
					{
						for (y in 0...border)
						{
							grid.setTile(counter, y, 2);
						}
						for (y in gHeight-border...gHeight)
						{
							grid.setTile(counter, y, 2);
						}
					}
					counter++;
					if (counter == gWidth)
					{
						modeFinished = true;
						
						updateLastData();
						passCounter++;
					}
				}
			case 6:
					currentMode.text = "Finished!";
		}
		
		if ((FlxG.keys.justPressed("SPACE") || FlxG.mouse.justPressed()) && modeFinished)
		{
			mode++;
			modeFinished = false;
			timer = 0;
			counter = 0;
		}
		
		if (FlxG.keys.pressed("CONTROL") && (FlxG.keys.pressed("SPACE") || FlxG.mouse.pressed()) && mode > 3)
		{
			mode++;
			modeFinished = false;
			timer = 0;
			counter = 0;
		}
		
		if (FlxG.keys.justPressed("M"))
		{
				FlxG.switchState(new Menu());
		}
	}
	
	private function createTileMap():Void 
	{
		grid = new FlxTilemap();
		var mapString:String = "";
		for (y in 0...gHeight)
		{
			for (x in 0...gWidth )
			{
				mapString += "2";
				if (x < gWidth - 1)
					mapString += ",";
			}
			mapString += "\n";
		}
		
		grid.loadMap(mapString, "assets/tiles.png", 8, 8, 0, 0, 0, 2);
		
		add(grid);
		
		marker = new FlxSprite( -10, -10);
		marker.makeGraphic(8, 8, 0x80FF8080);
		add(marker);
		var button:FlxButton = new FlxButton(FlxG.width -80, FlxG.height -30, "Quit", onClickQuit);
		add(button);
	}
	
	private function updateLastData():Void 
	{
		var tData:Array<Int> = grid.getData();
		
		var i:Int = 0;
		var l:Int = tData.length;
		lastData = new Array(/*l*/);
		FlxU.SetArrayLength(lastData, l);
		while(i < l)
		{
			lastData[i] = tData[i];
			i++;
		}
	}
}
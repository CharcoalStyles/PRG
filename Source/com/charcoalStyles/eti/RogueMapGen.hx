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
import org.flixel.FlxObject;
import org.flixel.plugin.photonstorm.FlxBar;


class RogueMapGen extends FlxState
{

	private var grid:FlxTilemap;
	
	//private static inline var gWidth:Int = 120;
	//private static inline var gHeight:Int = 60;
	private var gWidth:Int;
	private var gHeight:Int;
	
	private var rGridWidth:Int;
	private var rGridHeight:Int;
	
	private var mode:Int;
	private var modeFinished:Bool;
	private var timer:Float;
	private var counter:Int;
	private var scounter:Int;
	
	private var rogueOverlay:FlxGroup;
	private var roOverlay:Array<Array<RogueOverlay>>;
	
	private var activeRO:FlxPoint;
	private var nextRO:FlxPoint;
	private var cDir:Int;
	
	private var currentMode:FlxText;
	
	private var initRO:RogueOverlay;
	private var lastRO:RogueOverlay;
	
	private var start:FlxSprite;
	private var end:FlxSprite;
	
	private var corridorBreaks:Array<FlxPoint>;
	private var corridorBreaksPowerSet:Array<Array<FlxPoint>>;
	private var paths:Array<FlxPath>;
	private var bestPath:FlxPath;
	
	private var pBar:FlxBar;
	
	private var critPath:Array<FlxPoint>;
	private var eval:FlxSprite;
	private var lastPoint:FlxPoint;
	
	private var player:FlxSprite;
	private var playerPath:FlxPath;
	
	public function new(inW:Int, inH:Int) 
	{
		super();
		rGridWidth = inW;
		rGridHeight = inH;
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
		scounter = 0;
		
		activeRO = new FlxPoint();
		nextRO = new FlxPoint();
		
		var txt:FlxText = new FlxText (0, FlxG.height - 64, FlxG.width, "Press 'Space' or mouse click to step through the generation sequence.");
		txt.setFormat(Vars.fontVisitor, 32, 0xa0a0a0, "left");
		add(txt);
		txt = new FlxText (0, FlxG.height - 32, FlxG.width, "Press 'R' to remove the data overlay.");
		txt.setFormat(Vars.fontVisitor, 32, 0xa0a0a0, "left");
		add(txt);
		
		currentMode = new FlxText(0, FlxG.height - 106, FlxG.width, "");
		currentMode.setFormat(Vars.fontVisitor, 32, 0xffffff, "left");
		add(currentMode);
		
		start = null;
		end = null;
				
		corridorBreaks = new Array<FlxPoint>();
		paths = new Array<FlxPath>();
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
			case 2: //clean map
				if (!modeFinished)
				{
					currentMode.text = "2. Fill map with 'wall' tiles";
					for (y in 0...gHeight)
					{
						grid.setTile(counter, y, 2);
					}
					
					counter++;
					if (counter == gWidth)
						modeFinished = true;
				}
			case 3: //rogue grid overlay
				if (!modeFinished)
				{
					currentMode.text = "3. Divide the map into supercells";
					if (counter == 0)
					{
						rogueOverlay = new FlxGroup();
						add(rogueOverlay);
						roOverlay = new Array<Array<RogueOverlay>>();
						for (x in 0...rGridWidth)
						{
							roOverlay[x] = new Array<RogueOverlay>();
						}
					}
					
					timer += FlxG.elapsed;
					
					if (timer > 0.5 / (rGridWidth * rGridHeight))
					{
						timer = 0;
						
						createRogueGridOverlay(counter);
						counter++;
						
						if (counter == rGridHeight * rGridWidth)
						{
							modeFinished = true;
						}
					}
				}
			case 4: //Inital room
				if (!modeFinished)
				{
					currentMode.text = "4. Pick a random supercell to be the 'active' cell";
					activeRO = new FlxPoint(FlxG.random() * rGridWidth, FlxG.random() * rGridHeight);
					roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isActive = true;
					roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isConnected = true;
					
					modeFinished = true;
					
					initRO = roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)];
					//createConnection(roOverlay[0][0], roOverlay[1][0]);
				}
			case 5://Room Loop - Next Room
				if (!modeFinished)
				{
					currentMode.text = "5. Find an adjacent 'unconnected' cell";
					var foundRoom:Bool = false;
					var checkedRooms:Array<Int> = new Array<Int>();
					
					while (!foundRoom && checkedRooms.length < 4)
					{
						var nextRoom:Int = -1;
						
						while (nextRoom == -1)
						{
							nextRoom = Std.int(FlxG.random() * 4);
							for (i in checkedRooms)
							{
								if (i == nextRoom)
									nextRoom = -1;
							}
						}
						
						cDir = nextRoom;
						
						switch (nextRoom)
						{
							case 0://up
								if (Std.int(activeRO.y) > 0 && 
									!roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y - 1)].isConnected)
								{
									foundRoom = true;
									nextRO = new FlxPoint(activeRO.x, activeRO.y - 1);
									roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room.color = 0xe0b0a0;
								}
								else
									checkedRooms.push(0);
							case 1://right
								if (Std.int(activeRO.x) < rGridWidth - 1 && 
									!roOverlay[Std.int(activeRO.x + 1)][Std.int(activeRO.y)].isConnected)
								{
									foundRoom = true;
									nextRO = new FlxPoint(activeRO.x + 1, activeRO.y);
									roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room.color = 0xe0b0a0;
								}
								else
									checkedRooms.push(1);
							case 2://down
								if (Std.int(activeRO.y) < rGridHeight - 1 && 
									!roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y + 1)].isConnected)
								{
									foundRoom = true;
									nextRO = new FlxPoint(activeRO.x, activeRO.y + 1);
									roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room.color = 0xe0b0a0;
								}
								else
									checkedRooms.push(2);
							case 3://left
								if (Std.int(activeRO.x) > 0 && 
									!roOverlay[Std.int(activeRO.x - 1)][Std.int(activeRO.y)].isConnected)
								{
									foundRoom = true;
									nextRO = new FlxPoint(activeRO.x - 1, activeRO.y);
									roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room.color = 0xe0b0a0;
								}
								else
									checkedRooms.push(3);
						}
					}
					
					if (checkedRooms.length == 4)
					{
						mode = 6;
						roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isActive = false;
					}
					
					modeFinished = true;
				}
			case 6://Room Loop - make Connection
				if (!modeFinished)
				{
					currentMode.text = "6. Connect them, make the new cell the 'active' cell";
					createConnection(roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)],
									 roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)]);
									 
					//make corridor
					makeCorridor(roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].room,
								 roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room, 0xffa0a0a0);
					
					roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isActive = false;
					activeRO = nextRO;
					roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isActive = true;
					roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isConnected = true;
					
					mode = 4;
					modeFinished = true;
					
					lastRO = roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)];
				}
			case 7://Spare Room Loop - find room
				if (!modeFinished)
				{
					currentMode.text = "7. Find a random unconnected cell";
					var unlinkedCells:Array<FlxPoint> = new Array<FlxPoint>();
					for (y in 0...rGridHeight)
					{
						for (x in 0...rGridWidth)
						{
							var fp:FlxPoint = new FlxPoint(x, y);
							if (!roOverlay[x][y].isConnected)
								unlinkedCells.push(fp);
						}
					}
					
					if (unlinkedCells.length > 0)
					{
						FlxU.shuffle(unlinkedCells, 3 * unlinkedCells.length);
						activeRO = unlinkedCells.pop();
						roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isActive = true;
					}
					else
						mode = 9;
					
					modeFinished = true;
				}
			case 8://Spare Room Loop - find connected room
				if (!modeFinished)
				{
					currentMode.text = "8. Find an adjacent 'connected' cell";
					var foundRoom:Bool = false;
					var checkedRooms:Array<Int> = new Array<Int>();
					
					while (!foundRoom && checkedRooms.length < 4)
					{
						var nextRoom:Int = -1;
						
						while (nextRoom == -1)
						{
							nextRoom = Std.int(FlxG.random() * 4);
							for (i in checkedRooms)
							{
								if (i == nextRoom)
									nextRoom = -1;
							}
						}
						
						cDir = nextRoom;
						
						switch (nextRoom)
						{
							case 0://up
								if (Std.int(activeRO.y) > 0 && 
									roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y - 1)].isConnected)
								{
									foundRoom = true;
									nextRO = new FlxPoint(activeRO.x, activeRO.y - 1);
									roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room.color = 0xe0b0a0;
								}
								else
									checkedRooms.push(0);
							case 1://right
								if (Std.int(activeRO.x) < rGridWidth - 1 && 
									roOverlay[Std.int(activeRO.x + 1)][Std.int(activeRO.y)].isConnected)
								{
									foundRoom = true;
									nextRO = new FlxPoint(activeRO.x + 1, activeRO.y);
									roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room.color = 0xe0b0a0;
								}
								else
									checkedRooms.push(1);
							case 2://down
								if (Std.int(activeRO.y) < rGridHeight - 1 && 
									roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y + 1)].isConnected)
								{
									foundRoom = true;
									nextRO = new FlxPoint(activeRO.x, activeRO.y + 1);
									roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room.color = 0xe0b0a0;
								}
								else
									checkedRooms.push(2);
							case 3://left
								if (Std.int(activeRO.x) > 0 && 
									roOverlay[Std.int(activeRO.x - 1)][Std.int(activeRO.y)].isConnected)
								{
									foundRoom = true;
									nextRO = new FlxPoint(activeRO.x - 1, activeRO.y);
									roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room.color = 0xe0b0a0;
								}
								else
									checkedRooms.push(3);
						}
					}
					
					if (checkedRooms.length == 4)
					{
						mode = 6;
						roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isActive = false;
					}
					
					modeFinished = true;
				}
				case 9://Spare Room Loop - make connection
					if (!modeFinished)
					{
					currentMode.text = "9. Connect them";
						createConnection(roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)],
										 roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)]);
										 
						//make corridor
						makeCorridor(roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].room,
									 roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].room, 0xffa0a0a0);
						
						roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)].isActive = false;
						roOverlay[Std.int(nextRO.x)][Std.int(nextRO.y)].isActive = false;
						
						mode = 6;
						modeFinished = true;
						
						//lastRO = roOverlay[Std.int(activeRO.x)][Std.int(activeRO.y)];
					}
				case 10://random connections loop 
					if (!modeFinished)
					{
						if (scounter == 0)
						{
							scounter = Std.int((FlxG.random() * rGridWidth * rGridHeight) / 2 + 1);
							
						}
						currentMode.text = "10. Connect two random adjacent rooms, " + Std.string(scounter) + " times";
						
						var rX:Int = Std.int(FlxG.random() * rGridWidth);
						var rY:Int = Std.int(FlxG.random() * rGridHeight);
						var oX:Int = -1;
						var oY:Int = -1;
						
						cDir = Std.int(FlxG.random() * 4);
						
						switch (cDir)
						{
							case 0:
								oX = rX;
								oY = rY - 1;
							case 1:
								oX = rX + 1;
								oY = rY;
							case 2:
								oX = rX;
								oY = rY + 1;
							case 3:
								oX = rX - 1;
								oY = rY;
						}
						
						if (oX >= 0 &&
							oX < rGridWidth &&
							oY >= 0 &&
							oY < rGridHeight)
							{
								createConnection(roOverlay[rX][rY],
												 roOverlay[oX][oY]);
								makeCorridor(roOverlay[rX][rY].room,
											 roOverlay[oX][oY].room, 0xffff80a0);
								
								scounter--;
							}
							
						if (scounter <= 0)
						{
							scounter = 0;
							modeFinished = true;
						}
						else
						{
							mode --;
							modeFinished = true;
						}
					}
				case 11: // make rooms
					if (!modeFinished)
					{
						currentMode.text = "11. Place rooms within the border of the supercell";
						var rX:Int = scounter % rGridWidth;
						var rY:Int = Std.int(scounter / rGridWidth);
						
						roOverlay[rX][rY].room.alpha = 0.33;
						
						var cWidth:Int = Std.int(grid.widthInTiles / rGridWidth);
						var cHeight:Int = Std.int(grid.heightInTiles / rGridHeight);
						
						var x:Int = (rX * cWidth) + Std.int((FlxG.random() * 0.3 + 0.1) * cWidth);
						var y:Int = (rY * cHeight) + Std.int((FlxG.random() * 0.3 + 0.1) * cHeight);
						var w:Int = Std.int((FlxG.random() * 0.4 + 0.3) * cWidth);
						var h:Int = Std.int((FlxG.random() * 0.4 + 0.3) * cHeight);
						
						for (X in x...(x + w))
						{
							for (Y in y...(y + h))
							{
								grid.setTile(X, Y, 0);
							}
						}
						
						if (scounter == (rGridHeight * rGridWidth - 1))
						{
							scounter = 0;
							modeFinished = true;
						}
						else
						{
							scounter++;
							mode--;
							modeFinished = true;
						}
					}
				case 12://make paths
					if (!modeFinished)
					{
						currentMode.text = "12. Connect the rooms with paths";
						var sX:Int = scounter % rGridWidth;
						var sY:Int = Std.int(scounter / rGridWidth);
						
						var cWidth:Int = Std.int(grid.widthInTiles / rGridWidth);
						var cHeight:Int = Std.int(grid.heightInTiles / rGridHeight);
						
						for (conCell in roOverlay[sX][sY].connections)
						{
							var corridorTiles:Array<FlxPoint> = new Array<FlxPoint>();
							
							var sTX:Int = Std.int(sX * cWidth + cWidth * FlxG.random());
							var sTY:Int = Std.int(sY * cHeight + cHeight * FlxG.random());
							
							var eX:Int = conCell % rGridWidth;
							var eY:Int = Std.int(conCell / rGridWidth);
							
							var eTX:Int = Std.int(eX * cWidth + cWidth * FlxG.random());
							var eTY:Int = Std.int(eY * cHeight + cHeight * FlxG.random());
							
							while (grid.getTile(sTX, sTY) >= 2)
							{
								sTX = Std.int(sX * cWidth + cWidth * FlxG.random());
								sTY = Std.int(sY * cHeight + cHeight * FlxG.random());
							}
							
							while (grid.getTile(eTX, eTY) >= 2)
							{
								eTX = Std.int(eX * cWidth + cWidth * FlxG.random());
								eTY = Std.int(eY * cHeight + cHeight * FlxG.random());
							}
							
							var wX:Int = sTX;
							var wY:Int = sTY;
							var totalX:Int = eTX - sTX;
							var totalY:Int = eTY - sTY;
							
							while (totalX != 0 || totalY != 0)
							{
								if (FlxG.random() > (totalX > totalY ? 0.3:0.7))
								{
									wX += totalX > 0 ? 1: -1;
									totalX -= totalX > 0 ? 1: -1;
								}
								else
								{
									wY += totalY > 0 ? 1: -1;
									totalY -= totalY > 0 ? 1: -1;
								}
								
								if (grid.getTile(wX, wY) >= 2)
								{
									grid.setTile(wX, wY, 1, true);
									corridorTiles.push(new FlxPoint(wX, wY));
								}
							}
							
							var goodBreak:Bool = false;
							var c:Int = 0;
							
							while (!goodBreak)
							{
								var workingTile:FlxPoint = corridorTiles[c];
								
								var count:Int = 0;
								if (grid.getTile(Std.int(workingTile.x+1), Std.int(workingTile.y)) <= 1)
									count++;
								if (grid.getTile(Std.int(workingTile.x-1), Std.int(workingTile.y)) <= 1)
									count++;
								if (grid.getTile(Std.int(workingTile.x), Std.int(workingTile.y+1)) <= 1)
									count++;
								if (grid.getTile(Std.int(workingTile.x), Std.int(workingTile.y-1)) <= 1)
									count++;
									
								/*if (grid.getTile(Std.int(workingTile.x+1), Std.int(workingTile.y+1)) <= 1)
									count++;
								if (grid.getTile(Std.int(workingTile.x-1), Std.int(workingTile.y-1)) <= 1)
									count++;
								if (grid.getTile(Std.int(workingTile.x-1), Std.int(workingTile.y+1)) <= 1)
									count++;
								if (grid.getTile(Std.int(workingTile.x+1), Std.int(workingTile.y-1)) <= 1)
									count++;*/
									
								if (count == 2)
								{
									goodBreak = true;
									corridorBreaks.push(workingTile);
								}
								else 
								{
									c++;
									if (c == corridorTiles.length)
										goodBreak = true;
								}
							}
							
							roOverlay[eX][eY].connections.remove(scounter);
						}
						
						if (scounter == (rGridHeight * rGridWidth - 1))
						{
							scounter = 0;
							modeFinished = true;
						}
						else
						{
							scounter++;
							mode--;
							modeFinished = true;
						}
					} 
					case 13:
					/*if (!modeFinished)
					{
						if (counter == 0)
						{
							corridorBreaksPowerSet = new Array<Array<FlxPoint>>();
							corridorBreaksPowerSet.push(new Array<FlxPoint>());
							pBar = new FlxBar(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2) - 50, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10, null, "", 0, corridorBreaks.length, true);
							add(pBar);
						}
						
						var element:FlxPoint = corridorBreaks[counter];
						
						var tResults:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
						for (combo in corridorBreaksPowerSet)
						{
							var thisArray:Array<FlxPoint> = new Array<FlxPoint>();
							for (i in combo)
							{
								thisArray.push(i);
							}
							thisArray.push(element);
							tResults.push(thisArray);
						}
						corridorBreaksPowerSet = corridorBreaksPowerSet.concat(tResults);
						
						counter++;
						pBar.setCurrentValue(counter);
						
						if (counter == corridorBreaks.length)
						{
							trace("CBPS.l: " + corridorBreaksPowerSet.length);
							modeFinished = true;
							remove(pBar);
						}
						
					}
					case 14:*/
					if (!modeFinished)
					{
						currentMode.text = "13. Place entrance and exit (first and last super cells joined)";
						var cWidth:Int = Std.int(grid.widthInTiles / rGridWidth);
						var cHeight:Int = Std.int(grid.heightInTiles / rGridHeight);
						
						var sX:Int = (initRO.index % rGridWidth);
						var sY:Int = Std.int(initRO.index / rGridWidth);
						var eX:Int = lastRO.index % rGridWidth;
						var eY:Int = Std.int(lastRO.index / rGridWidth);
						
						var sTX:Int = Std.int(sX * cWidth + cWidth * FlxG.random());
						var sTY:Int = Std.int(sY * cHeight + cHeight * FlxG.random());
						
						var eTX:Int = Std.int(eX * cWidth + cWidth * FlxG.random());
						var eTY:Int = Std.int(eY * cHeight + cHeight * FlxG.random());
						
						while (grid.getTile(sTX, sTY) >= 1)
						{
							sTX = Std.int(sX * cWidth + cWidth * FlxG.random());
							sTY = Std.int(sY * cHeight + cHeight * FlxG.random());
						}
						
						while (grid.getTile(eTX, eTY) >= 1)
						{
							eTX = Std.int(eX * cWidth + cWidth * FlxG.random());
							eTY = Std.int(eY * cHeight + cHeight * FlxG.random());
						}
						
						start = new FlxSprite(sTX * 8, sTY * 8);
						start.makeGraphic(8, 8, 0xff80ff80);
						add(start);
						end = new FlxSprite(eTX * 8, eTY * 8);
						end.makeGraphic(8, 8, 0xffff8080);
						add(end);
						
						modeFinished = true;
					}
					/*case 15:
						if (!modeFinished)
						{
							if (counter == 0)
							{
								bestPath = grid.findPath(new FlxPoint(start.x, start.y),
																  new FlxPoint(end.x, end.y));
								eval = new FlxSprite(start.x, start.y);
								eval.makeGraphic(4, 4, 0xff40ff80);
								eval.followPath(bestPath);
								add(eval);
								
								critPath= new Array<FlxPoint>();
								
								lastPoint = new FlxPoint(Std.int(eval.x / 8), Std.int(eval.y / 8));
								counter++;
							}
						
							if (Std.int(eval.x / 8) != Std.int(lastPoint.x) || Std.int(eval.y / 8) != Std.int(lastPoint.y))
							{
								lastPoint = new FlxPoint(Std.int(eval.x / 8), Std.int(eval.y / 8));
								for (t in corridorBreaks)
								{
									if (Std.int(lastPoint.x) == Std.int(t.x) && Std.int(lastPoint.y) == Std.int(t.y))
									{
										var point:FlxPoint = new FlxPoint(Std.int(lastPoint.x), Std.int(lastPoint.y));
										critPath.push(point);
										var cp:FlxSprite = new FlxSprite(lastPoint.x * 8, lastPoint.y * 8);
										cp.makeGraphic(8, 8, 0xffff8030);
										add(cp);
									}
								}
							}
							
							var killset:Array<Array<FlxPoint>> = new Array<Array<FlxPoint>>();
							if (FlxU.getDistance(new FlxPoint(eval.x, eval.y), new FlxPoint(end.x, end.y)) < 20)
							{
								remove(eval);
								for (cb in corridorBreaksPowerSet)
								{
									var kill:Bool = true;
									for (bk in cb)
									{
										for (cp in critPath)
										{
											if (bk.x == cp.x && bk.y == cp.y)
												kill = false;
										}
									}
									
									if (kill)
										killset.push(cb);
										//corridorBreaksPowerSet.remove(cb);
								}
								
								for (k in killset)
								{
									corridorBreaksPowerSet.remove(k);
								}
								
								trace("CBPS.l: " + corridorBreaksPowerSet.length);
								
								modeFinished = true;
							}
							
						}
					case 16:
					if (!modeFinished)
					{
						if (counter == 0)
						{
							paths = new Array<FlxPath>();
							pBar = new FlxBar(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2) - 50, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10, null, "", 0, corridorBreaksPowerSet.length, true);
							add(pBar);
						}
						
						for (i in 0...100)
						{
							if (counter < corridorBreaksPowerSet.length)
							{
								for (cb in corridorBreaksPowerSet[counter])
								{
									grid.setTile(Std.int(cb.x), Std.int(cb.y), 3);
								}
								
								var p:FlxPath = grid.findPath(new FlxPoint(start.x, start.y),
															  new FlxPoint(end.x, end.y));
															  
								if (p != null)
								{
									paths.push(p);
								}
								
								for (cb in corridorBreaksPowerSet[counter])
								{
									grid.setTile(Std.int(cb.x), Std.int(cb.y), 1);
								}
								
								counter++;
								pBar.setCurrentValue(counter);
							}
						}
						
						if (counter == corridorBreaksPowerSet.length)
						{
							modeFinished = true;
							remove(pBar);
						}
					}
					case 17:
					if (!modeFinished)
					{
						if (counter < paths.length)
						{
							var s:FlxSprite = new FlxSprite(paths[counter].head().x, paths[counter].head().y);
							s.makeGraphic(4, 4, 0xff4080ff);
							add(s);
							s.followPath(paths[counter], 100, FlxObject.PATH_YOYO);
							counter++;
						}
					}*/
					case 14:
						if (!modeFinished)
						{
							currentMode.text = "Finished! Click to move the 'player' around";
							if (counter == 0)
							{
								player = new FlxSprite(start.x, start.y);
								player.makeGraphic(8, 8, 0xFF4080FF);
								add(player);
								counter++;
								
							}
							if (FlxG.mouse.justPressed())
							{
								playerPath = grid.findPath(new FlxPoint(player.x, player.y), FlxG.mouse.getWorldPosition());
								if (playerPath != null)
								{
									playerPath.debugColor = 0xa040a0;
									player.followPath(playerPath);
								}
							}
							
							if (playerPath != null && FlxU.getDistance(new FlxPoint(player.x, player.y), playerPath.tail()) <= 8)
							{
								player.stopFollowingPath(false);
								player.velocity = new FlxPoint();
							}
							
						}
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
		
		if (FlxG.keys.justPressed("R"))
		{
			rogueOverlay.exists = !rogueOverlay.exists;
		}
		if (FlxG.keys.justPressed("M"))
		{
				FlxG.switchState(new Menu());
		}
		
		#if blackberry
		if (FlxG.mouse.justPressed())
		{
			oyPos = FlxG.mouse.y;
			switched = false;
		}
		
		if (FlxG.mouse.pressed() && FlxG.mouse.y - oyPos > 30 && !switched)
		{
			switched = true;
			rogueOverlay.exists = !rogueOverlay.exists;
		}
		#end
	}
	
	private var oyPos:Float;
	private var switched:Bool;
	
	private function createConnection(ro1:RogueOverlay, ro2:RogueOverlay)
	{
		ro1.addConnection(ro2.index);
		ro2.addConnection(ro1.index);
	}
	
	private function createTileMap():Void 
	{
		grid = new FlxTilemap();
		var mapString:String = "";
		for (y in 0...gHeight)
		{
			for (x in 0...gWidth )
			{
				mapString += Std.string(Std.int(FlxG.random() * 4));
				if (x < gWidth - 1)
					mapString += ",";
			}
			mapString += "\n";
		}
		
		grid.loadMap(mapString, "assets/tiles.png", 8, 8, 0, 0, 0, 2);
		
		add(grid);
		var button:FlxButton = new FlxButton(FlxG.width -80, FlxG.height -30, "Quit", onClickQuit);
		add(button);
	}
	
	private function createRogueGridOverlay(counter:Int):Void 
	{
		var x:Int = counter % rGridWidth;
		var y:Int = Std.int(counter / rGridWidth);
		
		var w:Int = Std.int(gWidth * 8 / rGridWidth);
		var h:Int = Std.int(gHeight * 8 / rGridHeight);
	
		
		roOverlay[x][y] = new RogueOverlay(x * w, y * h, w, h, counter);
		rogueOverlay.add(roOverlay[x][y]);
		
		//roOverlay[2][1].isConnected = true;
	}
	
	private function makeCorridor(aFRoom:FlxSprite, nFRoom:FlxSprite, color:Int):Void 
	{
		var corridor:FlxSprite = new FlxSprite();
		switch(cDir)
		{
			case 0://up
				corridor = new FlxSprite(nFRoom.x + nFRoom.width / 2 - 5, nFRoom.y + nFRoom.height);
				corridor.makeGraphic(10, Std.int(aFRoom.y - (nFRoom.y + nFRoom.height)), color);
			case 1://right
				corridor = new FlxSprite(aFRoom.x + aFRoom.width, aFRoom.y + (aFRoom.height / 2) - 5);
				corridor.makeGraphic(Std.int(nFRoom.x - (aFRoom.x + aFRoom.width)), 10, color);
			case 2://down
				corridor = new FlxSprite(aFRoom.x + aFRoom.width / 2 - 5, aFRoom.y + aFRoom.height);
				corridor.makeGraphic(10, Std.int(nFRoom.y - (aFRoom.y + aFRoom.height)), color);
			case 3://left
				corridor = new FlxSprite(nFRoom.x + nFRoom.width, nFRoom.y + (nFRoom.height / 2) - 5);
				corridor.makeGraphic(Std.int(aFRoom.x - (nFRoom.x + nFRoom.width)), 10, color);
		}
		rogueOverlay.add(corridor);
	}
	
	override public function draw():Void 
	{
		super.draw();
		if (playerPath != null)
		{
			playerPath.drawDebug();
			player.draw();
		}
		
	}
}

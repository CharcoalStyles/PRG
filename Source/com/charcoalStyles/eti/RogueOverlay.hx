package com.charcoalStyles.eti;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxG;

/**
 * ...
 * @author Charcoal
 */

class RogueOverlay extends FlxGroup
{
	private var connected:Bool;
	
	public var index:Int;
	public var connections:Array<Int>;
	
	private var flagSprite:FlxSprite;
	private var array:FlxText;
	private var arrayShadow:FlxText;
	public var room:FlxSprite;
	private var _active:Bool;
	
	public var cave:Bool;
	
	public function new(X:Float, Y:Float, W:Int, H:Int, I:Int)
	{
		super();
		
		index = I;
		
		//make overlay
		var bkgrnd:FlxSprite = new FlxSprite(X, Y);
		var c:Int =  0x80000000 + Std.int(FlxG.random() * 0x00888888);
		bkgrnd.makeGraphic(W, H, c);
		add(bkgrnd);
		
		//make Flag
		flagSprite = new FlxSprite(X + W - 15, Y);
		flagSprite.makeGraphic(15, 15);
		add(flagSprite);
		isConnected = false;
		
		//make index text
		var txt:FlxText= new FlxText(X+2, Y+2, W);
		txt.setFormat(Vars.fontVisitor, 32, 0);
		txt.text = Std.string(I);
		add(txt);
		
		txt = new FlxText(X, Y, W);
		txt.setFormat(Vars.fontVisitor, 32);
		txt.text = Std.string(I);
		add(txt);
		
		//make arrayText
		arrayShadow = new FlxText(X + 1, Y + H - 20 + 1, W, "[]");
		arrayShadow.setFormat(Vars.fontVisitor, 16, 0x000000);
		add(arrayShadow);
		array = new FlxText(X, Y + H - 20, W, "[]");
		array.setFormat(Vars.fontVisitor, 16, 0xFFFFFF);
		add(array);
		
		connections = new Array<Int>();
		
		//make frooms
		room = new FlxSprite (X + Std.int(W / 4), Y + Std.int(H / 4));
		room.makeGraphic(Std.int(W / 2), Std.int(H / 2));
		add(room);
		
		active = false;
		cave = false;
	}
	
	public function addConnection(otherCell:Int):Void
	{
		connections.push(otherCell);
		array.text = Std.string(connections);
		arrayShadow.text = Std.string(connections);
		setIsConnected(true);
	}
	
	private function getIsConnected():Bool
	{
		return connected;
	}
	
	private function setIsConnected(value:Bool):Bool
	{
		connected = value;
		
		flagSprite.color = value ? 0x00ff00 : 0xff0000;
		
		return value;
	}
	
	public var isConnected(getIsConnected, setIsConnected):Bool;
	
	
	private function getIsActive():Bool
	{
		return _active;
	}
	
	private function setIsActive(value:Bool):Bool
	{
		_active = value;
		
		room.color = value ? 0xa0e0b0 : 0xFFFFFF;
		
		return value;
	}
	
	public var isActive(getIsActive, setIsActive):Bool;
	
	private function getIsCave():Bool
	{
		return cave;
	}
	
	private function setIsCave(value:Bool):Bool
	{
		cave = value;
		
		room.color = value ? 0x404040 : 0xFFFFFF;
		
		return value;
	}
	
	public var isCave(getIsCave, setIsCave):Bool;
	
}
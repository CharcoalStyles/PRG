package com.skyhammer.util;

//url Stuff
import nme.display.BitmapData;
import nme.utils.ByteArray;

import lib.encode.JPGEncoder;

import org.flixel.FlxG;


/**
 * ...
 * @author Aaron
 */

class ScreenShotUploader 
{

	public static function uploadBitmapData(bitmapData:BitmapData):Void {
		var jpgEncoder:JPGEncoder = new JPGEncoder(90);
		
		var byteArray:ByteArray = jpgEncoder.encode(bitmapData);
		
		//var f:File = new File();
	}
	
}
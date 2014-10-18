package com.charcoalStyles.eti;

/**
 * ...
 * @author Aaron
 */

class GenVars 
{

	public static var rlGridWidth:Int;
	public static var rlGridHeight:Int;
	
	public static var caR:Float;
	public static var caM:Int;
	public static var caT:Int;
	public static var caN:Int;
	public static var caBorder:Int;
	
	public static function setup()
	{
		rlGridHeight = 3;
		rlGridWidth = 5;
		
		caR = 0.5;
		caM = 1;
		caN = 3;
		caT = 5;
		caBorder = 1;
	}
}
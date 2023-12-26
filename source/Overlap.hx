package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.FlxG;

class Overlap
{
    public static function overlapMouse(obj:FlxObject):Bool
	{
		return (FlxG.mouse.getScreenPosition().x >= obj.x && FlxG.mouse.getScreenPosition().x <= obj.x + obj.width && FlxG.mouse.getScreenPosition().y >= obj.y && FlxG.mouse.getScreenPosition().y <= obj.y + obj.height);
	}
	public static function overlapMouseGrp(grp:FlxTypedGroup<Dynamic>):Bool
	{
		for (i in grp.members)
		{
			if (FlxG.mouse.getScreenPosition().x >= i.x && FlxG.mouse.getScreenPosition().x <= i.x + i.width && FlxG.mouse.getScreenPosition().y >= i.y && FlxG.mouse.getScreenPosition().y <= i.y + i.height) return true;
		}
		return false;
	}
}
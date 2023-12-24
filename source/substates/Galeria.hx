package substates;

import flixel.FlxSubState;

class Galeria extends MusicBeatSubstate
{
    var bg:FlxSprite;

    public function new()
        {
            super();

            bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            bg.alpha = 0;
            bg.scrollFactor.set();
            add(bg);
        }
}
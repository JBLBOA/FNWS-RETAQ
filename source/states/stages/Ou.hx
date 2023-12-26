package states.stages;

import states.stages.objects.*;

class Ou extends BaseStage
{
    var weones:FlxSprite;
	override function create()
	{
        game.flipSides = true;

        var fondo:FlxSprite = new FlxSprite(400).loadGraphic(Paths.image('stages/ou/fondo'));
        add(fondo);

        weones = new FlxSprite(1100, 220);
        weones.frames = Paths.getSparrowAtlas('stages/ou/trolls');
        weones.animation.addByPrefix('idle', 'TROLLSIDLE', 24, false);
        weones.scrollFactor.set(0.9, 0.965);
        add(weones);
	}
	
	override function createPost()
	{
        var arbusto:FlxSprite = new FlxSprite(1200, 300).loadGraphic(Paths.image('stages/ou/arbusto'));
        arbusto.scale.set(1.05, 1.05);
        arbusto.scrollFactor.set(1.1, 1.1);
        add(arbusto);
	}

    override function countdownTick(count, num)
    {
        if (num % 2 == 1)
            weones.animation.play('idle');
    }

    override function beatHit()
    {
        if (curBeat % 2 == 1)
            weones.animation.play('idle');
    }
}
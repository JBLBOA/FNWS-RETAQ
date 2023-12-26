package states.stages;

import substates.GameOverSubstate;
import objects.HealthIcon;
import objects.Character;
import states.stages.objects.*;

class Rizzmas extends BaseStage
{
    var path:String = 'stages/rizzmas/';

    var bg:FlxSprite;
    var bgroto:FlxSprite;
    var weas:FlxSprite;

    var trineo1:FlxSprite;
    var bolsas:FlxSprite;
    var trineo2:FlxSprite;

	var blackScreen:FlxSprite;

	var crick:Character;
	var crickIcon:HealthIcon;

	var tweenArray:Array<FlxTween> = [];

	override function create()
	{
        bgroto = new FlxSprite().loadGraphic(Paths.image(path+'bgroto'));
		bgroto.antialiasing = antishit;
        add(bgroto);

        bg = new FlxSprite().loadGraphic(Paths.image(path+'bg'));
		bg.antialiasing = antishit;
        add(bg);

        weas = new FlxSprite().loadGraphic(Paths.image(path+'weas'));
		weas.antialiasing = antishit;
        add(weas);

        trineo2 = new FlxSprite().loadGraphic(Paths.image(path+'trineo2'));
		trineo2.antialiasing = antishit;
        add(trineo2);

		bolsas = new FlxSprite().loadGraphic(Paths.image(path+'bolsasdebasura'));
		bolsas.antialiasing = antishit;
        add(bolsas);

		crick = new Character(450, -900, "crick");
		crick.antialiasing = antishit;
		add(crick);
	}
	
	override function createPost()
	{
        trineo1 = new FlxSprite().loadGraphic(Paths.image(path+'trineo1'));
		trineo1.antialiasing = antishit;
        add(trineo1);

		game.dad.x = -1260;

        updateTrineoPos();
		setTrineoVis(false);

		blackScreen = new FlxSprite().makeGraphic(Std.int(FlxG.width*1.1), Std.int(FlxG.height*1.1), 0xFF000000);
		blackScreen.cameras = [game.camHUD];
		blackScreen.screenCenter();
		add(blackScreen);

		crickIcon = new HealthIcon("crick");
		crickIcon.setPosition(15, -200);
		crickIcon.cameras = [game.camHUD];
	}

	override function update(elapsed:Float)
	{
		crickIcon.scale.x = crickIcon.scale.y = game.iconP1.scale.x;
		crickIcon.updateHitbox();
	}

	override function onSongStart()
	{
		GameOverSubstate.characterName = 'soninavidad';

		game.insert(game.members.indexOf(game.iconP2)+1, crickIcon);
		blackScreen.alpha = 0;
	}

    override function stepHit()
    {
        switch(curStep) {
			case 227:
				tweenArray.push(FlxTween.tween(game.iconP2, {x: 15}, 1.8, {ease: FlxEase.quadOut}));
				tweenArray.push(FlxTween.tween(game.dad, {x: 410}, 1.8, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween) -> {
					updateTrineoPos();
				}}));
            case 229:
                bg.kill();
                game.remove(bg);
                bg.destroy();

				FlxG.camera.flash(0xFFFFFFFF, 2);
				game.camZooming = true;
				FlxG.camera.zoom += 0.15;

				setTrineoVis(true);
			case 864:
				for (i in 0...game.unspawnNotes.length) if (!game.unspawnNotes[i].mustPress) game.unspawnNotes[i].noAnimation = true;
				for (i in 0...game.notes.length) if (!game.notes.members[i].mustPress) game.notes.members[i].noAnimation = true;
			case 879:
				tweenArray.push(FlxTween.tween(crick, {y: 200}, 2.5, {ease: FlxEase.bounceOut}));
				tweenArray.push(FlxTween.tween(crickIcon, {y: game.barraENEMIGO.y+80}, 2.5, {ease: FlxEase.bounceOut}));
			case 888:
				game.dad.velocity.x = 425;
				game.dad.acceleration.y = 770;
				game.dad.velocity.y = -500;
				game.dad.angularVelocity = 50;

				game.iconP2.velocity.x = 425/1.5;
				game.iconP2.acceleration.y = 770/1.5;
				game.iconP2.velocity.y = -500/1.5;
				game.iconP2.angularVelocity = 50/1.5;
			case 896:
				FlxG.camera.flash(0xFFFFFFFF, 2);
        }
    }

	override function beatHit()
	{
		if (curBeat % crick.danceEveryNumBeats == 0 && crick.animation.curAnim != null && !crick.animation.curAnim.name.startsWith('sing') && !crick.stunned)
			crick.dance();
	}
	var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
	override function onOpponentNoteHit(note)
	{
		var animToPlay:String = singAnimations[Std.int(Math.abs(Math.min(singAnimations.length-1, note.noteData)))];

		crick.playAnim(animToPlay, true);
		crick.holdTimer = 0;
	}
	
	override function countdownTick(count, num)
	{

	}

	override function closeSubState()
	{
		if(paused)
		{
			for (i in tweenArray) {
				i.active = true;
			}
			//timer.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			for (i in tweenArray) {
				i.active = false;
			}
			//timer.active = false;
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "My Event":
		}
	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events that doesn't need different assets based on its values
		switch(event.event)
		{
			case "My Event":
				//precacheImage('myImage') //preloads images/myImage.png
				//precacheSound('mySound') //preloads sounds/mySound.ogg
				//precacheMusic('myMusic') //preloads music/myMusic.ogg
		}
	}
	override function eventPushedUnique(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events where its values affect what assets should be preloaded
		switch(event.event)
		{
			case "My Event":

		}
	}

    function updateTrineoPos() {
		trineo1.setPosition(dad.x-310, dad.y+350);
        trineo2.setPosition(trineo1.x+291, trineo1.y+51);
       	bolsas.setPosition(trineo1.x+52, trineo1.y-166);
    }

	function setTrineoVis(vis:Bool = true) {
		game.dad.visible = vis;
		trineo1.visible = vis;
		trineo2.visible = vis;
		bolsas.visible = vis;
	}
}
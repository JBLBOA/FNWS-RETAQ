package states;

import lime.graphics.Image;
import flixel.FlxSubState;
import substates.GallerySubstate;
import flixel.animation.FlxAnimationController;
import flixel.math.FlxPoint;
import backend.WeekData;
import backend.Achievements;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import objects.AchievementPopup;
import states.editors.MasterEditorMenu;
import options.OptionsState;

import flixel.addons.display.FlxBackdrop;
class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.1h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var versionFNWS:String = "rizzmas";
	
	/*var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];*/

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var storymenu:FlxSprite;
	var codes:FlxSprite;
	var archivements:FlxSprite;
	var extras:FlxSprite;
	var freeplay:FlxSprite;
	var galery:FlxSprite;
	var options:FlxSprite;
	var credits:FlxSprite;

	var notyet:FlxSprite;
	var youtube:FlxSprite;
	var twitter:FlxSprite;

	var blackShit:FlxSprite;

	var sonicentro:FlxSprite;
	var sonicharcentro:FlxSprite;

	var objScale:Float = 0.7;
	var title:Bool = false;
	var bg:FlxBackdrop;

	var selectedSomethin:Bool = false;

	public function new(title:Bool = false) {
		this.title = title;
		super();
	}

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxBackdrop(Paths.image('mainmenu/bg'), X);
		bg.velocity.x = 12;
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.setGraphicSize(FlxG.width);
		bg.updateHitbox();
		bg.screenCenter(Y);
		add(bg);

		var soniBG:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/sonigrid'));
		soniBG.velocity.set(-120, -20);
		add(soniBG);

		var cosoas:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/coso'), X);
		cosoas.antialiasing = ClientPrefs.data.antialiasing;
		cosoas.velocity.x = -120;
		cosoas.setGraphicSize(0, FlxG.height+1);
		cosoas.screenCenter(Y);
		add(cosoas);

		camFollow = new FlxObject(FlxG.width/2, FlxG.height/2, 1, 1);
		add(camFollow);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		/*storymenu = new FlxSprite(0, 150);
		storymenu.scale.x = objScale;
		storymenu.scale.y = objScale;
		storymenu.frames = Paths.getSparrowAtlas('mainmenu/menufnws');
		storymenu.animation.addByPrefix('idle', "story_modeSELECTED", 24);
		storymenu.animation.addByPrefix('selected', "story_modeUNSELECTED", 24);
		storymenu.animation.play('idle');
		storymenu.updateHitbox();
		add(storymenu);*/

		notyet = new FlxSprite(10, -70+187).loadGraphic(Paths.image("mainmenu/notyet"));
		notyet.antialiasing = ClientPrefs.data.antialiasing;
		notyet.scale.x = objScale;
		notyet.scale.y = objScale;
		add(notyet);

		freeplay = new FlxSprite(800, 155);
		freeplay.antialiasing = ClientPrefs.data.antialiasing;
		freeplay.scale.x = objScale;
		freeplay.scale.y = objScale;
		freeplay.frames = Paths.getSparrowAtlas('mainmenu/menufnws');
		freeplay.animation.addByPrefix('idle', "freeplayUNSELECTED", 24);
		freeplay.animation.play('idle');
		freeplay.updateHitbox();
		freeplay.ID = 0;
		menuItems.add(freeplay);

		galery = new FlxSprite(freeplay.x + 90, freeplay.y + 130);
		galery.antialiasing = ClientPrefs.data.antialiasing;
		galery.scale.x = objScale;
		galery.scale.y = objScale;
		galery.frames = Paths.getSparrowAtlas('mainmenu/menufnws');
		galery.animation.addByPrefix('idle', "galeryUNSELECTED", 24);
		galery.animation.play('idle');
		galery.updateHitbox();
		galery.ID = 1;
		menuItems.add(galery);

		options = new FlxSprite(freeplay.x + 63, freeplay.y + 245);
		options.antialiasing = ClientPrefs.data.antialiasing;
		options.scale.x = objScale;
		options.scale.y = objScale;
		options.frames = Paths.getSparrowAtlas('mainmenu/menufnws');
		options.animation.addByPrefix('idle', "optionsUNSELECTED", 24);
		options.animation.play('idle');
		options.updateHitbox();
		options.ID = 2;
		menuItems.add(options);

		credits = new FlxSprite(800, 480);
		credits.antialiasing = ClientPrefs.data.antialiasing;
		credits.scale.x = objScale;
		credits.scale.y = objScale;
		credits.frames = Paths.getSparrowAtlas('mainmenu/menufnws');
		credits.animation.addByPrefix('idle', "creditsUNSELECTED", 24);
		credits.animation.play('idle');
		credits.updateHitbox();
		credits.ID = 3;
		menuItems.add(credits);

		youtube = new FlxSprite(1050, 600).loadGraphic(Paths.image("mainmenu/youtube"));
		youtube.antialiasing = ClientPrefs.data.antialiasing;
		youtube.scale.x = objScale + 0.2;
		youtube.scale.y = objScale + 0.2;
		youtube.ID = 4;
		menuItems.add(youtube);
		
		twitter = new FlxSprite(1150, 600).loadGraphic(Paths.image("mainmenu/twitter"));
		twitter.antialiasing = ClientPrefs.data.antialiasing;
		twitter.scale.x = objScale + 0.2;
		twitter.scale.y = objScale + 0.2;
		twitter.ID = 5;
		menuItems.add(twitter);

		blackShit = new FlxSprite().makeGraphic(Std.int(FlxG.width*1.01), Std.int(FlxG.height*1.01), 0xFF000000);
		blackShit.screenCenter();
		blackShit.scrollFactor.set();
		add(blackShit);

		sonicentro = new FlxSprite().loadGraphic(Paths.image('mainmenu/sonicentro'));
		sonicentro.antialiasing = ClientPrefs.data.antialiasing;
		sonicentro.scale.x = objScale;
		sonicentro.scale.y = objScale;
		sonicentro.updateHitbox();
		sonicentro.screenCenter();
		sonicentro.y += 1000;
		add(sonicentro);

		sonicharcentro = new FlxSprite().loadGraphic(Paths.image('mainmenu/soni'));
		sonicharcentro.antialiasing = ClientPrefs.data.antialiasing;
		sonicharcentro.scale.x = objScale;
		sonicharcentro.scale.y = objScale;
		sonicharcentro.updateHitbox();
		sonicharcentro.screenCenter();
		sonicharcentro.y += 635;
		add(sonicharcentro);

		FlxG.camera.follow(camFollow, null, 0);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		//changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();

		FlxG.mouse.visible = true;
		selectedSomethin = (title) ? true : false;

		if (title) {
			FlxG.sound.playMusic(Paths.music('freakyMenuPEROGOD'), 1);
			FlxAnimationController.globalSpeed = 0;
			FlxG.sound.music.pitch = 0;

			FlxTween.tween(FlxG.sound.music, {pitch: 1}, 2.2, {ease: FlxEase.quadOut});
			FlxTween.tween(FlxAnimationController, {globalSpeed: 1}, 2.2, {ease: FlxEase.quadOut});

			FlxTween.tween(sonicentro, {y: sonicentro.y-(1000+10)}, 1.9, {ease: FlxEase.backOut});
			FlxTween.tween(sonicharcentro, {y: sonicharcentro.y-(635+10)}, 1.9, {ease: FlxEase.backOut, onComplete: (twn:FlxTween) -> {
				FlxG.camera.flash(0xFFFFFFFF, 2);
				blackShit.visible = false;
				selectedSomethin = false;

				Application.current.window.setIcon(Image.fromFile('assets/images/icon64.png'));
			}});
			var initText:String = "Freaky Night With Soni: Retaq' (RIZZMAS UPDATE)";
			FlxTween.num(initText.length, 0, 2, {ease: FlxEase.quadOut}, (num:Float) -> {
				Application.current.window.title = initText.substring(Std.int(num), initText.length);
			});
		} else {
			sonicentro.y -= (1000+10);
			sonicharcentro.y -= (635+10);
			blackShit.visible = false;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementPopup('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end
	var iTime:Float = 0;
	var sonitocado:Bool = false;

	var colorTween:FlxTween;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (!sonitocado) {
			sonicharcentro.angle = Math.sin(iTime*Math.PI)*4;
			iTime += elapsed;
		}

		if (!selectedSomethin)
		{
			menuItems.forEach((s:FlxSprite) -> {
				if (Overlap.overlapMouse(s)) {
					curSelected = s.ID;
					if (FlxG.mouse.justPressed) {
						if (curSelected != 1 && curSelected != 4 && curSelected != 5) {
							selectedSomethin = true;
							FlxG.sound.play(Paths.sound('confirmMenu'));
							FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.05, false);
				
							new FlxTimer().start(0.5, function(tmr:FlxTimer)
							{
								switch(curSelected) {
									case 0:
										MusicBeatState.switchState(new FreeplayState());
									case 2:
										MusicBeatState.switchState(new OptionsState());
									case 3:
										MusicBeatState.switchState(new CreditsState());
								}
							});
						} else {
							switch(curSelected) {
								case 1:
									openSubState(new GallerySubstate());
									persistentUpdate = false;
								case 4:
									CoolUtil.browserLoad('https://www.youtube.com/@CHORIZINGAMING');
								case 5:
									CoolUtil.browserLoad('https://twitter.com/FNWSretaq');
							}
						}
					}
				}

				if (s.ID == curSelected && Overlap.overlapMouse(s))
					s.scale.x = s.scale.y = FlxMath.lerp(s.scale.x, objScale+0.05, FlxMath.bound(elapsed*20, 0, 1));
				else
					s.scale.x = s.scale.y = FlxMath.lerp(s.scale.x, objScale, FlxMath.bound(elapsed*20, 0, 1));
			});

			if (!selectedSomethin) {
				var wea:Bool = true;
				if (Overlap.overlapMouse(sonicharcentro) && FlxG.mouse.justPressed) {
					clickSoni();
					wea = false;
				}

				if (wea && Overlap.overlapMouse(notyet) && FlxG.mouse.justPressed) {
					bg.color = 0xFFFF0000;
					if (colorTween != null) colorTween.cancel();
					colorTween = FlxTween.color(bg, 0.85, 0xFFFF0000, 0xFFFFFFFF, {ease: FlxEase.quadOut});
					FlxG.camera.shake(0.01, 0.5);
					FlxG.sound.play(Paths.sound('cancel'), 0.8);
				}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
			#if (desktop && debug)
			else if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		/*menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});*/
	}

	/*function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}*/

	var clicksonitweens:Array<FlxTween> = [];
	var clicksonitimers:Array<FlxTimer> = [];
	function clickSoni() {
		var random:Bool = FlxG.random.bool(5);
		sonitocado = true;
		for (i in clicksonitweens)
			if (i!=null) i.cancel();
		for (i in clicksonitimers)
			if (i!=null) i.cancel();
		if (!random) {
			sonicharcentro.loadGraphic(Paths.image('mainmenu/sonihappy'));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		} else {
			sonicharcentro.loadGraphic(Paths.image('mainmenu/sonipez'));
			FlxG.sound.play(Paths.sound('bwop'));
		}
		sonicharcentro.angle = FlxG.random.float(-13, 13);
		sonicharcentro.scale.x = sonicharcentro.scale.y = objScale+0.1;
		clicksonitweens.push(FlxTween.tween(sonicharcentro.scale, {x: objScale, y: objScale}, 0.5, {ease: !random ? FlxEase.backOut : FlxEase.elasticOut, onComplete: (twn:FlxTween) -> {
			clicksonitimers.push(new FlxTimer().start(0.35, (tmr:FlxTimer) -> {
				sonicharcentro.loadGraphic(Paths.image('mainmenu/soni'));
				sonitocado = false;
			}));
		}}));
		clicksonitweens.push(FlxTween.tween(sonicharcentro, {angle: Math.sin(iTime*Math.PI)*4}, 1.1, {ease: !random ? FlxEase.backOut : FlxEase.elasticOut}));
	}

	override function closeSubState() {
		super.closeSubState();
		if (!persistentUpdate) persistentUpdate = true;
	}
}

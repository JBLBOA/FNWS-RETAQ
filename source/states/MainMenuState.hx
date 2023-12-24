package states;

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

import substates.Galeria;

import flixel.addons.display.FlxBackdrop;
class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.1h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var versionFNWS:String = "rizzmas";
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

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

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/newmenu/bg'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		var soniBG:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/newmenu/sonigrid'));
		soniBG.scrollFactor.set();
		soniBG.velocity.set(-10, -20);
		soniBG.velocity.x = -120;
		add(soniBG);

		var scale:Float = 0.7;

		var sonicentro:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/newmenu/sonicentro'));
		sonicentro.antialiasing = ClientPrefs.data.antialiasing;
		sonicentro.scrollFactor.set(0, 0);
		sonicentro.scale.x = scale;
		sonicentro.scale.y = scale;
		sonicentro.updateHitbox();
		sonicentro.screenCenter();
		add(sonicentro);

		storymenu = new FlxSprite(0, 150);
		storymenu.scrollFactor.set(0, 0);
		storymenu.scale.x = scale;
		storymenu.scale.y = scale;
		storymenu.frames = Paths.getSparrowAtlas('mainmenu/newmenu/menufnws');
		storymenu.animation.addByPrefix('idle', "story_modeSELECTED", 24);
		storymenu.animation.addByPrefix('selected', "story_modeUNSELECTED", 24);
		storymenu.animation.play('idle');
		storymenu.updateHitbox();
		//add(storymenu);

		notyet = new FlxSprite(-150, -70).loadGraphic(Paths.image("mainmenu/newmenu/notyet"));
		notyet.scrollFactor.set(0, 0);
		notyet.scale.x = scale;
		notyet.scale.y = scale;
		add(notyet);

		freeplay = new FlxSprite(800, 155);
		freeplay.scrollFactor.set(0, 0);
		freeplay.scale.x = scale;
		freeplay.scale.y = scale;
		freeplay.frames = Paths.getSparrowAtlas('mainmenu/newmenu/menufnws');
		freeplay.animation.addByPrefix('idle', "freeplayUNSELECTED", 24);
		freeplay.animation.play('idle');
		freeplay.updateHitbox();
		add(freeplay);

		galery = new FlxSprite(freeplay.x + 90, freeplay.y + 130);
		galery.scrollFactor.set(0, 0);
		galery.scale.x = scale;
		galery.scale.y = scale;
		galery.frames = Paths.getSparrowAtlas('mainmenu/newmenu/menufnws');
		galery.animation.addByPrefix('idle', "galeryUNSELECTED", 24);
		galery.animation.play('idle');
		galery.updateHitbox();
		add(galery);

		options = new FlxSprite(freeplay.x + 63, freeplay.y + 245);
		options.scrollFactor.set(0, 0);
		options.scale.x = scale;
		options.scale.y = scale;
		options.frames = Paths.getSparrowAtlas('mainmenu/newmenu/menufnws');
		options.animation.addByPrefix('idle', "optionsUNSELECTED", 24);
		options.animation.play('idle');
		options.updateHitbox();
		add(options);

		credits = new FlxSprite(800, 480);
		credits.scrollFactor.set(0, 0);
		credits.scale.x = scale;
		credits.scale.y = scale;
		credits.frames = Paths.getSparrowAtlas('mainmenu/newmenu/menufnws');
		credits.animation.addByPrefix('idle', "creditsUNSELECTED", 24);
		credits.animation.play('idle');
		credits.updateHitbox();
		add(credits);

		var cosoas:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/newmenu/coso'));
		cosoas.scrollFactor.set();
		cosoas.velocity.set(-10, 0);
		cosoas.velocity.x = -120;
		cosoas.setGraphicSize(Std.int(cosoas.width), Std.int(cosoas.height - 250));
		add(cosoas);
		
		youtube = new FlxSprite(1050, 600).loadGraphic(Paths.image("mainmenu/newmenu/youtube"));
		youtube.scrollFactor.set(0, 0);
		youtube.scale.x = scale + 0.2;
		youtube.scale.y = scale + 0.2;
		add(youtube);
		
		twitter = new FlxSprite(1150, 600).loadGraphic(Paths.image("mainmenu/newmenu/twitter"));
		twitter.scrollFactor.set(0, 0);
		twitter.scale.x = scale + 0.2;
		twitter.scale.y = scale + 0.2;
		add(twitter);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			//menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

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

		changeItem();

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
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementPopup('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		FlxG.mouse.visible = true;

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		var selecionado:Bool = false;

		if (!selecionado)
			{
				if (FlxG.mouse.overlaps(youtube) && FlxG.mouse.justPressed)
					{
						CoolUtil.browserLoad('https://www.youtube.com/@CHORIZINGAMING');
					}

				if (FlxG.mouse.overlaps(twitter) && FlxG.mouse.justPressed)
					{
						CoolUtil.browserLoad('https://twitter.com/FNWSretaq');
					}

				if (FlxG.mouse.overlaps(freeplay))
					{
						//FlxG.sound.play(Paths.sound('scrollMenu'), 1, false, null, true);
						if (FlxG.mouse.justPressed)
							{
								selecionado = true;

								FlxG.sound.play(Paths.sound('confirmMenu'));
		
								FlxFlicker.flicker(freeplay, 1, 0.05, false);
				
								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										MusicBeatState.switchState(new FreeplayState());
									});
							}
					}	

				if (FlxG.mouse.overlaps(galery))
					{
						//FlxG.sound.play(Paths.sound('scrollMenu'), 1, false, null, true);
						if (FlxG.mouse.justPressed)
							{
								selecionado = true;
								
								FlxG.sound.play(Paths.sound('confirmMenu'));
		
								FlxFlicker.flicker(galery, 1, 0.05, false);
				
								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										openSubState(new Galeria());
									});
							}
					}

				if (FlxG.mouse.overlaps(options))
					{
						//FlxG.sound.play(Paths.sound('scrollMenu'), 1, false, null, true);
						if (FlxG.mouse.justPressed)
							{
								selecionado = true;
								
								FlxG.sound.play(Paths.sound('confirmMenu'));
			
								FlxFlicker.flicker(options, 1, 0.05, false);
					
								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										MusicBeatState.switchState(new OptionsState());
									});
							}
					}


				if (FlxG.mouse.overlaps(credits))
					{
						//FlxG.sound.play(Paths.sound('scrollMenu'), 1, false, null, true);
						if (FlxG.mouse.justPressed)
							{
								selecionado = true;
								
								FlxG.sound.play(Paths.sound('confirmMenu'));
				
								FlxFlicker.flicker(credits, 1, 0.05, false);
					
								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										MusicBeatState.switchState(new CreditsState());
									});
							}
					}
			}

		if (!selectedSomethin)
		{
			/*if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}*/

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}/*

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.data.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new OptionsState());
										OptionsState.onPlayState = false;
										if (PlayState.SONG != null)
										{
											PlayState.SONG.arrowSkin = null;
											PlayState.SONG.splashSkin = null;
										}
								}
							});
						}
					});
				}
			}*/
			#if desktop
			else if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
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
	}
}

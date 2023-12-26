package substates;

import flixel.util.FlxSort;

class GallerySubstate extends MusicBeatSubstate
{
    var bg:FlxSprite;

    var weas:Array<Array<String>> = [['25_sin_titulo_20231215094914', 'FNWS RETAQ OST ART'], ['28_sin_titulo_20231217162329', 'soni malo'], ['c', ''], ['39_sin_titulo_20231225115110', ''], ['39_sin_titulo_20231225194119', ''], ['28_sin_titulo_20231217161932', ''], ['103_sin_titulo_20231226004100', 'soni navidad art (by: azcortinitas)'], ['image (33)', 'como estan soniers'], ['image-20', 'yo soy jp'], ['como_hacer_mods_kevin', 'no hay contexto. ni yo se.'], ['sonifumeta', 'soni smoking'], ['64dacec846e18', 'PEAK MOD'], ['imagen_2023-12-25_205009750', 'PERO SI ES GIAN'], ['wa', 'waluigi'], ['image-10', 'no se que es esto'], ['3d-honey-bee-santa-claus', 'beepro'], ['smurfsoni', 'SMURF SONI MEME MUERTO'], ['locorene', 'LOCO RENE'], ['39_sin_titulo_20231225193916', 'WHAT']];
    var images:FlxTypedGroup<FlxSprite>;

    var weaBlack:FlxSprite;
    var wea:FlxText;

    var curSelected:Int = 0;

    public function new()
    {
        super();

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        bg.scrollFactor.set();
        add(bg);

        FlxTween.tween(bg, {alpha: 0.5}, 1, {ease: FlxEase.circOut});

        images = new FlxTypedGroup<FlxSprite>();
        add(images);

        var shit:Int = 0;
        for (i in weas) {
            var image:FlxSprite = new FlxSprite(shit*FlxG.width).loadGraphic(Paths.image('galeria/${i[0]}', 'shared'));
            if (image.width > FlxG.width*0.75) image.setGraphicSize(Std.int(FlxG.width*0.75));
            if (image.height > FlxG.height*0.8) image.setGraphicSize(0, Std.int(FlxG.height*0.8));
            image.screenCenter(Y);
            image.ID = shit;
            images.add(image);

            shit++;
        }

        weaBlack = new FlxSprite().makeGraphic(FlxG.width+2, Std.int(FlxG.height*0.25), 0xFF000000);
        weaBlack.screenCenter(X);
        add(weaBlack);

        wea = new FlxText(0, 0, FlxG.width, '', 38);
        wea.setFormat(Paths.font('vcr.ttf'), 38, 0xFFFFFFFF, CENTER);
        add(wea);

        changeSelection();
    }

    override function update(elapsed:Float) {
        images.forEach((spr:FlxSprite) -> {
            spr.x = FlxMath.lerp(spr.x, ((FlxG.width-spr.width)/2)-((curSelected-spr.ID)*FlxG.width), FlxMath.bound(elapsed*8.2, 0, 1));
        });

        if (controls.UI_LEFT_P) {
            changeSelection(-1);
        }
        if (controls.UI_RIGHT_P) {
            changeSelection(1);
        }

        if (controls.BACK) {
            close();
        }
        
        super.update(elapsed);
    }

    function changeSelection(huh:Int = 0) {
        curSelected = FlxMath.wrap(curSelected+huh, 0, images.length-1);

        wea.text = weas[curSelected][1];
        wea.y = FlxG.height-wea.height-3;
        weaBlack.y = FlxG.height-wea.height-3;
    }
}
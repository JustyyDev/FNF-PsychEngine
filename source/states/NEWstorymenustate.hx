package states;

import flixel.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;

class NEWstorymenustate extends MusicBeatState
{
    var BG:FlxSprite;
    var SongText:FlxSprite;
    var char:FlxSprite;
    var WeekBox:FlxSprite;
    var Outline1:FlxSprite;
    var Outline2:FlxSprite;

    var menuItems:FlxTypedGroup<FlxSprite>;

    override function create()
        {
            BG = new FlxSprite(0,0).loadGraphic(Paths.image("storymenu/storymodebg"));
            BG.antialiasing = FlxG.save.data.antialiasing;
            add(BG);
            super.create();

            switch (FlxG.random.int(1, 2))
            {
            case 1:
			char = new FlxSprite(820, 170).loadGraphic(Paths.image('storymenu/sexto'));
			char.scrollFactor.set();
			char.flipX = false;
			add(char);

            case 2:
			char = new FlxSprite(820, 170).loadGraphic(Paths.image('storymenu/BOYFRIEND'));
			char.frames = Paths.getSparrowAtlas('storymenu/BOYFRIEND');
			char.animation.addByPrefix('idleB', 'BF idle dance', 24, true);
			char.animation.play('idleB');
			char.scrollFactor.set();
			add(char);
		}
    }

    override function update(elapsed:Float)
        {
            if (controls.BACK)
                MusicBeatState.switchstate(new MainMenuState());

        super.update(elapsed);
        }
}
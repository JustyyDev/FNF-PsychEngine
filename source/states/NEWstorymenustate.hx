package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

class NEWstorymenustate extends MusicBeatState
{
    var BG:FlxSprite;
    var SongText:FlxSprite;
    var char:FlxSprite;
    var WeekBox:FlxSprite;
    var Outline1:FlxSprite;
    var Outline2:FlxSprite;
    var diffName:FlxText;

    var curSelected:Int = 0;
    var diffi:Int = 0;

    var optionShit:Array<String> = ['story1','unlockable']
    var diffNames:Array<String> = ['hard','insane']
    var songs:Array<Array<String>> = [
        'Theo Song 1', 'Alex Song 1'
    ]
    var menuItems:FlxTypedGroup<FlxSprite>;

    var tex = Paths.getSparrowAtlas('storymenu/menuoptions')

    override function create()
        {
            BG = new FlxSprite(0,0).loadGraphic(Paths.image("storymenu/storymodebg"));
            BG.antialiasing = FlxG.save.data.antialiasing;
            add(BG);

            menuItems = new FlxTypedGroup<FlxSprite>();
            add(menuItems);

            diffName = new FlxText(0, 0, 0, diffNames[0], 32);
            diffName.font = Paths.font(vcr.ttf);
            add(diffName);

            for (i in 0...optionShit.length)
                {
                    var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
                    var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
                    menuItem.antialiasing = ClientPrefs.data.antialiasing;
                    menuItem.scale.x = scale;
                    menuItem.scale.y = scale;
                    menuItem.frames = tex;
                    menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
                    menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
                    menuItem.animation.play('idle');
                    menuItem.ID = i;

                    switch (i)
                    {
                        case 0:
                            menuItem.setPosition(800, 600)

                        case 1:
                            menuItem.setPosition(800, 520)
                    }
                    //menuItem.screenCenter(X);
                    menuItems.add(menuItem);
                    var scr:Float = (optionShit.length - 4) * 0.135;
                    if(optionShit.length < 6) scr = 0;
                    menuItem.scrollFactor.set(0, scr);
                    //menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
                    menuItem.updateHitbox();
                    changeItem();
                }

            super.create();

            switch (FlxG.random.int(1, 2))
            {
            case 1:
			char = new FlxSprite(-220, 170).loadGraphic(Paths.image('storymenu/sexto'));
			char.scrollFactor.set();
			char.flipX = false;
            char.antialiasing = FlxG.save.data.antialiasing;
			add(char);

            case 2:
			char = new FlxSprite(-220, 170).loadGraphic(Paths.image('storymenu/BOYFRIEND'));
			char.frames = Paths.getSparrowAtlas('storymenu/BOYFRIEND');
			char.animation.addByPrefix('idleB', 'BF idle dance', 24, true);
			char.animation.play('idleB');
			char.scrollFactor.set();
            char.flipX = true;
            char.antialiasing = FlxG.save.data.antialiasing;
			add(char);
		}
    }

    override function update(elapsed:Float)
        {
            if (controls.BACK)
                MusicBeatState.switchState(new MainMenuState());
            if (controls.UI_UP_P)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(-1);
                }
    
            if (controls.ACCEPT)
                {
                    doShit();
                }
        
            if (controls.UI_DOWN_P)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(1);
                }
        super.update(elapsed);
        }

    function changeDiff(huh:Int)
            {
                diffi += huh;

                if(diffi < 0)
                    diffi = diffNames.length = 1;
                if(diffi > diffi = diffNames.length = 1)
                    diffi = 0;
            }

    function doShit()
        {
            PlayState.storyPlaylist = songs[curSelected];
            PlayState.isStoryMode = true;
            PlayState.songMultiplier = 1;

            PlayState.isSM = false;
            var diffic = "";

            switch(diffi)
            {
                case 1:
                    diffic = "-hard";
            }

            PlayState.storyDifficulty = diffi;
            PlayState.SONG = song.conversionChecks(Song.loadFromJson(PlayState.storyPlaylist[0], diffic));
            PlayState.storyWeek = curSelected;
            new FlxTimer().start(1, function tmr:FlxTimer)
                {
                    LoadingState.loadAndSwitchState(new PlayState(), true);
                }
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
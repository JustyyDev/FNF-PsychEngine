package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import tjson.TJSON as Json;
import states.PlayState;
import backend.Song;

class NEWstorymenustate extends MusicBeatState
{
    var BG:FlxSprite;
    var spikes:FlxSprite;
    var arrows1:FlxSprite;
    var songnamer:FlxSprite;
    var SongText:FlxSprite;
    var char:FlxSprite;
    var WeekBox:FlxSprite;
    var Outline1:FlxSprite;
    var Outline2:FlxSprite;
    var diffName:FlxText;

    var curSelected:Int = 0;
    var diffi:Int = 0;

    var optionShit:Array<String> = ['story1','unlockable'];
    var diffNames:Array<String> = ['normal','hard'];
    var songArray:Array<String> = [
        'theo', 'alex'
    ];
    var menuItems:FlxTypedGroup<FlxSprite>;

    var scale:Float = 0.25;
    /*if(optionShit.length > 6) {
        scale = 6 / optionShit.length;
    }*/


    override function create()
        {
            BG = new FlxSprite(0,0).loadGraphic(Paths.image("storymenu/storymodebg"));
            BG.antialiasing = FlxG.save.data.antialiasing;
            add(BG);

            spikes = new FlxSprite(500,350).loadGraphic(Paths.image("storymenu/menu_spikes"));
            spikes.antialiasing = FlxG.save.data.antialiasing;
            //add(spikes);

            arrows1 = new FlxSprite(450,-500).loadGraphic(Paths.image("storymenu/menu_arrows1"));
            arrows1.antialiasing = FlxG.save.data.antialiasing;
            arrows1.scale.x = scale;
			arrows1.scale.y = scale;
            //add(arrows1);

            songnamer = new FlxSprite(-10,-850).loadGraphic(Paths.image("storymenu/menu_songnamelonger"));
            songnamer.antialiasing = FlxG.save.data.antialiasing;
            songnamer.scale.x = 0.15;
			songnamer.scale.y = 0.15;
            //add(songnamer);

            var purpleBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.PURPLE);
            add(purpleBarThingie);

            menuItems = new FlxTypedGroup<FlxSprite>();
            add(menuItems);

            diffName = new FlxText(470, -500, 0, diffNames[0], 32);
            add(diffName);

            for (i in 0...optionShit.length)
                {
                    var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
                    var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
                    menuItem.antialiasing = ClientPrefs.data.antialiasing;
                    menuItem.frames = Paths.getSparrowAtlas('storymenu/story_' + optionShit[i]);
                    menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
                    menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
                    menuItem.animation.play('idle');
                    menuItem.scale.x = scale;
                    menuItem.scale.y = scale;
                    menuItem.ID = i;

                    switch (i)
                    {
                        case 0:
                            menuItem.setPosition(800, 780);

                        case 1:
                            menuItem.setPosition(800, 700);
                    };
                    //menuItem.screenCenter(X);
                    menuItems.add(menuItem);
                    var scr:Float = (optionShit.length - 4) * 0.135;
                    if(optionShit.length < 6) scr = 0;
                    menuItem.scrollFactor.set(0, scr);
                    //menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
                    menuItem.updateHitbox();
                    changeItem();
                    changeDiff();
                }

                
            switch (FlxG.random.int(1, 2))
            {
            case 1:
			char = new FlxSprite(0, 170).loadGraphic(Paths.image('storymenu/sexto'));
			char.scrollFactor.set();
			char.flipX = false;
            char.antialiasing = FlxG.save.data.antialiasing;
			add(char);

            case 2:
			char = new FlxSprite(0, 170).loadGraphic(Paths.image('storymenu/BOYFRIEND'));
			char.frames = Paths.getSparrowAtlas('storymenu/BOYFRIEND');
			char.animation.addByPrefix('idleB', 'BF idle dance', 24, true);
			char.animation.play('idleB');
			char.scrollFactor.set();
            char.flipX = true;
            char.antialiasing = FlxG.save.data.antialiasing;
			add(char);
		};
            super.create();
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
    
            if (controls.ACCEPT && optionShit[curSelected] != 'unlockable')
                {
                    doShit();
                }
        
            if (controls.UI_DOWN_P)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeItem(1);
                }

            if (controls.UI_RIGHT_P)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeDiff(1);
                }
            if (controls.UI_LEFT_P)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    changeDiff(-1);
                }
        super.update(elapsed);
        }

    function changeDiff(huh:Int = 0)
            {
                diffi += huh;

                if(diffi < 0)
                    diffi = 1;
                if(diffi > 1)
                    diffi = 0;
            }

    function doShit()
        {
            PlayState.storyPlaylist = songArray;
            PlayState.isStoryMode = true;

            var diffic = "";
            switch(diffi)
            {
                case 1:
                    diffic = "-hard";
            }
            PlayState.storyDifficulty = diffi;
            PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], diffic);
            PlayState.storyWeek = curSelected;
			new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    LoadingState.loadAndSwitchState(new PlayState(), true);
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
                        spr.centerOffsets();
                    }
                });
            }
}
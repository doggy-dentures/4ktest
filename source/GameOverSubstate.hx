package;

import flixel.util.FlxDestroyUtil;
import openfl.events.KeyboardEvent;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	var playstate:PlayState;

	var tmr:FlxTimer;

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		playstate = cast(FlxG.state, PlayState);
		var daStage = PlayState.curStage;
		var daBf:String = 'bf-dead';

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(camX, camY, 1, 1);
		add(camFollow);
		FlxTween.tween(camFollow, {x: bf.getGraphicMidpoint().x, y: bf.getGraphicMidpoint().y}, 3, {ease: FlxEase.quintOut, startDelay: 0.5});

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		tmr = new FlxTimer().start(3, function(_)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
			bf.playAnim('deathLoop', true);
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.camera.follow(camFollow, LOCKON);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, playstate.keyDown);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, playstate.keyUp);

			if (PlayState.isStoryMode)
				playstate.switchState(new StoryMenuState());
			else
				playstate.switchState(new FreeplayState());
		}

		// if (bf.getCurAnim() == 'firstDeath' && bf.getCurAnimFinished())
		// {

		// }

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			// FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, playstate.keyDown);
			// FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, playstate.keyUp);
			tmr.cancel();
			tmr = FlxDestroyUtil.destroy(tmr);
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1.2, false, function()
				{
					playstate.switchState(new PlayState());
				});
			});
		}
	}

	override function destroy()
	{
		playstate = null;

		super.destroy();
	}
}

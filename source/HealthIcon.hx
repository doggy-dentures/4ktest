package;

import sys.FileSystem;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var defualtIconScale:Float = 1.0;
	public var iconScale:Float = 1.0;
	public var iconSize:Float = 450;

	var char:String;

	public var status:String = "normal";

	private var tween:FlxTween;

	private static final pixelIcons:Array<String> = ["bf-pixel", "senpai", "senpai-angry", "spirit"];

	public function new(char:String = 'face', isPlayer:Bool = false, ?_id:Int = -1)
	{
		super();
		flipX = isPlayer;

		changeChar(char);

		normal();

		antialiasing = !pixelIcons.contains(char);
		scrollFactor.set();

		tween = FlxTween.tween(this, {}, 0);
	}

	public function changeChar(char:String)
	{
		this.char = char;
	}

	public function normal()
	{
		loadGraphic(Paths.image("healthicons/" + char + "/normal"));
		status = "normal";
	}

	public function win()
	{
		loadGraphic(Paths.image("healthicons/" + char + "/win"));
		status = "win";
	}

	public function lose()
	{
		loadGraphic(Paths.image("healthicons/" + char + "/lose"));
		status = "lose";
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		setGraphicSize(Std.int(iconSize * iconScale));
		updateHitbox();
	}

	public function tweenToDefaultScale(_time:Float, _ease:Null<flixel.tweens.EaseFunction>)
	{
		tween.cancel();
		tween = FlxTween.tween(this, {iconScale: this.defualtIconScale}, _time, {ease: _ease});
	}

	override public function destroy()
	{
		tween = FlxDestroyUtil.destroy(tween);
		super.destroy();
	}
}

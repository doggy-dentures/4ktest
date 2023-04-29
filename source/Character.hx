package;

import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
import flixel.addons.display.FlxNestedSprite;
import flixel.util.FlxDestroyUtil;
import haxe.macro.Type.AnonStatus;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.display.BitmapData;
import flixel.FlxG;
import openfl.display3D.Context3DTextureFormat;
import openfl.Assets;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxNestedSkewSprite
{
	public var animOffsets:Map<String, Array<Float>> = new Map<String, Array<Float>>();
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var canAutoAnim:Bool = true;
	public var canAutoIdle:Bool = true;

	public var initFacing:Int = FlxObject.RIGHT;

	public var initWidth:Float = -1;
	public var initFrameWidth:Int = -1;
	public var initHeight:Float;

	public var camOffsets:Array<Float> = [0, 0];
	public var posOffsets:Array<Float> = [0, 0];

	// Atlas
	var animRedirect:Map<String, String> = [];

	public var atlasContainer:AtlasThing;
	public var atlasActive:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;

		// var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				createAtlas();

				setAtlasAnim('cheer', 'GF CheerF');
				setAtlasAnim('singLEFT', 'GF left noteF');
				setAtlasAnim('singRIGHT', 'GF Right NoteF');
				setAtlasAnim('singUP', 'GF Up NoteF');
				setAtlasAnim('singDOWN', 'GF Down NoteF');
				setAtlasAnim('sad', 'gf sadF');
				setAtlasAnim('danceLeft', 'GF Dancing Beat LEFTF');
				setAtlasAnim('danceRight', 'GF Dancing Beat RIGHTF');
				setAtlasAnim('scared', 'GF FEARF', true);

				loadAtlas(Paths.getImageFunk("characters/gf/spritemap"), Paths.json("characters/gf/spritemap", "images"),
					Paths.json("characters/gf/Animation", "images"));

				var yOffet = 0;

				addOffset('cheer', -200, -449);
				addOffset('sad', -2, -18 + yOffet);
				addOffset('danceLeft', 0, -4 + yOffet);
				addOffset('danceRight', 0, 0 + yOffet);
				addOffset("singUP", 0, -11 + yOffet);
				addOffset("singRIGHT", 0, -5 + yOffet);
				addOffset("singLEFT", 0, -3 + yOffet);
				addOffset("singDOWN", 0, -31 + yOffet);
				addOffset('scared', -2, -17 + yOffet);

				scale.set(3, 3);
				updateHitbox();

				playAnim('danceRight');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				createAtlas();
				setAtlasAnim('idle', 'Dad idle danceF');
				setAtlasAnim('singUP', 'Dad Sing Note UPF');
				setAtlasAnim('singRIGHT', 'Dad Sing Note RIGHTF');
				setAtlasAnim('singDOWN', 'Dad Sing Note DOWNF');
				setAtlasAnim('singLEFT', 'Dad Sing Note LEFTF');
				setAtlasAnim('singUPmiss', 'Dad Sing Note UPmissF');
				setAtlasAnim('singRIGHTmiss', 'Dad Sing Note RIGHTmissF');
				setAtlasAnim('singDOWNmiss', 'Dad Sing Note DOWNmissF');
				setAtlasAnim('singLEFTmiss', 'Dad Sing Note LEFTmissF');
				loadAtlas(Paths.getImageFunk("characters/dad/spritemap"), Paths.json("characters/dad/spritemap", "images"),
					Paths.json("characters/dad/Animation", "images"));

				addOffset('idle');
				addOffset("singUP", -1, 61);
				addOffset("singRIGHT", -4, 26);
				addOffset("singLEFT", 38, 7);
				addOffset("singDOWN", 2, -8);
				addOffset("singUPmiss", -1, 61);
				addOffset("singRIGHTmiss", -4, 26);
				addOffset("singLEFTmiss", 38, 7);
				addOffset("singDOWNmiss", 2, -8);

				scale.set(3, 3);
				updateHitbox();

				playAnim('idle');

			case 'bf':
				createAtlas();

				setAtlasAnim('idle', 'BF idle danceF');
				setAtlasAnim('singUP', 'BF NOTE UPF');
				setAtlasAnim('singLEFT', 'BF NOTE LEFTF');
				setAtlasAnim('singRIGHT', 'BF NOTE RIGHTF');
				setAtlasAnim('singDOWN', 'BF NOTE DOWNF');
				setAtlasAnim('singUPmiss', 'BF NOTE UP MISSF');
				setAtlasAnim('singLEFTmiss', 'BF NOTE LEFT MISSF');
				setAtlasAnim('singRIGHTmiss', 'BF NOTE RIGHT MISSF');
				setAtlasAnim('singDOWNmiss', 'BF NOTE DOWN MISSF');
				setAtlasAnim('hey', 'BF HEY!!F');
				// setAtlasAnim('attack', 'boyfriend attack');
				setAtlasAnim('hit', 'BF hit copyF');
				setAtlasAnim('dodge', 'boyfriend dodgeF');
				setAtlasAnim('scared', 'BF idle shakingF', true);

				loadAtlas(Paths.getImageFunk("characters/bf/spritemap"), Paths.json("characters/bf/spritemap", "images"),
					Paths.json("characters/bf/Animation", "images"));

				addOffset('idle', -5);
				addOffset("singUP", -21, 66);
				addOffset("singRIGHT", -51, 9);
				addOffset("singLEFT", -7, 3);
				addOffset("singDOWN", -26, -41);
				addOffset("singUPmiss", -21, 65);
				addOffset("singRIGHTmiss", -42, 18);
				addOffset("singLEFTmiss", -9, 14);
				addOffset("singDOWNmiss", -32, -22);
				addOffset("hey", -8, 8);
				addOffset('scared', -17, -5);
				addOffset('dodge', -1, -12);
				addOffset('hit', 17, 41);

				scale.set(3, 3);
				updateHitbox();

				playAnim('idle');

				initFacing = FlxObject.LEFT;

			case 'bf-dead':
				createAtlas();

				setAtlasAnim('firstDeath', 'BF dies2');
				setAtlasAnim('deathLoop', 'BF Dead Loop2', true);
				setAtlasAnim('deathConfirm', 'BF Dead confirm2');

				loadAtlas(Paths.getImageFunk("characters/bf-dead/spritemap"), Paths.json("characters/bf-dead/spritemap", "images"),
					Paths.json("characters/bf-dead/Animation", "images"));

				addOffset('firstDeath', 0, 6);
				addOffset("deathLoop", 0, 0);
				addOffset("deathConfirm", 0, 34);

				scale.set(3, 3);
				updateHitbox();

				playAnim('firstDeath');

				initFacing = FlxObject.LEFT;

			case 'nothing':
				antialiasing = false;
				loadGraphic(FlxGraphic.fromRectangle(1, 1, FlxColor.TRANSPARENT));
		}

		initWidth = width;
		initFrameWidth = frameWidth;
		initHeight = height;
		setFacingFlip((initFacing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT), true, false);
		// if (atlasContainer != null)
		// 	atlasContainer.setFacingFlip((initFacing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT), true, false);

		dance();

		facing = (isPlayer ? FlxObject.LEFT : FlxObject.RIGHT);

		if (atlasActive)
		{
			if (facing != initFacing)
			{
				if (atlasContainer.animList.contains(animRedirect['singRIGHT']))
				{
					var oldOffset = animOffsets['singRIGHT'];
					animOffsets['singRIGHT'] = animOffsets['singLEFT'];
					animOffsets['singLEFT'] = oldOffset;
					var oldRIGHT = animRedirect['singRIGHT'];
					animRedirect['singRIGHT'] = animRedirect['singLEFT'];
					animRedirect['singLEFT'] = oldRIGHT;
				}

				// IF THEY HAVE MISS ANIMATIONS??
				if (atlasContainer.animList.contains(animRedirect['singRIGHTmiss']))
				{
					var oldOffset = animOffsets['singRIGHTmiss'];
					animOffsets['singRIGHTmiss'] = animOffsets['singLEFTmiss'];
					animOffsets['singLEFTmiss'] = oldOffset;
					var oldRIGHT = animRedirect['singRIGHTmiss'];
					animRedirect['singRIGHTmiss'] = animRedirect['singLEFTmiss'];
					animRedirect['singLEFTmiss'] = oldRIGHT;
				}

				if (atlasContainer.animList.contains(animRedirect['singRIGHT-alt']))
				{
					var oldOffset = animOffsets['singRIGHT-alt'];
					animOffsets['singRIGHT-alt'] = animOffsets['singLEFT-alt'];
					animOffsets['singLEFT-alt'] = oldOffset;
					var oldRIGHT = animRedirect['singRIGHT-alt'];
					animRedirect['singRIGHT-alt'] = animRedirect['singLEFT-alt'];
					animRedirect['singLEFT-alt'] = oldRIGHT;
				}
			}
			atlasContainer.finishCallback = animationEnd;
		}
		else
		{
			if (facing != initFacing)
			{
				if (animation.getByName('singRIGHT') != null)
				{
					var oldRight = animation.getByName('singRIGHT').frames;
					var oldOffset = animOffsets['singRIGHT'];
					animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
					animOffsets['singRIGHT'] = animOffsets['singLEFT'];
					animation.getByName('singLEFT').frames = oldRight;
					animOffsets['singLEFT'] = oldOffset;
				}

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					var oldOffset = animOffsets['singRIGHTmiss'];
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animOffsets['singRIGHTmiss'] = animOffsets['singLEFTmiss'];
					animation.getByName('singLEFTmiss').frames = oldMiss;
					animOffsets['singLEFTmiss'] = oldOffset;
				}

				if (animation.getByName('singRIGHT-alt') != null)
				{
					var oldRight = animation.getByName('singRIGHT-alt').frames;
					var oldOffset = animOffsets['singRIGHT-alt'];
					animation.getByName('singRIGHT-alt').frames = animation.getByName('singLEFT-alt').frames;
					animOffsets['singRIGHT-alt'] = animOffsets['singLEFT-alt'];
					animation.getByName('singLEFT-alt').frames = oldRight;
					animOffsets['singLEFT-alt'] = oldOffset;
				}
			}

			animation.finishCallback = animationEnd;
		}
	}

	function createAtlas()
	{
		atlasActive = true;
		atlasContainer = new AtlasThing();
	}

	function loadAtlas(spritemap:FlxGraphicAsset, spritemapJson:String, animationJson:String)
	{
		// atlasActive = true;
		// atlasContainer = new AtlasThing();
		atlasContainer.loadAtlas(spritemap, spritemapJson, animationJson);
		loadGraphic(FlxGraphic.fromRectangle(1, 1, FlxColor.TRANSPARENT));
		add(atlasContainer);
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (getCurAnim().startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				idleEnd();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (getCurAnim() == 'hairFall' && getCurAnimFinished())
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?ignoreDebug:Bool = false)
	{
		if (!debugMode || ignoreDebug)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | 'gfSinger':
					if (!getCurAnim().startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}

				case 'senpai':
					danced = !danced;

					if (danced)
						playAnim('danceRight', true);
					else
						playAnim('danceLeft', true);

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight', true);
					else
						playAnim('danceLeft', true);
				default:
					if (holdTimer == 0)
						playAnim('idle', true);
			}
		}
		else if (holdTimer == 0)
		{
			playAnim('idle', true);
		}
	}

	public function idleEnd(?ignoreDebug:Bool = false)
	{
		if (curCharacter == 'nothing')
			return;

		if ((!debugMode || ignoreDebug) && !atlasActive)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | "spooky" | "senpai" | "gfSinger":
					playAnim('danceRight', true, false, animation.getByName('danceRight').numFrames - 1);
				default:
					playAnim('idle', true, false, animation.getByName('idle').numFrames - 1);
			}
		}
		else if ((!debugMode || ignoreDebug))
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | "spooky" | "senpai" | "gfSinger":
					playAnim('danceRight', true, false, atlasContainer.maxIndex[animRedirect['danceRight']]);
				default:
					playAnim('idle', true, false, atlasContainer.maxIndex[animRedirect['idle']]);
			}
		}
		else if ((!debugMode || ignoreDebug))
		{
			if (animExists(getCurAnim() + "End"))
				playAnim(getCurAnim() + "End", true, false);
			else
				playAnim('idleEnd', true, false);
		}
	}

	var curAtlasAnim:String;

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (curCharacter == 'nothing')
			return;

		if (AnimName.endsWith('-alt') && !animExists(AnimName))
		{
			AnimName = AnimName.substring(0, AnimName.length - 4);
		}

		if (atlasActive)
		{
			var daAnim:String = AnimName;

			if (!Force && !getCurAnimFinished())
				return;

			if (AnimName.endsWith('miss') && !atlasContainer.animList.contains(animRedirect[AnimName]))
			{
				daAnim = AnimName.substring(0, AnimName.length - 4);
				color = 0x5462bf;
			}
			else
				color = 0xffffff;

			var daOffset = animOffsets.get(daAnim);
			if (animOffsets.exists(daAnim))
			{
				if (initWidth > -1)
				{
					atlasContainer.relativeX = -(((facing != initFacing ? -1 : 1) * daOffset[0]
						+ (facing != initFacing ? atlasContainer.animWidths[animRedirect[daAnim]] - initFrameWidth : 0)) * scale.x);
					atlasContainer.relativeY = -(daOffset[1] * scale.y);
				}
				else
				{
					atlasContainer.relativeX = -(daOffset[0] * scale.x);
					atlasContainer.relativeY = -(daOffset[1] * scale.y);
				}
			}

			atlasContainer.x = x + atlasContainer.relativeX;
			atlasContainer.y = y + atlasContainer.relativeY;

			atlasContainer.playAtlasAnim(animRedirect[daAnim], Force, Frame);
			curAtlasAnim = AnimName;
			frameWidth = atlasContainer.frameWidth;
			frameHeight = atlasContainer.frameHeight;
			updateHitbox();

			if (curCharacter == 'gf')
			{
				if (AnimName == 'singLEFT')
				{
					danced = true;
				}
				else if (AnimName == 'singRIGHT')
				{
					danced = false;
				}

				if (AnimName == 'singUP' || AnimName == 'singDOWN')
				{
					danced = !danced;
				}
			}
		}
		else
		{
			var daAnim:String = AnimName;
			if (AnimName.endsWith('miss') && animation.getByName(AnimName) == null)
			{
				daAnim = AnimName.substring(0, AnimName.length - 4);
				color = 0x5462bf;
			}
			else
				color = 0xffffff;

			animation.play(daAnim, Force, Reversed, Frame);

			updateHitbox();

			var daOffset = animOffsets.get(animation.curAnim.name);
			if (animOffsets.exists(animation.curAnim.name))
			{
				if (initFrameWidth > -1)
					offset.set(((facing != initFacing ? -1 : 1) * daOffset[0] + (facing != initFacing ? frameWidth - initFrameWidth : 0)) * scale.x + offset.x,
						daOffset[1] * scale.y + offset.y);
				else
					offset.set(daOffset[0] * scale.x + offset.x, daOffset[1] * scale.y + offset.y);
			}
			else
				offset.set(0, 0);

			if (curCharacter == 'gf')
			{
				if (AnimName == 'singLEFT')
				{
					danced = true;
				}
				else if (AnimName == 'singRIGHT')
				{
					danced = false;
				}

				if (AnimName == 'singUP' || AnimName == 'singDOWN')
				{
					danced = !danced;
				}
			}
		}

		if (AnimName.contains('sing'))
			canAutoIdle = true;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	function animationEnd(name:String)
	{
		if (true)
		{
			var theAnim = (atlasActive ? getCurAnim() : name);
			switch (curCharacter)
			{
				case "dad" | "mom" | "mom-car" | "bf-car":
					if (!theAnim.contains('miss'))
					{
						playAnim(theAnim, true, false, getFrameCount(theAnim) - 4);
					}

				case "bf" | "bf-christmas":
					if (theAnim.contains("miss"))
					{
						playAnim(theAnim, true, false, getFrameCount(theAnim) - 4);
					}

				case "monster-christmas" | "monster":
					switch (theAnim)
					{
						case "idle":
							playAnim(theAnim, false, false, 10);
						case "singUP":
							playAnim(theAnim, false, false, 8);
						case "singDOWN":
							playAnim(theAnim, false, false, 7);
						case "singLEFT":
							playAnim(theAnim, false, false, 5);
						case "singRIGHT":
							playAnim(theAnim, false, false, 6);
					}
			}
		}
		var theAnim = (atlasActive ? getCurAnim() : name);
		if (theAnim == 'dodge' || theAnim == 'hit' || theAnim == 'attack')
		{
			canAutoIdle = true;
			idleEnd();
		}
	}

	public function getCurAnim()
	{
		if (curCharacter == 'nothing')
			return "";

		if (atlasActive)
		{
			return curAtlasAnim;
		}
		else
			return animation.curAnim.name;
	}

	public function getFrameCount(name:String)
	{
		if (atlasActive)
		{
			return atlasContainer.maxIndex[animRedirect[name]] + 1;
		}
		else
		{
			return animation.getByName(name).numFrames;
		}
		return -1;
	}

	public function getCurAnimFinished()
	{
		if (atlasActive)
			return atlasContainer.curAnimFinished;
		else
			return animation.curAnim.finished;
	}

	public function animExists(anim:String)
	{
		if (atlasActive)
		{
			return atlasContainer.animList.contains(animRedirect[anim]);
		}
		else
			return animation.getByName(anim) != null;
	}

	override public function updateHitbox():Void
	{
		width = Math.abs(scale.x) * frameWidth;
		height = Math.abs(scale.y) * frameHeight;
		if (!atlasActive)
		{
			offset.set(-0.5 * (width - frameWidth), -0.5 * (height - frameHeight));
			centerOrigin();
		}
	}

	function setAtlasAnim(name:String, animName:String, looping:Bool = false)
	{
		animRedirect[name] = animName;
		atlasContainer.setLooping(animName, looping);
		atlasContainer.onlyTheseAnims.push(animName);
	}

	override public function destroy()
	{
		if (animRedirect != null)
		{
			animRedirect.clear();
			animRedirect = null;
		}
		if (animRedirect != null)
		{
			animRedirect.clear();
			animRedirect = null;
		}
		// atlasContainer = FlxDestroyUtil.destroy(atlasContainer);
		super.destroy();
	}
}

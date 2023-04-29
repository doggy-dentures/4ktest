package transition;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxCamera;
import transition.data.*;

/**
	Automatically adds and plays custom state transition animations.

	This class was made as an alternative to HaxeFlixel's built in 

    transitions to allow for more complex animations.

    Written by Rozebud
**/
class CustomTransition{

    /**
	* Plays a custom transition animation and switches states.
	*
	* @param	transitionData  The animation that will get played. Can also be anything that extends `BasicTransition`.
	* @param	state           The state that will be switched to after the animation. If set to `null` the transition will be destroyed after playing instead of switching states.
	**/
    public static function transition(transitionData:BasicTransition, ?state:FlxState = null):Void{

        var transitionCamera = new FlxCamera();
		transitionCamera.bgColor.alpha = 0;
		FlxG.cameras.add(transitionCamera, false);
        
        transitionData.state = state;
        transitionData.transitionCamera = transitionCamera;
        transitionData.cameras = [transitionCamera];
        FlxG.state.add(transitionData);
        transitionCamera.flashSprite.parent.removeChild(transitionCamera.flashSprite);
        FlxG.game.addChild(transitionCamera.flashSprite);
        transitionData.play();

        return;

    }

}
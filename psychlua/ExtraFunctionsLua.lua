-- | ExtraFunctionsLua v0.0.3 |
function onCreate()
    addHaxeLibrary('FlxTween','flixel.tweens')
    addHaxeLibrary('FlxEase','flixel.tweens')
    addHaxeLibrary('StrumNote','objects')
    runHaxeCode([[
    createGlobalCallback('noteTweenScale',function(tag:String,note:Int,?scaleX:Float,?scaleY:Float,?duration:Float,?ease:String) {
        if (duration == null || duration <= 0) duration = 0.5;
        if (ease == null || Reflect.field(FlxEase,ease) == null) ease = 'linear';
        if (game.modchartTweens == null) game.modchartTweens = new Map<String,FlxTween>();
        if (game.modchartTweens.exists(tag)) {
            var tween = game.modchartTweens.get(tag);
            if (tween != null) tween.cancel();
            game.modchartTweens.remove(tag);
        }
        if (note < 0) note = 0;
        var NoteName:StrumNote = game.strumLineNotes.members[note % game.strumLineNotes.length];
        if (NoteName != null) {
            if (scaleX == null) scaleX = NoteName.scale.x;
            if (scaleY == null) scaleY = NoteName.scale.y;
            var easeFunction = Reflect.field(FlxEase,ease);
            game.modchartTweens.set(tag,FlxTween.tween(NoteName.scale,{x: scaleX,y: scaleY},duration,{
                ease: easeFunction,
                onComplete: function(twn:FlxTween) {
                    game.callOnLuas('onTweenCompleted', [tag]);
                    game.modchartTweens.remove(tag);
                }
            }));
        }
    });
    createGlobalCallback('print',function(text:String) {
        debugPrint(text);
    });
    createGlobalCallback('setObjectPosition',function(tag:String,?ValorX:Float,?ValorY:Float) {
        if (ValorX == null) ValorX = parentLua.call('getProperty',[tag + '.x']);
        if (ValorY == null) ValorY = parentLua.call('getProperty',[tag + '.y']);
        parentLua.call('setProperty',[tag + '.x',ValorX]);
        parentLua.call('setProperty',[tag + '.y',ValorY]);
    });
    ]])
end

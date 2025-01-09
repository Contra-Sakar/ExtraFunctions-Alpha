-- | ExtraFunctionsLua v0.0.5 |
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
    var baseTag:String = tag.split('.')[0];
    var property:String = tag.indexOf('.') != -1 ? tag.split('.')[1] : '';
    if (property != '' && property != 'scale') {
        debugPrint('The property "' + property + '" is not valid. Only position or scale adjustment is allowed.\nLa propiedad "' + property + '" no es válida. Solo se permite ajustar posición o escala.',FlxColor.RED);
        return;
    }
    var propX:String = property == 'scale' ? '.scale.x' : '.x';
    var propY:String = property == 'scale' ? '.scale.y' : '.y';
    if (ValorX == null) ValorX = parentLua.call('getProperty',[baseTag + propX]);
    if (ValorY == null) ValorY = parentLua.call('getProperty',[baseTag + propY]);
        parentLua.call('setProperty',[baseTag + propX,ValorX]);
        parentLua.call('setProperty',[baseTag + propY,ValorY]);
    });
    createGlobalCallback('setStrumCam',function(strumGroup:String,camera:String,?unspawnNotes:Bool = true,?scrollFactor:Dynamic = null) {
    var targetGroup = Reflect.field(game,strumGroup);
    var cameraObj = Reflect.field(game,camera);
    if (targetGroup == null || cameraObj == null) {
        debugPrint('Error: Specified group or camera does not exist - ' + strumGroup + ', ' + camera + '\nError: El grupo o la cámara especificados no existen - ' + strumGroup + ', ' + camera, FlxColor.RED);
        return;
    }
    for (strumOp in targetGroup) {
        strumOp.cameras = [cameraObj];
        if (scrollFactor != null && scrollFactor.length == 2) {
            strumOp.scrollFactor.set(scrollFactor[0],scrollFactor[1]);
        }
    }
    if (unspawnNotes == null || unspawnNotes) {
        for (note in game.unspawnNotes) {
            if ((strumGroup == 'playerStrums' && note.mustPress) || 
                (strumGroup == 'opponentStrums' && !note.mustPress) || 
                strumGroup == 'strumLineNotes') {
                note.cameras = [cameraObj];
                if (scrollFactor != null && scrollFactor.length == 2) {
                    note.scrollFactor.set(scrollFactor[0],scrollFactor[1]);
                }
            }
        }
    }
    var noteSplashes = game.grpNoteSplashes;
    if (noteSplashes != null) {
        for (splash in noteSplashes) {
            splash.cameras = [cameraObj];
            if (scrollFactor != null && scrollFactor.length == 2) {
                splash.scrollFactor.set(scrollFactor[0],scrollFactor[1]);
                }
            }
        }
    });
    ]])
end

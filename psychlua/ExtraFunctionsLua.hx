/*
    | noteTweenScale | by LuaXdea |
    YouTube: https://youtube.com/@lua-x-dea?si=7Qo2vIp_z_cjDiLq
    | Psych Engine Version |
    • 0.7.2h
    • 1.0-Pre
    • 1.0

- [English]
noteTweenScale(Tag:String,note:Int,?scaleX:Float,?scaleY:Float,?duration:Float,?ease:String)

- Starts a tween to change the scale of a note on the strum and executes the onTweenCompleted function upon completion.

- Parameters:

  - Tag (String): Unique label to identify the tween. If another animation uses the same name, it will be overwritten.

  - note (Int): ID of the note to modify (0-3 = Opponent, 4-7 = Player).

  - scaleX (Float, optional): Scale on the X-axis of the note. If not specified, the current scale is used.

  - scaleY (Float, optional): Scale on the Y-axis of the note. If not specified, the current scale is used.

  - duration (Float, optional): Duration of the tween. By default, it is 0.5.

  - ease (String, optional): Type of easing for the animation. By default, it is 'linear'.

- Additional notes:
  - If you don’t use scaleX or scaleY, the note will keep its current size.
  - Use a different label (Tag) for each tween to prevent them from overwriting each other.



- [Español]
noteTweenScale(Tag:String,note:Int,?scaleX:Float,?scaleY:Float,?duration:Float,?ease:String)

- Inicia un tween para cambiar la escala de una nota en el strum y ejecuta la función onTweenCompleted al finalizar.

- Parámetros:

  - Tag (String): Etiqueta única para identificar el tween. Si otra animación usa el mismo nombre, será sobrescrita.

  - note (Int): ID de la nota a modificar (0-3 = Oponente, 4-7 = Jugador).

  - scaleX (Float, opcional): Escala en el eje X de la nota. Si no se especifica, se usa la escala actual.

  - scaleY (Float, opcional): Escala en el eje Y de la nota. Si no se especifica, se usa la escala actual.

  - duration (Float, opcional): Duración del tween. Por defecto, es 0.5.

  - ease (String, opcional): Tipo de easing para la animación. Por defecto, es 'linear'.


- Notas adicionales:
  - Si no usas scaleX o scaleY, la nota mantendrá su tamaño actual.
  - Usa una etiqueta (Tag) diferente para cada tween, así no se reemplazan entre sí.
*/
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import objects.StrumNote;

function onCreate() {
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
}

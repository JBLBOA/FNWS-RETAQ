function onCreate()
    makeLuaSprite("FONDO", "bgs/OU/FONDO", 400, 0)
    addLuaSprite("FONDO", false)

    makeAnimatedLuaSprite("trolos", "bgs/OU/ou_FNWS_RETAQ", 1120, 250, "sparrow")
    addLuaSprite("trolos", false)

    makeLuaSprite("ARBUSTO", "bgs/OU/ARBUSTO", 1200, 300)
    addLuaSprite("ARBUSTO", true)

    makeLuaSprite("negrotext", "", 200, -400)
    makeGraphic("negrotext", 256, 256, '000000')
    setProperty("negrotext.alpha", 0.5)
    setObjectCamera("negrotext", 'hud')
    addLuaSprite("negrotext")

    makeLuaText("NEGRO", "YOU ARE HERE", 0, getProperty("negrotext.x") + 10, -400)
    setTextSize("NEGRO", 30)
    setTextColor("NEGRO", "FF0202")
    setObjectCamera("NEGRO", 'hud')
    addLuaText("NEGRO")
end

function onSongStart()
    doTweenY("NEGROY", "NEGRO", 300, 1.0, "bounceOut")
    doTweenY("negrotextY", "negrotext", 200, 1.0, "bounceOut")

    runTimer("SOXD", 1.5)
end

function onTimerCompleted(t)
    if t == "SOXD" then
        doTweenY("NEGROY2", "NEGRO", 1000, 1.0, "bounceIn")
        doTweenY("negrotextY2", "negrotext", 1000, 1.0, "bounceIn")
    end
end

function onBeatHit()
    addAnimationByPrefix("trolos", "idle", "TROLLSIDLE", 24, true)
end

function onCountdownStarted()
    noteTweenX("note0", 0, defaultPlayerStrumX0, 0.1, "linear")
    noteTweenX("note1", 1, defaultPlayerStrumX1, 0.1, "linear")
    noteTweenX("note2", 2, defaultPlayerStrumX2, 0.1, "linear")
    noteTweenX("note3", 3, defaultPlayerStrumX3, 0.1, "linear")

    noteTweenX("note4", 4, defaultOpponentStrumX0, 0.1, "linear")
    noteTweenX("note5", 5, defaultOpponentStrumX1, 0.1, "linear")
    noteTweenX("note6", 6, defaultOpponentStrumX2, 0.1, "linear")
    noteTweenX("note7", 7, defaultOpponentStrumX3, 0.1, "linear")
end
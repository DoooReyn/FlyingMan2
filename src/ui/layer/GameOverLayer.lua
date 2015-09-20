--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/14
-- Time: 上午12:01
-- To change this template use File | Settings | File Templates.
--
GameOverLayer = class("GameOverLayer", BaseLayer)
GameOverLayer.__index = GameOverLayer

function GameOverLayer.create()
    return GameOverLayer.new()
end

function GameOverLayer:ctor()
    GameOverLayer.super.ctor(self)
    self:doUILayout()
end

function GameOverLayer:doUILayout()
    local w,h = global.getWinMidPoint()
    local overPath = global.getImagePath("over.png")
    local overSp = global.newSprite(self,overPath)
    overSp:setPosition(w, h*2)

    local move1 = cc.MoveBy:create(0.2, cc.p(0, -h))
    local move2 = cc.MoveBy:create(0.05, cc.p(0, 20))
    local move3 = cc.MoveBy:create(0.05, cc.p(0, -20))
    local delay = cc.DelayTime:create(3)
    local func1 = cc.CallFunc:create(function()
        local gameScene = require("src.ui.scene.GameScene").create()
        global.replaceScene(gameScene)
    end)
    local seq = cc.Sequence:create(move1,move2,move3,delay,func1)
    overSp:runAction(seq)
end

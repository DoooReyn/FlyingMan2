--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/14
-- Time: 上午11:10
-- To change this template use File | Settings | File Templates.
--

PlayScene = class("PlayScene", BasePhysicsScene)
PlayScene.__index = PlayScene

function PlayScene.create()
    return PlayScene.new()
end

function PlayScene:ctor()
    PlayScene.super.ctor(self)
    self:enableDebugDraw()
    self:enableGravity()
    self:createPlayLayer()
end

function PlayScene:createPlayLayer()
    require("src.ui.layer.PlayLayer")
    self:addChild(PlayLayer.create())
end

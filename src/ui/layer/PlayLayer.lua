--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/14
-- Time: 上午11:10
-- To change this template use File | Settings | File Templates.
--
PlayLayer = class("PlayLayer", BaseLayer)
PlayLayer.__index = PlayLayer

function PlayLayer.create()
    return PlayLayer.new()
end

function PlayLayer:ctor()
    PlayLayer.super.ctor(self)
    self.isEnded = false
    self:addBackGroundLayer()
    self:addPlayer()
end

function PlayLayer:addBackGroundLayer()
    require("src.ui.layer.BackGroundLayer")
    self.backgroundLayer = BackGroundLayer.create()
    self:addChild(self.backgroundLayer)
end

function PlayLayer:createGameOverLayer()
    require("src.ui.layer.GameOverLayer")
    local layer = GameOverLayer.create()
    self:addChild(layer)
end

function PlayLayer:addPlayer()
    require("src.object.Player")
    self.player = Player.new()
    local w,h = global:getWinMidPoint()
    self.player:setPosition(-100, h*4/3)
    self:addChild(self.player)
    self.player:createProgress()
    self:playerFlyToScene()
    self:addPlayerCollision()
end

function PlayLayer:playerFlyToScene()
    local function startDrop()
        self.player:getPhysicsBody():setGravityEnable(true)
        self.player:drop()
        self.backgroundLayer:scheduleScroll()

        local layer = ccui.Layout:create()
        layer:setContentSize(cc.size(1136,640))
        -- layer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        layer:setBackGroundColor(cc.c3b(169,169,169))
        layer:setOpacity(100)
        layer:setTouchEnabled(true)
        layer:addTouchEventListener(function(sender,touchType)
            if self.isEnded == false then
                if touchType == ccui.TouchEventType.began then
                    self.player:flying()
                    self.player:getPhysicsBody():setVelocity(cc.p(0, 98))
                elseif touchType == ccui.TouchEventType.ended then
                    self.player:drop()
                end
            end
        end)
        layer:setAnchorPoint(AnchorPoint.Center)
        layer:setPosition(global.getWinMidPoint())
        self:addChild(layer)
    end

    self.player:flying()
    self.player:getPhysicsBody():setGravityEnable(false)
    local w,h = global:getWinMidPoint()
    local move = cc.MoveTo:create(3, cc.p(w, h*4/3))
    local func = cc.CallFunc:create(startDrop)
    local sequence = cc.Sequence:create(move, func)
    self.player:runAction(sequence)
end

function PlayLayer:addPlayerCollision()
    local function contactLogic(node)
        if not self.backgroundLayer or not self.player then return end
        if node:getTag() == HEART_TAG then
            local emitter = cc.ParticleSystemQuad:create("particles/stars.plist")
            emitter:setBlendAdditive(false)
            emitter:setPosition(node:getPosition())
            self.backgroundLayer.map:addChild(emitter)
            if self.player.blood < 100 then
                self.player.blood = self.player.blood + 5
                self.player:setProPercentage(self.player.blood)
            end
            global.playAudioByType(AudioType.Effect, "sound/heart.mp3")
            node:removeFromParent()

        elseif node:getTag() == GROUND_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 20
            self.player:setProPercentage(self.player.blood)
            global.playAudioByType(AudioType.Effect, "sound/ground.mp3")

        elseif node:getTag() == AIRSHIP_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 10
            self.player:setProPercentage(self.player.blood)
            global.playAudioByType(AudioType.Effect, "sound/hit.mp3")

        elseif node:getTag() == BIRD_TAG then
            self.player:hit()
            self.player.blood = self.player.blood - 5
            self.player:setProPercentage(self.player.blood)
            global.playAudioByType(AudioType.Effect, "sound/hit.mp3")
        end
    end

    local function onContactBegin(contact)
        if not self.backgroundLayer or not self.player then return end
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()

        contactLogic(a)
        contactLogic(b)

        return true
    end

    local function onContactSeperate(contact)
        if not self.player then return end
        if self.player.blood <= 0 and self.isEnded == false then
            self.player:die()
            self.backgroundLayer:unscheduleUpdate()
            self:endGame()
        end
    end

    self.contactListener = cc.EventListenerPhysicsContact:create()
    self.contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    self.contactListener:registerScriptHandler(onContactSeperate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(self.contactListener, 1)
end

function PlayLayer:endGame()
    if self.contactListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.contactListener)
    end
    self.isEnded = true
    self:createGameOverLayer()
end

function PlayLayer:onEnter()
    PlayLayer.super.onEnter(self)
    self:becomeMyEventListener(G_UIEvent.GameOver)
end

function PlayLayer:onListenMyEvent(eventName, data)
    PlayLayer.super.onListenMyEvent(self, eventName, data)
    if eventName == G_UIEvent.GameOver then
        self:endGame()
    end
end

function PlayLayer:onExit()
    PlayLayer.super.onExit(self)
end

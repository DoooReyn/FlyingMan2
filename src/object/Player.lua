--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/18
-- Time: 上午21:33
-- To change this template use File | Settings | File Templates.
--
Player = class("Player", function()
    return global.newSpriteWithFrameName(nil, "flying1.png")
end)

function Player:ctor()
    self:addAnimationCache()
    self:setPhysicsBodys()
end

function Player:addAnimationCache()
    local animationNames = {"flying", "drop", "die"}
    local animationFrameNum = {4, 3, 4}

    for i = 1, #animationNames do
        local frames = global.newFrames(animationNames[i] .. "%d.png", 1, animationFrameNum[i])
        local animation = global.newAnimation(frames, 0.5 / 8)
        animation:setDelayPerUnit(0.1)
        global.setAnimationCache(animationNames[i], animation)
    end
end

function Player:setPhysicsBodys()
    local body = cc.PhysicsBody:createBox(self:getContentSize(), MATERIAL_DEFAULT)
    body:setRotationEnable(false)
    body:setCategoryBitmask(0x0111)
    body:setContactTestBitmask(0x1111)
    body:setCollisionBitmask(0x1001)
    self:setTag(PLAYER_TAG)
    self:setPhysicsBody(body)
    self:getPhysicsBody():setGravityEnable(false)
end

function Player:createProgress()
    self.blood = 100
    local progressbg = global.newSprite(nil,"image/progress1.png")
    local progressfg = global.newSprite(nil,"image/progress2.png")
    local size = progressbg:getContentSize()
    local pos = cc.p(size.width/2, size.height/2)
    self.fill = cc.ProgressTimer:create(progressfg)
    self.fill:setType(PROGRESS_TIMER_BAR)
    self.fill:setMidpoint(cc.p(0, 0.5))
    self.fill:setBarChangeRate(cc.p(1.0, 0))
    self.fill:setPosition(pos)
    progressbg:addChild(self.fill)
    self.fill:setPercentage(self.blood)
    progressbg:setAnchorPoint(cc.p(0, 1))
    self:getParent():addChild(progressbg)
    local w,h = global.getWinMidPoint()
    progressbg:setPosition(cc.p(0, h*2))
end

function Player:setProPercentage(Percentage)
    self.fill:setPercentage(Percentage)
end

function Player:hit()
    local hit = cc.Sprite:create()
    local size = self:getContentSize()
    hit:setPosition(size.width/2, size.height/2)
    self:addChild(hit)

    local frames = global.newFrames("attack%d.png", 1, 6)
    local animation = global.newAnimation(frames, 0.3 / 6)
    local animate = cc.Animate:create(animation)
    local callFunc= cc.CallFunc:create(function()
        hit:removeFromParent()
    end)
    local sequence = cc.Sequence:create(animate,callFunc)
    hit:runAction(sequence)
    hit:setScale(0.6)
end

function Player:runAnimationByName(name)
    self:stopAllActions()
    local animation = global.getAnimationFromCache(name)
    local animate = cc.Animate:create(animation)
    if name == "die" then
        self:runAction(animate)
    else
        local forever = cc.RepeatForever:create(animate)
        self:runAction(forever)
    end
end

function Player:flying()
    self:runAnimationByName("flying")
end

function Player:drop()
    self:runAnimationByName("drop")
end

function Player:die()
    self:runAnimationByName("die")
end

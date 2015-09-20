--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/14
-- Time: 上午13:43
-- To change this template use File | Settings | File Templates.
--

Bird = class("Bird", function()
    return global.newSpriteWithFrameName(nil, "bird1.png")
end)
Bird.__index = Bird

function Bird:ctor(x, y)
    self:setPhysicsBodys()
    self:setPosition(x, y)
    self:runAnimation()
end

function Bird:setPhysicsBodys()
    local width = self:getContentSize().width
    local birdBody = cc.PhysicsBody:createCircle(width/2,MATERIAL_DEFAULT)
    birdBody:setRotationEnable(false)
    birdBody:setCategoryBitmask(0x0010)
    birdBody:setContactTestBitmask(0x0010)
    birdBody:setCollisionBitmask(0x1000)
    self:setTag(BIRD_TAG)
    self:setPhysicsBody(birdBody)
    self:getPhysicsBody():setGravityEnable(false)
end

function Bird:runAnimation()
    local frames    = global.newFrames("bird%d.png", 1, 9)
    local animation = global.newAnimation(frames, 0.5 / 9)
    animation:setDelayPerUnit(0.1)
    local animate = cc.Animate:create(animation)
    local forever = cc.RepeatForever:create(animate)
    self:runAction(forever)
end

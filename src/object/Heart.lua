--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/14
-- Time: 上午20:52
-- To change this template use File | Settings | File Templates.
--
Heart = class("Heart", function()
    return cc.Sprite:create("res/image/heart.png")
end)
Heart.__index = Heart

function Heart:ctor(x, y)
    self:setPhysicsBodys()
    self:setPosition(x, y)
end

function Heart:setPhysicsBodys()
    local width = self:getContentSize().width / 2
    local heartBody = cc.PhysicsBody:createCircle(width,MATERIAL_DEFAULT)
    heartBody:setDynamic(false)
    heartBody:setCategoryBitmask(0x0001)
    heartBody:setContactTestBitmask(0x0100)
    heartBody:setCollisionBitmask(0x0001)
    self:setPhysicsBody(heartBody)
    self:getPhysicsBody():setGravityEnable(false)
    self:setTag(HEART_TAG)
end

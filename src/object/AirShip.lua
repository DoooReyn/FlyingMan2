--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/14
-- Time: 上午20:51
-- To change this template use File | Settings | File Templates.
--
AirShip = class("AirShip", function()
    return global.newSpriteWithFrameName(nil, "airship.png")
end)
AirShip.__index = AirShip

function AirShip:ctor(x, y)
    self:setPhysicsBodys()
    self:setPosition(x, y)
    self:runAnimation()
end

function AirShip:setPhysicsBodys()
    local width = self:getContentSize().width / 2
    local airshipBody = cc.PhysicsBody:createCircle(width, MATERIAL_DEFAULT)
    airshipBody:setCategoryBitmask(0x0100)
    airshipBody:setContactTestBitmask(0x0100)
    airshipBody:setCollisionBitmask(0x1000)
    self:setTag(AIRSHIP_TAG)
    self:setPhysicsBody(airshipBody)
    self:getPhysicsBody():setGravityEnable(false)
end

function AirShip:runAnimation()
    local height = self:getContentSize().height / 2
    local move1 = cc.MoveBy:create(3, cc.p(0, height))
    local move2 = cc.MoveBy:create(3, cc.p(0, -height))
    local seq = cc.Sequence:create(move1, move2)
    local forever = cc.RepeatForever:create(seq)
    self:runAction(forever)
end

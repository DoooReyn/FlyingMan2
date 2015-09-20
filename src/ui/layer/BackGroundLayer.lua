--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/14
-- Time: 上午13:43
-- To change this template use File | Settings | File Templates.
--
require("src.object.Bird")
require("src.object.AirShip")
require("src.object.Heart")

BackGroundLayer = class("BackGroundLayer", BaseLayer)
BackGroundLayer.__index = BackGroundLayer

function BackGroundLayer.create()
    return BackGroundLayer.new()
end

function BackGroundLayer:ctor()
    BackGroundLayer.super.ctor(self)
    self:initGameData()
    self:createBackgrounds()
    self:setPhysicsBodys()
    self:addBody("heart", Heart)
    self:addBody("airship", AirShip)
    self:addBody("bird", Bird)
    self:scheduleScroll()
end

function BackGroundLayer:initGameData()
    self.distantBg = {}
    self.nearbyBg  = {}
    self.tiledMapBg= {}
    self.bird = {}
end

function BackGroundLayer:createBackgrounds()
    -- 创建布幕背景
    local bjPath = global.getImagePath("bj2.jpg")
	local bj = global.newSprite(self,bjPath)
    local w,h = global.getWinMidPoint()
	bj:setPosition(w, h)
	bj:setLocalZOrder(ZORDER_LAYOUT_BG)

	-- 创建远景背景
    local bgPath = global.getImagePath("b2.png")
	local bg1 = global.newSprite(self, bgPath)
    bg1:setAnchorPoint(AnchorPoint.Origin)
	bg1:setPosition(0,10)
	bg1:setLocalZOrder(ZORDER_DISTANT_BG)
    local bg2 = global.newSprite(self, bgPath)
    bg2:setAnchorPoint(AnchorPoint.Origin)
	bg2:setPosition(bg1:getContentSize().width,10)
	bg2:setLocalZOrder(ZORDER_DISTANT_BG)
	table.insert(self.distantBg, bg1)
	table.insert(self.distantBg, bg2)

    -- 添加漂浮粒子
    local emitter = cc.ParticleSystemQuad:create("particles/dirt.plist")
    -- emitter:setBlendAdditive(false)
    emitter:setPosition(w,h*2)
    self:addChild(emitter, ZORDER_DISTANT_BG)

    -- 创建近景背景
    local bgPath = global.getImagePath("b1.png")
	local bg3 = global.newSprite(self, bgPath)
    bg3:setAnchorPoint(AnchorPoint.Origin)
    bg3:setPosition(0,0)
	bg3:setLocalZOrder(ZORDER_NEARBY_BG)
	local bg4 = global.newSprite(self, bgPath)
    bg4:setAnchorPoint(AnchorPoint.Origin)
	bg4:setPosition(bg3:getContentSize().width, 0)
	bg4:setLocalZOrder(ZORDER_NEARBY_BG)
	table.insert(self.nearbyBg, bg3)
	table.insert(self.nearbyBg, bg4)

    -- tiled map
    local mapPath = global.getImagePath("map.tmx")
	self.map = cc.TMXTiledMap:create(mapPath)
    self.map:setAnchorPoint(AnchorPoint.Origin)
	self.map:setPosition(0,0)
	self.map:setLocalZOrder(ZORDER_TILEMAP_BG)
    self:addChild(self.map)
end

function BackGroundLayer:scheduleScroll()
    self:scheduleUpdateWithPriorityLua(function(dt)
        self:updateScrolling(dt)
    end,0)
end

function BackGroundLayer:updateScrolling(dt)
    -- 刷新远景背景
    if self.distantBg[2]:getPositionX() <= 0 then
        self.distantBg[1]:setPositionX(0)
    end
    local x1 = self.distantBg[1]:getPositionX() - 50*dt
    local x2 = x1 + self.distantBg[1]:getContentSize().width
    self.distantBg[1]:setPositionX(x1)
    self.distantBg[2]:setPositionX(x2)

    -- 刷新近景背景
    if self.nearbyBg[2]:getPositionX() <= 0 then
        self.nearbyBg[1]:setPositionX(0)
    end
    local x3 = self.nearbyBg[1]:getPositionX() - 100*dt
    local x4 = x3 + self.nearbyBg[1]:getContentSize().width
    self.nearbyBg[1]:setPositionX(x3)
    self.nearbyBg[2]:setPositionX(x4)

    -- 刷新地图背景
    local width = global.getWinSize().width
    if self.map:getPositionX() <= width - self.map:getContentSize().width then
        --print("game over")
        self:endGame()
    end
    local x5 = self.map:getPositionX() - 150*dt
    self.map:setPositionX(x5)

    self:addVelocityToBird()
end

function BackGroundLayer:endGame()
    self:unscheduleUpdate()
    self:dispatchMyEvent(G_UIEvent.GameOver)
end

function BackGroundLayer:addBody(objectGroupName, class)
    local objects = self.map:getObjectGroup(objectGroupName):getObjects()
    local dict= nil
    local len = table.getn(objects)

    for idx=0, len-1, 1 do
        dict = objects[idx+1]
        if dict == nil then
            break
        end

        local x = dict["x"]
        local y = dict["y"]

        local sprite = class.new(x, y)
        self.map:addChild(sprite)

        if objectGroupName == "bird" then
            table.insert(self.bird, sprite)
        end
    end
end

function BackGroundLayer:setPhysicsBodys()
    local width = self.map:getContentSize().width
    local height1 = self.map:getContentSize().height
    local height2 = self.map:getContentSize().height * 3 / 16

    local sky = cc.Node:create()
    local bodyTop = cc.PhysicsBody:createEdgeSegment(cc.p(0, height1), cc.p(width, height1), MATERIAL_DEFAULT)
    bodyTop:setCategoryBitmask(0x1000)
    bodyTop:setContactTestBitmask(0x0000)
    bodyTop:setCollisionBitmask(0x0001)
    sky:setPhysicsBody(bodyTop)
    self:addChild(sky)

    local ground = cc.Node:create()
    local bodyBottom = cc.PhysicsBody:createEdgeSegment(cc.p(0, height2), cc.p(width, height2), MATERIAL_DEFAULT)
    bodyBottom:setCategoryBitmask(0x1000)
    bodyBottom:setContactTestBitmask(0x0001)
    bodyBottom:setCollisionBitmask(0x0011)
    ground:setTag(GROUND_TAG)
    ground:setPhysicsBody(bodyBottom)
    self:addChild(ground)
end

function BackGroundLayer:addVelocityToBird()
    local dict = nil
    local len  = table.getn(self.bird)
    for idx=0, len-1, 1 do
        dict = self.bird[idx+1]
        if dict == nil  then
            break
        end
        local x = dict:getPositionX()
        local width = global.getWinSize().width
        if x <= width - self.map:getPositionX() then
            if dict:getPhysicsBody():getVelocity().x == 0 then
                dict:getPhysicsBody():setVelocity(cc.p(-70, math.random(-40, 40)))
            else
                table.remove(self.bird, idx+1)
            end
        end
    end
end

function BackGroundLayer:onEnter()
    BackGroundLayer.super.onEnter(self)
end

function BackGroundLayer:onExit()
    BackGroundLayer.super.onExit(self)
    self:unscheduleUpdate()
end

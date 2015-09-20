--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/13
-- Time: 下午11:53
-- To change this template use File | Settings | File Templates.
--
DEBUG_DRAW = cc.PhysicsWorld.DEBUGDRAW_ALL

BasePhysicsScene = class("BasePhysicsScene", function()
	local scene = cc.Scene:createWithPhysics()
	return scene
end)
BasePhysicsScene.__index = BasePhysicsScene

function BasePhysicsScene.create()
	local scene = BasePhysicsScene.new()
	return scene
end

function BasePhysicsScene:ctor()
	--场景生命周期事件处理
	self:registerNodeEvent()

	--物理世界
	self.world = self:getPhysicsWorld()
	self:enableDebugDraw()
end

-----------------场景生命周期-----------------
function BasePhysicsScene:registerNodeEvent()
	local function onNodeEvent(event)
		if event == "enter" then
			self:onEnter()
		elseif event == "enterTransitionFinish" then
			self:onEnterTransitionFinish()
		elseif event == "exit" then
			self:onExit()
		elseif event == "exitTransitionStart" then
			self:onExitTransitionStart()
		elseif event == "cleanup" then
			self:cleanup()
		end
	end
	self:registerScriptHandler(onNodeEvent)
end

function BasePhysicsScene:onEnter()
end

function BasePhysicsScene:onEnterTransitionFinish()
end

function BasePhysicsScene:onExit()
end

function BasePhysicsScene:onExitTransitionStart()
end

function BasePhysicsScene:cleanup()
end

-----------------物理世界-----------------
function BasePhysicsScene:getWorld()
	return self.world
end

function BasePhysicsScene:enableDebugDraw()
	self.world:setDebugDrawMask(DEBUG_DRAW)
end

function BasePhysicsScene:enableGravity()
	self.world:getsetGravity(cc.p(0,-98))
end

function BasePhysicsScene:disableGravity()
	self.world:getsetGravity(cc.p(0,0))
end



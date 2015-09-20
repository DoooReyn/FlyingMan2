--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/8
-- Time: 上午12:00
-- To change this template use File | Settings | File Templates.
--

BaseScene = class('BaseScene', function()
	return cc.Scene:create()
end)

BaseScene.__index = BaseScene

function BaseScene.create()
	local scene = BaseScene.new()
	return scene
end

function BaseScene:ctor()
	--场景生命周期事件处理
	self:registerNodeEvent()
end

function BaseScene:registerNodeEvent()
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

function BaseScene:onEnter()
end

function BaseScene:onEnterTransitionFinish()
end

function BaseScene:onExit()
end

function BaseScene:onExitTransitionStart()
end

function BaseScene:cleanup()
end



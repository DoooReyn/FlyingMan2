--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/8
-- Time: 上午12:00
-- To change this template use File | Settings | File Templates.
--

BaseLayer = class('BaseLayer', function()
	return cc.Layer:create()
end)

BaseLayer.__index = BaseLayer

function BaseLayer.create()
	local layer = BaseLayer.new()
	return layer
end

function BaseLayer:ctor()
	--层生命周期事件处理
	self:registerNodeEvent()
end

function BaseLayer:registerNodeEvent()
	local function onNodeEvent(event)
		if "enter" == event then
			self:onEnter()
		elseif "exit" == event then
			self:onExit()
		elseif "cleanup"==event then
			self:cleanup()
		end
	end
	self:registerScriptHandler(onNodeEvent)
end


function BaseLayer:onEnter()
	cclog('BaseLayer OnEnter')
end

function BaseLayer:onExit()
	cclog('BaseLayer onExit')
end

function BaseLayer:cleanup()
	cclog('BaseLayer cleanup')
end

-------------------------------
--层触摸事件
--
function BaseLayer:initEventDispatcher(isSwallow)
	local function onTouchBegan(touch,event)
		cclog("基础层被点击")
		return true
	end
	local function onTouchMoved(touch,event) end
	local function onTouchEnded(touch,event) end
	local function onTouchCancelled(touch,event) end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(isSwallow)
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
	listener:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED)

	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

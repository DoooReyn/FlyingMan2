--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/13
-- Time: 下午11:50
-- To change this template use File | Settings | File Templates.
--
GameLayer = class("GameLayer", BaseLayer)
GameLayer.__index = GameLayer

function GameLayer.create()
	return GameLayer.new()
end

function GameLayer:ctor()
	GameLayer.super.ctor(self)
	local bgPath = global.getImagePath("main.jpg")
	local bgImage = global.newSprite(self, bgPath)
	local w,h = global.getWinMidPoint()
	bgImage:setPosition(cc.p(w,h))

	local titlePath = global.getImagePath("title.png")
	local title = global.newSprite(self, titlePath)
	title:setPosition(w/2*3, h)
	self.title = title
	self:runTitleAction()

	local normalPath  = global.getImagePath("start1.png")
	local pressedPath = global.getImagePath("start2.png")
	local startBtn = ccui.Button:create(normalPath,pressedPath)
	startBtn:setPosition(w/2, h)
	self:addChild(startBtn)
	local function btnTouchEvent(sender, touchType)
		if touchType == TouchType.Ended then
			global.playAudioByType(AudioType.Effect, "res/sound/button.wav", false)
			self:enterPlayScene()
		end
	end
	startBtn:addTouchEventListener(btnTouchEvent)
end

function GameLayer:stopAction()
	self.title:stopAction()
end

function GameLayer:runTitleAction()
	self.title:stopAllActions()
	local move1 = cc.MoveBy:create(0.5, cc.p(0, 10))
	local move2 = cc.MoveBy:create(0.5, cc.p(0, -10))
	local seq = cc.Sequence:create(move1, move2)
	local forever = cc.RepeatForever:create(seq)
	self.title:runAction(forever)
end

function GameLayer:onEnter()
	GameLayer.super.onEnter(self)
	if self.title then
		self:runTitleAction()
	end
end

function GameLayer:onExit()
	GameLayer.super.onExit(self)
	if self.title then
		self.title:stopAllActions()
	end
end

function GameLayer:enterPlayScene()
	local runningScene = global.getRunningScene()
	global.pushScene(runningScene)

	require("src.ui.scene.PlayScene")
	local playScene = PlayScene.create()
	local transitionScene = cc.TransitionSplitRows:create(1,playScene)
	global.replaceScene(transitionScene)
end

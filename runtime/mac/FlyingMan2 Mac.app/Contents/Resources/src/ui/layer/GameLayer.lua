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
	local layer = GameLayer.new()
	return layer
end

function GameLayer:ctor()
	local bgPath = global.getImagePath("main.jpg")
	-- local bgImage = global.newSprite(self, bgPath)
	local bgImage = cc.Sprite:create(bgPath)
	bgImage:setPosition(cc.p(global.cx, global.cy))
	bgImage:setScale(2.0)
	self:addChild(bgImage)

	local titlePath = global.getImagePath("title.png")
	local title = global.newSprite(self, titlePath)
	title:setPosition(global.cx/2*3, global.cy)

	local move1 = cc.MoveBy:create(0.5, cc.p(0, 10))
	local move2 = cc.MoveBy:create(0.5, cc.p(0, -10))
	local seq = cc.Sequence:create(move1, move2)
	local forever = cc.RepeatForever:create(seq)
	title:runAction(forever)

	local normalPath  = global.getImagePath("start1.png")
	local pressedPath = global.getImagePath("start2.png")
	local startBtn = ccui.Button:create(normalPath,pressedPath)
	startBtn:setPosition(global.cx/2, global.cy)
	self:addChild(startBtn)
	local function btnTouchEvent(sender, touchType)
		if touchType == TouchType.Ended then
			global.playAudioByType(AudioType.Effect, "sound/button.wav", false)
			self:enterPlayScene()
		end
	end
end

function GameLayer:enterPlayScene()
	global.pushScene(self)
	self:release()
	-- local playScene = require("src.ui.scene.PlayScene").create()
	-- global.popScene(playScene)
end

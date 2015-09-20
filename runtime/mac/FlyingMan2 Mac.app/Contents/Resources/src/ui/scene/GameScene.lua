--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/8
-- Time: 上午12:00
-- To change this template use File | Settings | File Templates.
--
require("src.ui.layer.GameLayer")

local GameScene = class('GameScene', BaseScene)
GameScene.__index = GameScene

function GameScene.create()
	local scene = GameScene.new()
	return scene
end

function GameScene:ctor()
	GameScene.super.ctor(self)
	self:preloadGameAudio()
	self:playGameBgMusic()
	self:createGameLayer()
end

function GameScene:preloadGameAudio()
	global.preloadAudioByType(AudioType.Music, "sound/mother.mp3")
	global.preloadAudioByType(AudioType.Effect,"sound/button.wav")
	global.preloadAudioByType(AudioType.Effect,"sound/ground.mp3")
	global.preloadAudioByType(AudioType.Effect,"sound/heart.mp3")
	global.preloadAudioByType(AudioType.Effect,"sound/hit.mp3")
end

function GameScene:playGameBgMusic()
	global.playAudioByType(AudioType.Music,"sound/mother.mp3",true)
end

function GameScene:createGameLayer()
	local layer = GameLayer.create()
	self:addChild(layer)
end

return GameScene

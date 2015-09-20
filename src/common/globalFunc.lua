--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/7
-- Time: 上午10:19
-- To change this template use File | Settings | File Templates.
--

--------------------------------Director-----------------------------

--导演单例
global = global or {}

function global.director()
	return cc.Director:getInstance()
end

function global.getWinSize()
	return global.director():getWinSize()
end

function global.getWinMidPoint()
	local size = global.getWinSize()
	return size.width/2, size.height/2
end

function global.getNodeMidPoint(node)
	local size = node:getContentSize()
	return cc.p(size.width/2,size.height/2)
end

function global.getVisibleSize()
	return global.director():getVisibleSize()
end

function global.getOpenGLView()
	return global.director():getOpenGLView()
end

function global.getRunningScene()
	return global.director():getRunningScene()
end

function global.replaceScene(scene)
	global.director():replaceScene(scene)
end

function global.runWithScene(scene)
	global.director():runWithScene(scene)
end

function global.runScene(scene)
	if global.getRunningScene() then
		global.replaceScene(scene)
	else
		global.runWithScene(scene)
	end
end

function global.pushScene(scene)
	global.director():pushScene(scene)
end

function global.popScene()
	global.director():popScene()
end

function global.getScheduler()
	return global.director():getScheduler()
end

function global.getActionManager()
	return global.director():getActionManager()
end

function global.setActionManager(mgr)
	global.director():setActionManager(mgr)
end

function global.getEventDispatcher()
	return global.director():getEventDispatcher()
end

function global.setEventDispatcher(dispatcher)
	global.director():setEventDispatcher(dispatcher)
end

--------------------------------SimpleAudioEngine-----------------
function global.getAudioEngine()
	return cc.SimpleAudioEngine:getInstance()
end

function global.preloadAudioByType(type, audio)
	if type == AudioType.Music then
		global.getAudioEngine():preloadMusic(audio)
	elseif type == AudioType.Effect then
		global.getAudioEngine():preloadEffect(audio)
	end
end

function global.playAudioByType(type, audio, isloop)
	if type == AudioType.Music then
		global.getAudioEngine():playMusic(audio, isloop)
	elseif type == AudioType.Effect then
		global.getAudioEngine():playEffect(audio, isloop)
	end
end

--------------------------------path-----------------------------
function global.getFontName()
	return "res/font/GameFont.ttf"
end

function global.getImagePath(name)
	return string.format("res/image/%s",name)
end

function global.getParticlePath(particle)
	return string.format("res/particles/%s.plist",particle)
end

--------------------------------Sprite-----------------------------
function global.newSprite(target, filename)
	local sp = cc.Sprite:create(filename)
	sp:setAnchorPoint(AnchorPoint.Center)
	if target then target:addChild(sp) end
	return sp
end

function global.newSpriteWithFrameName(target, filename)
	local sp = cc.Sprite:createWithSpriteFrameName(filename)
	sp:setAnchorPoint(AnchorPoint.Center)
	if target then target:addChild(sp) end
	return sp
end

--------------------------------Cache-----------------------------
function global.getTextureCache()
	return global.director():getTextureCache()
end

function global.getSpriteFrameCache()
	return cc.SpriteFrameCache:getInstance()
end

function global.getAnimationCache()
	return cc.AnimationCache:getInstance()
end

--------------------------------Frames----------------------------
function global.newFrames(pattern, begin, length, isReversed)
    local frames = {}
    local step = 1
    local last = begin + length - 1
    if isReversed then
        last, begin = begin, last
        step = -1
    end

    for index = begin, last, step do
        local frameName = string.format(pattern, index)
        local frame = global.getSpriteFrameCache():getSpriteFrame(frameName)
        if not frame then
            printError("global.newFrames() - invalid frame, name %s", tostring(frameName))
            return
        end

        frames[#frames + 1] = frame
    end
    return frames
end

function global.newAnimation(frames, time)
    local count = #frames
    time = time or 1.0 / count
    return cc.Animation:createWithSpriteFrames(frames, time)
end

function global.setAnimationCache(name, animation)
	global.getAnimationCache():addAnimation(animation, name)
end

function global.getAnimationFromCache(name)
	return global.getAnimationCache():getAnimation(name)
end

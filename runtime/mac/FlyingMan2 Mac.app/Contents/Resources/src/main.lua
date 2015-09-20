
require "Cocos2d"
require "AudioEngine"
require "src.config.constant"
require "src.common.globalFunc"
require "src.base.BasePhysicsScene"
require "src.base.BaseScene"
require "src.base.BaseLayer"

-- cclog
cclog = function(...)
    print(...)
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function collectGarbage()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
end

local function setSearchPaths()
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
end

local function setWinsizeAdapted()
    local glview = global.getOpenGLView()
    local screenSize = glview:getFrameSize()
    local designSize = cc.size(480,320)
    local resourceSize = cc.size(960,640)
    if screenSize.width > 960 then
        designSize = cc.size(568,320)
    end
    global.director():setContentScaleFactor(resourceSize.width/designSize.width)
    glview:setDesignResolutionSize(designSize.width, designSize.height, cc.ResolutionPolicy.FIX_WIDTH)
end

local function createGameScene()
    local gameScene = require("src.ui.scene.GameScene").create()
    global.runScene(gameScene)
end

local function main()
    collectGarbage()
    setSearchPaths()
    setWinsizeAdapted()
    createGameScene()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end

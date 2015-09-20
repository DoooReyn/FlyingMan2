require "src.init"

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
    local frameSize = glview:getFrameSize()
    local fw,fh = frameSize.width, frameSize.height
    local scaleX,scaleY = fw/CONFIG_SCREEN_WIDTH, fh/CONFIG_SCREEN_HEIGHT
    global.director():setContentScaleFactor(scaleY)
    glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.FIXED_HEIGHT)
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

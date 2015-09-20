--
-- Created by IntelliJ IDEA.
-- User: Reyn
-- Date: 15/9/7
-- Time: 下午11:49
-- To change this template use File | Settings | File Templates.
--

CONFIG_SCREEN_WIDTH  = 480
CONFIG_SCREEN_HEIGHT = 320

AudioType = {Music = 0, Effect = 1, }

TouchType = {
    Began = ccui.TouchEventType.began,
    Ended = ccui.TouchEventType.ended,
    Move  = ccui.TouchEventType.move,
    Canceled = ccui.TouchEventType.canceled,
}

AnchorPoint = {
    Origin  = cc.p(0,0),
    Left    = cc.p(0,0.5),
    Right   = cc.p(0.5,0),
    Center  = cc.p(0.5,0.5),
}

ZORDER_LAYOUT_BG  = -4
ZORDER_DISTANT_BG = -3
ZORDER_NEARBY_BG  = -2
ZORDER_TILEMAP_BG = -1

MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

GROUND_TAG   = 1
HEART_TAG    = 2
BIRD_TAG     = 3
AIRSHIP_TAG  = 4
PLAYER_TAG   = 5

PROGRESS_TIMER_RADIAL = 0
PROGRESS_TIMER_BAR    = 1

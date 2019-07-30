
--
-- Author: garry
-- Date: 2017-2-23
--

local RoomListLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.plaza.RoomListLayer")

local GameRoomListLayer = class("GameRoomListLayer", RoomListLayer)
--游戏房间列表

function GameRoomListLayer:ctor(scene, frameEngine, isQuickStart)
    GameRoomListLayer.super.ctor(self, scene, isQuickStart)
    self._frameEngine = frameEngine
end

function GameRoomListLayer:onEnterRoom( frameEngine )
    print("自定义房间进入")
    if nil ~= frameEngine and frameEngine:SitDown(yl.INVALID_TABLE,yl.INVALID_CHAIR) then
        return true
    end
end

return GameRoomListLayer
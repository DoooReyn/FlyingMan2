EventDispatcher = class("EventDispatcher")
local _INSTANCE = nil
EventDispatcher.__index = EventDispatcher

function EventDispatcher:getInstance()
    if _INSTANCE == nil then
        _INSTANCE = EventDispatcher.new()
    end
    return _INSTANCE
end

function EventDispatcher:ctor()
    self.eventArray = {}
end

function EventDispatcher:dispatcherEvent(eventName,data)
    print("expect dispatcherEvent:"..eventName)
    local dispatcherEventCount = 0
    for i, v in pairs(self.eventArray) do
        if v.event == eventName then
            if v.callfunc then
                dispatcherEventCount = dispatcherEventCount + 1
                v.callfunc(eventName,data)
                print("in fact postUIMessage:"..eventName)
            else
                print("in fact can not postUIMessage:"..eventName)
            end
        end
    end
    print("eventName:"..eventName..",dispatcherEventCount:"..dispatcherEventCount)
end

function EventDispatcher:addEventListener(eventName,listener)
    for i, v in pairs(self.eventArray) do
    	if v.event == eventName and v.callfunc == listener then
    	   print("[error]: can not add eventListener")
    	   return
    	end
    end

    table.insert(self.eventArray,{event = eventName,callfunc = listener})
    print("EventDispatcher:addEventListener:"..eventName)
end

function EventDispatcher:removeEventListener(listener)
    if not listener then
        return
    end

    local ret = {}
    for i, v in pairs(self.eventArray) do
        if v~= nil and v.callfunc ~= listener  then
            table.insert(ret ,v)
        else
            print("EventDispatcher:removeUIResponse:"..v.event)
        end
    end

    self.eventArray = ret

end

function EventDispatcher:getEventListenerByName(eventName)
    local ret = {}
    for i, v in pairs(self.eventArray) do
    	if v.event == eventName and eventName ~= nil then
    	   table.insert(ret,v)
    	end
    end
    return ret
end

function EventDispatcher:clearListeners()
    print('EventDispatcher:clearListeners')
    self.eventArray = {}
end

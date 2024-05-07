local EventDispatcher = require "Framework.EventDispatcher"
local Singleton = Class("Singleton", EventDispatcher)
function Singleton:Ctor( ... )
	EventDispatcher.Ctor(self, ...)
end

function Singleton:Destroy()
	local metatable = getmetatable(self);
	if metatable ~= nil then	
		metatable._instance = nil;
	end	
end

function Singleton:HasInstance()
	return self._instance;
end

function Singleton:GetInstance(...)
	return Singleton.GetSingleton(self,...)	
end 

function Singleton:GetSingleton(...)
	if self._instance == nil then
		self._instance = self.New(...)
	end 
	return self._instance	
end 

function Singleton:GetInstanceNotCreate()
	return self._instance
end

------------------事件覆写----------------
--[[
	--原因：由于EventDispatcher中events属于self._instance , 当单例销毁后注册的事件消失，如果监听未销毁（未从新注册）
			会出现监听失效的情况。又由于有多个文件直接继承EventDispatcher，防止意外，在Singleton中覆写事件派发，不改变
			EventDispatcher结构。      ---yss
	--使用：和原来使用方法相同，只是派发事件回调参数第一个变为字符串， 若彻底清空事件表, 需调用Singleton.RemoveAllEventListener，可在登出时调用？
]]

local events = {};

function Singleton:AddEventListener(eType, eListener, passdata)
	if (not eType) or (not eListener) then
		if info then info("-------->there maybe something wrong in Singleton AddEventListener!")end
	 	return
	end

    if not events[eType] then
        events[eType] = setmetatable({},{__mode="v"});
    end

    if events[eType][eListener] then
    	if GameConfig.GAME_MOBILE_EDITOR == true then
    		if info then info("------>repeat register, eType:"..eType);end 
    	end
    end

	events[eType][eListener] = passdata or {};
end

function Singleton:DispatchEvent(eType, edata)
	if not eType then return end
	if not events[eType] then return end

	for eListener, passdata in pairs(events[eType]) do
		eListener(eType, edata, passdata);  --老结构不用改变，第一项参数改为派发的类型
	end
end

--谨慎使用，无eListener 清除此字符串所有监听
function Singleton:RemoveEventListener(eType, eListener)
	if not eType then
		if info then info("-------->there maybe something wrong in Singleton RemoveEventListener!")end
	 	return
	end
	if not events[eType] then
		if info then info("-------->there is no events to remove in Singleton RemoveEventListener, eventType :".. eType)end
	 	return
	end

	if not eListener then
		events[eType] = nil;
		return
	end

	if not events[eType][eListener] then
		return
	end

	events[eType][eListener] = nil;
end

function Singleton:HasEventListener(eType)
	if events and events[eType] then
		return true;
	end

	return false;
end

--登出可调用
function Singleton:RemoveAllEventListener()
	for eType, eListener in pairs(events) do
		eListener = nil;
	end
	events = {};
end

return Singleton    	
--[[
    UIManager 统一管理UI
-]]
require "UI.UIConfigManager";
require "UI.UIPoolManager";

local Singleton = require "FrameWork.Singleton";

UIManager = Class("UIManager", Singleton);
local M = UIManager;

function M:Ctor()
    Singleton.Ctor(self);
end

function M:Tick(delta)
	
end

function M:Init()
    LuaLog("UIManager Init");
    UIPoolManager:GetInstance():Init();
end

function M:Destroy()
    LuaLog("UIManager Destroy");
    UIPoolManager:GetInstance():Destroy();
end

function M:OpenDialog(m, args)
    if not m then
        return;
    end

    local ret = self:_Open(m, args);
    return ret;
end

function M:_Open(m, args)
    local instance = nil;
    instance = m:Open(args);
    --加到池子里

    return instance;
end


return M;
--[[
    TickManager 管理TickList
-]]
local Singleton = require "FrameWork.Singleton";

TickManager = Class("TickManager", Singleton);
local M = TickManager;

function M:Ctor()
    Singleton.Ctor(self);

    self.tickList = {};
end

function M:Tick(delta)
    if TableUtil.TableLength(self.tickList) <= 0 then
        return;
    end
end



return M;

--require ...
require "FrameWork.LuaDebugger";
require "Utils.TableUtils";

require "UI.UIManager";


GameMain = {};

LuaLog("########### Lua GameMain ##########")

--C#到Lua
function GameMain.Init()

    UIManager:GetInstance():Init();
    local test = require "UI.GameLogic.UITestDialog";
    UIManager:GetInstance():OpenDialog(test)
end

function GameMain.Tick(delta)
    
end

function GameMain.LateTick(delta)
    
end

function GameMain.FixedTick(delta)
    
end

function GameMain.Destroy()
    LuaLog("############# Lua GameMain Destroy #############");
    UIManager:GetInstance():Destroy();
end
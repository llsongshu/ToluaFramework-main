
--Lua 打日志
local function LuaLog(str)
    local result = tostring(str) ;
    Debug.Log("LuaLog日志::  " .. result);
end

--全局变量_G, 添加到_G中就可以全局访问
_G["LuaLog"] = LuaLog





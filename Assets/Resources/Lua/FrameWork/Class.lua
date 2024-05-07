--拷贝自cocos2d extern.lua文件中
--monitor = setmetatable({},{__mode="k"})
-- --只清理数据，不销毁单列的
-- noMonitorClasses = {
--     "ActivityManager",  --ActivityManager存在tickmanager延迟一帧删除的问题，需要延迟一帧才能回收(GuideManager也是一一樣的情況)
--     "GuideManager",
--     "PushManager",
--     "Application",
--     "LoginManager", 
--     "UIManager",
--     "CommMsgMgr",
--     "WorldMapManager",
--     "TextTipCtrl",
--     "DoubleTipCtrl",
--     "CommunicateMsgHandler",
--     "LocalSaveChatManager",
--     "BeanConfigManager",
--     "LoadingManager",
--     "TickerManager",
--     "SceneTeamManager",
--     "SceneManager",
--     "WarriorManager",
--     "PlayerManager",
--     "NpcManager",
--     "CameraContext",
-- }
function Clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function CloneCls(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            if type(value) ~= "function" then --and type(value) ~= "table"
                new_table[_copy(key)] = _copy(value)
            end
        end
        return setmetatable(new_table, object)
    end
    return _copy(object)
end

--拷贝自cocos2d extern.lua文件中，并修改及简化
--全局
function Class(classname, super)
    local cls
    -- inherited from Lua Object
    if super then
        cls = CloneCls(super)
        cls.super = super
        setmetatable(cls, super)
        --修改spuer可以为普通table
        if not cls.Ctor then
            cls.Ctor = function() end
        end
    else
        cls = {Ctor = function() end}
    end

    cls.__cname = classname
    cls.__ctype = 2 -- lua
    cls.__index = cls
    
    function cls.New(...)
        local instance = setmetatable({}, cls)
        instance.class = cls
        instance:Ctor(...)
    --    monitor[instance] = instance.__cname .."~~\n" ..debug.traceback();
        return instance
    end
    function cls.Create(...)
        return cls.New(...)
    end
    return cls
end


function ReusedClass(classname, super)
    local cls
    -- inherited from Lua Object
    if super then
        cls = CloneCls(super)
        cls.super = super
        --修改spuer可以为普通table
        if not cls.Ctor then
            cls.Ctor = function() end
        end
    else
        cls = {Ctor = function() end}
    end

    cls.__cname = classname
    cls.__ctype = 2 -- lua
    cls.__index = cls
    cls.__objects = setmetatable({},{__mode="v"})
    
    function cls.New(...)

        for k,v in pairs(cls.__objects) do
            cls.__objects[k] = nil
            v.isObjectRecycle = false;
            v:Ctor(...)
            return v
        end

        local instance = setmetatable({}, cls)
        instance.class = cls
        instance:Ctor(...)
        instance.isObjectRecycle = false;
    --    monitor[instance] = instance.__cname .."~~\n" ..debug.traceback();
        return instance
    end
    function cls.Create(...)
        return cls.New(...)
    end

    function cls.RecycleObject(self)
        if self.isObjectRecycle == true then
            if error then error("already has Recycle, object name = " .. self.__cname); end
            return;
        end
        self.isObjectRecycle = true;
        table.insert(cls.__objects,self)
    end
    return cls
end



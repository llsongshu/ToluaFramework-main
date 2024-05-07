--组件加载的功能
local UIBase = require "UI.UI_Base.UIBase";
UIComponentBase = Class("UIComponentBase",UIBase);
local M = UIComponentBase;

function M:Ctor()
    UIBase.Ctor(self);

    self.selfTransform = nil;

    self.isLoadTypeComponent = false;   --是否是加载类组件
    self.loadPath = nil;
    self.loaded = false;
    self.isLoading = false;
    self.loadOKCallback = nil;
    self.loader = nil;   --资源加载器
    
end

function M:Destroy()
    UIBase.Destroy(self);
    if self.loader then
        self.loader:Destroy();
        self.loader = nil;
    end
    
end

function M:DestroyGameObject()
    --if self.selfTransform and self.isLoadTypeComponent then
    --
    --end
    self.selfTransform = nil;
end

function M:LoadRes(path, loadedCallback)
    if path == nil or path == "" then
        LuaLog(self.__cname.."LoadRes path is nil.")
        return;
    end
    self.loadOKCallback = loadedCallback;
    --local action = System.Action

    --LuaLog(path)
    AssetLoader.Instance:Load(path, self.LoadResOK);

end

--加载完成回调
--function M:LoadResOK(prefab)
--    --self.selfTransform = prefab.transform;
--    self.isLoading = false;
--    self.loaded = true;
--end

--加载失败回调
function M:LoadResError()
end


return M;

--UI控件的基类
--1.显示与隐藏
--2.广播
--3.置灰
--4.坐标，层级
--5.周期方法 Parse Create Show Refresh

local UIComponentBase = require "UI.UI_Base.UIComponentBase";
UIComponent = Class("UIComponent", UIComponentBase);
local M = UIComponent;

function M:Ctor(selfTransform, args)
    UIComponentBase.Ctor(self);

    --初始化变量
    self.inited = false;

    self.parseArgs = nil;
    --
    self:Init(selfTransform, args);
end

function M:Init(selfTransform, args)
    if self.inited then return end

    self.inited = true;
    local unityTransform = nil;

    if selfTransform then   --如果是非加载的组件
        if type(selfTransform) == 'userdata' then  --transform在lua里的数据是userdata
            unityTransform = selfTransform;
            self.parseArgs = args;
        else

        end
    end

    if self.parseArgs then
        if type(self.parseArgs) == 'table' then

        end
        self:ParseArgs(self.parseArgs);
    end

    if unityTransform then
        self:OnPrepare(unityTransform);
    else
        self:LoadRes(self:GetPrefabPath());
    end
end

-----------------------------

function M:GetPrefabPath()
    return "";
end

function M:Parse(args)

end

function M:LoadResOK(prefab)
    if prefab == nil then
        if error then error("加载UIPrefab失败") end
    end
    self.selfTransform = prefab.transform;
    self:OnPrepare(prefab.transform);
    self.isLoading = false;
    self.loaded = true;
end

---------------继承方法------------------------

function M:BindUIComponent()
end

function M:MoveLayer()
    --设置self.root的父级
end

function M:OnPrepare(trans)
    self:GenChildPathMap(trans);
    self:BindUIComponent();
    self:MoveLayer();

    self:TryOnCreate();
    self:TryAddListener();

end

function M:Show(args)
    self:SetVisible(true)

    self:TryRefresh();
end

function M:Hide()
    self:SetVisible(false);
end

function M:SetVisible(show)
    if self.isVisible == show then
        return;
    end
    
    self.isVisible = show;
    self:RefreshVisible();
end

function M:RefreshVisible()
    if not self.root then return end
    self.root.gameObject:SetActive(self.isVisible);

    if (self.isVisible) then
    else
        
    end
end

-----------周期方法-------------
function M:OnCreate()
end

function M:AddListener()
end

function M:RemoveListener()
end

function M:OnShow()
end

function M:OnHide()
    self:Hide();
end

function M:OnRefresh()
end

function M:OnClose()
    self:Hide();
end

function M:TryErrorTrace(err)
    if error then
        error("handle a error :"..err)
    end
end

function M:TryOnCreate()
    xpcall(self.OnCreate, self.TryErrorTrace, self);
end
function M:TryAddListener()
    xpcall(self.AddListener, self.TryErrorTrace, self);
end
function M:TryRemoveListener()
    xpcall(self.RemoveListener, self.TryErrorTrace, self);
end
function M:TryOnShow()
    xpcall(self.OnShow, self.TryErrorTrace, self);
end
function M:TryOnHide()
    xpcall(self.OnHide, self.TryErrorTrace, self);
end
function M:TryRefresh()
    xpcall(self.OnRefresh, self.TryErrorTrace, self);
end
function M:TryOnClose()
    xpcall(self.OnClose, self.TryErrorTrace, self);
end

---------------------------------


return M;
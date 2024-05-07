--Dialog 基类

local UIComponent = require "UI.UI_Base.UIComponent";
UIDialog = Class("UIDialog", UIComponent);
local M = UIDialog;

function M:Ctor()
    self._name = nil;
    self._layer = nil;
    self._isClose = false;
end

--UIDialog为单例
function M:GetInstance()
    return self._instance;
end

--打开显示Dialog
function M:Open(args)
    if self:GetInstance() then
        self._instance:Show(args);
    else
        self._instance = self.New();
        self._instance:InitDialog(args);
    end

    if self._instance then

    end

    return self._instance;
end

function M:SetLayer()
    self._layer = "";
end

function M:BindUIComponent()
end

----------------------不对外方法------------------------------------
function M:InitDialog(args)
    UIComponent.Ctor(self, args)
end

function M:Show(args)
    UIComponent.Show(self, args)
end

function M:Hide()
    UIComponent.Hide(self);
end

function M:OnPrepare(transform)
    --self._name =
    local canvasRenderer = transform:GetComponent("CanvasRenderer");
    if not canvasRenderer then
        transform.gameObject:AddComponent(UnityEngine.CanvasRenderer.GetClassType())
    end

    local canvas = transform:GetComponent("Canvas");
    if not canvas then
        transform.gameObject:AddComponent(UnityEngine.Canvas.GetClassType())
    end

    local graphicRaycaster = transform:GetComponent("GraphicRaycaster");
    if not graphicRaycaster then
        transform.gameObject:AddComponent(UnityEngine.GraphicRaycaster.GetClassType())
    end

    UIComponent.OnPrepare(self, transform);
    UIPoolManager:GetInstance():PushPool(self)
end

function M:MoveLayer()
    UIComponent.MoveLayer(self);
end

--------------------周期方法------------------------------
function M:OnClose()
    UIComponent.OnClose(self);
    self._isClose = true;
    self._instance = nil;
end

function M:AddListener()
end

function M:RemoveListener()
end

return M;
--UI 容器
--储存当前UI 底下所有的child， path作为键

local Object = require "Framework.Object";
UIBase = Class("UIBase", Object);
local M = UIBase;

function M:Ctor()
    self.childNameMap = {};
end

function M:Destroy()
    self.childNameMap = nil;
end

function M:GenChildPathMap(transform)
    if not transform then
        if error then error("GenChildPathMap, transform can not be nil");
        end
    end
    self.root = transform;
    self.rootName = transform.name;

end

function M:GetTransformByPath(path)
    if self.root == nil or path == nil or path == "" then
        return nil;
    end

    if self.childNameMap[path] then
        return self.childNameMap[path];
    end

    if path == self.root.name then
        self.childNameMap[path] = self.root;
        return self.root;
    end

    local child = self.root:Find(path);
    if child then
        self.childNameMap[path] = child;
    end

    return child;
end

function M:GetChildByPath(path)
    local child = self:GetTransformByPath(path);
    if child == nil then
        if error then error("GetChildByPath not find child.") end
    end
    return child;
end

function M:GetComponentByPath(path, componentType)
    local child = self:GetChildByPath(path);
    local component = nil;
    if child then
        component = child:GetComponent(componentType);
    end

    if not component then
        if error then error("GetComponentByPath not find component.") end
    end

    return component;
end

function M:GetGameObjectByPath(path)
    local child = self:GetChildByPath(path);
    local go = nil;
    if child then
        go = child.gameObject;
    end

    if not go then
        if error then error("GetGameObjectByPath not find gameObject.") end
    end

    return go;
end

return M;
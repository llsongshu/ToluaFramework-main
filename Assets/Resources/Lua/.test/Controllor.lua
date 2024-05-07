--ToLua示例测试代码
Controllor = {}
local M = Controllor;

local GameObject = UnityEngine.GameObject;
local Input = UnityEngine.Input;
local Rigidbody = UnityEngine.Rigidbody;
local Time = UnityEngine.Time;

local sphere;
local rigid;

function M.Start()
    sphere = GameObject.Find("Sphere");
    rigid = sphere:AddComponent(typeof(Rigidbody));
end

function M.Update()
    local h = Input.GetAxis('Horizontal')
    local v = Input.GetAxis('Vertical')
    --rigid : AddForce(Vector3(h, 0, v))

    sphere.transform:Translate(Vector3(h,0,v) * Time.deltaTime);
end
using UnityEngine;
using System.Collections;
using LuaInterface;

/// <summary>
/// ToLua示范测试
/// </summary>
public class GameGo : MonoBehaviour {

    LuaState luaState = null;
    LuaFunction luaFunc = null;
    void Start()
    {
        new LuaResLoader();            //Lua加载器

        luaState = new LuaState();     //初始化Lua虚拟机
        luaState.Start();              //开启Lua虚拟机
        LuaBinder.Bind(luaState);      //向Lua虚拟机里注册C# Warp类

        string luaPath = Application.dataPath + "/Resources/Lua";
        luaState.AddSearchPath(luaPath);    //添加Lua目录地址
        luaState.DoFile("Controllor.lua");  //执行这个

        CallFunc("Controllor.Start", gameObject);
    }
    void Update()
    {
        CallFunc("Controllor.Update", gameObject);
    }

    void OnApplicationQuit()
    {
        luaState.Dispose();
        luaState = null;
    }

    void CallFunc(string func, GameObject obj)
    {
        luaFunc = luaState.GetFunction(func);
        luaFunc.Call(obj);
        luaFunc.Dispose();
        luaFunc = null;
    }
}

using UnityEngine;
using System.Collections;
using LuaInterface;

public class GameMain : MonoBehaviour {

    //--------------
    void Awake()
    {
        Init();
    }

    void Update()
    {

    }

    private void OnDestroy()
    {
        //Clear All Assetbundles
        Caching.CleanCache();
    }

    private void OnApplicationQuit()
    {
        if(gameObject!=null)
            CallLuaFunc("GameMain.Destroy", gameObject);
    }


    //-------------------
    LuaState lua = null;
    LuaFunction luaFunc = null;

    void Init()
    { 
        InitGame();

        InitSDK();

        InitLogger();

        //游戏更新
        GameUpdate();

        InitLua();

    }

    void InitGame()
    {
        DontDestroyOnLoad(gameObject);
    }

    void InitSDK()
    {

    }

    void InitLogger()
    {
        FileLogger.Init();
    }

    void GameUpdate()
    {

    }

    void InitLua()
    {
        new LuaResLoader();

        lua = new LuaState();
        lua.Start();
        LuaBinder.Bind(lua);

        string luaPath = Application.dataPath + "/Resources/Lua";
        lua.AddSearchPath(luaPath);

        lua.DoFile("UnityGlobalType.lua");
        lua.DoFile("FrameWork/LuaDebugger.lua");
        lua.DoFile("GameMain.lua");

        CallLuaFunc("GameMain.Init", gameObject);
    }

    void CallLuaFunc(string func, GameObject obj)
    {
        luaFunc = lua.GetFunction(func);
        luaFunc.Call(obj);
        luaFunc.Dispose();
        luaFunc = null;
    }
}

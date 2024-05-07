using UnityEngine;
using System.Collections;
using LuaInterface;

public class LuaLoadManager
{

    public static LuaLoadManager Instance;

    public LuaState Lua;
    public LuaLoadManager()
    {
        Instance = this;

        Lua = new LuaState();
    }
}

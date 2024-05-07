using UnityEngine;
using System.Collections;
using System;
using LuaInterface;

public class AssetLoader : MonoBehaviour
{

    public static AssetLoader Instance;

    private string loadPath;
    

    private void Awake()
    {
        Instance = this;
    }

    //----------Load Prefab-------------
    //private Action<GameObject> loadCallBack;

    private LuaFunction loadCallBack;
    //public void Load(string path, Action<GameObject> func)
    //{
    //    StartCoroutine(LoadAsset(path, func));
    //}

    public void Load(string path, LuaFunction func)
    {
        StartCoroutine(LoadAsset(path, func));
    }

    IEnumerator LoadAsset(string path, LuaFunction func)
    {
        loadPath = path;
        loadCallBack = func;

        ResourceRequest request = Resources.LoadAsync<GameObject>(path);
        yield return request;

        //加载完回调
        OnAssetLoaded(request);
    }

   //IEnumerator LoadAsset(string path, Action<GameObject> func)
   //{
   //    loadPath = path;
   //    loadCallBack = func;
   //
   //    ResourceRequest request = Resources.LoadAsync<GameObject>(path);
   //    yield return request;
   //
   //    //加载完回调
   //    OnAssetLoaded(request);
   //
   //}

    private void OnAssetLoaded(ResourceRequest request)
    {
        GameObject asset = request.asset as GameObject;
        if (asset == null)
        {
            Debugger.Log("asset 没加载上");
        }
        GameObject go = GameObject.Instantiate(asset);
        loadCallBack?.Call<Transform>(go.transform);    
    }


    //----------Load Sprite-------------
    private Action<Sprite> loadSpriteBack;
    public void LoadSprite(string path, Action<Sprite> func)
    {
        StartCoroutine(LoadSpriteAsset(path, func));
    }
    
    IEnumerator LoadSpriteAsset(string path, Action<Sprite> func)
    {
        loadPath = path;
        loadSpriteBack = func;

        ResourceRequest request = Resources.LoadAsync<Sprite>(path);
        yield return request;

        OnSpriteLoaded(request);
    }

    private void OnSpriteLoaded(ResourceRequest request)
    {
        Sprite sprite = request.asset as Sprite;
        loadSpriteBack?.Invoke(sprite);
    }
}

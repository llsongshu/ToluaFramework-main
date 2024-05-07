using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

/// <summary>
/// 将日志写入本地文件Outlog.txt中
/// </summary>
public class FileLogger 
{
    private static StreamWriter _streamWriter;
    private readonly static System.Object theLock = new System.Object();
    static string outPathTemp = "";
    static string outPath = "";
    static Queue<string> logQueue = new Queue<string>();
    static System.Threading.Thread logThread;
    static ILogHandler logHandler;

    public static void Init()
    {
        if (_streamWriter != null)
        {
            return;
        }

        outPathTemp = Application.persistentDataPath + "OutLogTemp.txt";
        outPath = Application.persistentDataPath + "OutLog.txt";

        //删除上次运行的日志
        try
        {
            if (File.Exists(outPathTemp))
            {
                File.Delete(outPathTemp);
            }

            if (File.Exists(outPath))
            {
                File.Move(outPath, outPathTemp);
            }
            else
            {
                using (FileStream fs = File.Create(outPath))
                { }
            }
        }
        catch (System.Exception)
        {
            Debug.Log("Init FileLogger failed.");
        }

        _streamWriter = new StreamWriter(outPath, true, Encoding.UTF8);

        //开启写入日志的线程
        CreateLogThread();

        //监听Unity系统错误、警告的事件
        logHandler = new MyLogHandler();

    }

    static void CreateLogThread()
    {
        if (logThread != null) { return; }

        logThread = new System.Threading.Thread(new System.Threading.ThreadStart(AsyncWriteLog));
        logThread.Priority = System.Threading.ThreadPriority.Lowest; //最低优先级
        logThread.Name = "LogThread";
        logThread.IsBackground = true;
        logThread.Start();
    }

    static void AsyncWriteLog()
    {
        while (true)
        {
            if (!string.IsNullOrEmpty(logBuffer))
            {
                _streamWriter.Write(logBuffer);
                _streamWriter.Flush();
                logBuffer = string.Empty;
            }
            System.Threading.Thread.Sleep(100);
        }
    }

    public static void HandleLog(string log)
    {
        AddToLogQueueAsync(DateTime.Now + log);
    }

    static void AddToLogQueueAsync(string log)
    {
        lock (theLock)
        {
             logQueue.Enqueue(log);
        }
    }

    static string _logBuffer = string.Empty;
    static string logBuffer
    {
        get
        {
            lock (theLock)
            {
                int raws = Mathf.Min(10, logQueue.Count);
                for (int i = 0; i < raws; i++)
                {
                    _logBuffer += logQueue.Dequeue() + "\n";
                }
                return _logBuffer;
            }
        }
        set
        {
            _logBuffer = value;
        }
    }
}

public class MyLogHandler : ILogHandler
{
    private ILogHandler defaultHandler;
    public MyLogHandler()
    {
#if UNITY_EDITOR
        defaultHandler = Debug.unityLogger.logHandler;
#endif
        Debug.unityLogger.logHandler = this;
    }

    public void LogException(Exception exception, UnityEngine.Object context)
    {
#if UNITY_EDITOR
        defaultHandler.LogException(exception, context);
#else
        //打出系统异常
        FileLogger.HandleLog("CSharp Exception: " + exception.Message);
#endif
    }

    public void LogFormat(LogType logType, UnityEngine.Object context, string format, params object[] args)
    {
#if UNITY_EDITOR
        defaultHandler.LogFormat(logType, context, format, args);
#else
        //打出系统警告和错误
        if(logType == LogType.Error || logType == LogType.Warning)
            FileLogger.HandleLog("CSharp Log: " + string.Format(format, args));
#endif
    }
}

public class GameLog
{
    public static void Log(string log)
    {
        if (string.IsNullOrEmpty(log)) { return; }
#if UNITY_EDITOR
        Debug.Log(log);
#endif

#if UNITY_IOS
        _IOSLog(log);   //NSLog
#endif
        FileLogger.HandleLog(log);
    }
}

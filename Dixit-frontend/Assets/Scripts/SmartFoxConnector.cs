using UnityEngine;
using System.Collections;
using Sfs2X;
using Sfs2X.Util;
using Sfs2X.Core;
using Sfs2X.Requests;
using System;

public partial class SmartFoxConnector : MonoBehaviour
{
    private Action LoginHandler;
    private Action CreateRoomHandler;
    private Action MessageHandler;

    private static SmartFoxConnector _smartFoxConnector;
    public static SmartFoxConnector Instance
    {
        get
        {
            if (_smartFoxConnector == null)
                _smartFoxConnector = new GameObject().AddComponent<SmartFoxConnector>();

            return _smartFoxConnector;
        }
    }

    private static SmartFox _smartFox;

    public static SmartFox Connection
    {
        get
        {
            if (_smartFoxConnector == null)
                _smartFoxConnector = new GameObject().AddComponent<SmartFoxConnector>();

            if (_smartFox == null)
            {
                _smartFox = new SmartFox();
                _smartFox.Debug = true;
            }

            return _smartFox;
        }
    }

    public static bool IsInitialized()
    {
        if (_smartFox == null)
            return false;
        return true;
    }

    void OnApplicationQuit()
    {
        if (_smartFox.IsConnected)
        {
            Debug.Log("Quit...");
            _smartFox.RemoveAllEventListeners();
            _smartFox.Disconnect();
        }
    }

    public SmartFoxConnector()
    {
        Debug.Log("SmartFoxInterface init");
        _smartFox = new SmartFox();
        _smartFox.Debug = true;

        _smartFox.AddEventListener(SFSEvent.CONNECTION, OnConnection);
        _smartFox.AddEventListener(SFSEvent.CONNECTION_LOST, OnConnectionLost);
        _smartFox.AddEventListener(SFSEvent.LOGIN, OnLogin);
        _smartFox.AddEventListener(SFSEvent.LOGIN_ERROR, OnLoginError);
        _smartFox.AddEventListener(SFSEvent.ROOM_VARIABLES_UPDATE, OnRoomVariableUpdate);
        _smartFox.AddEventListener(SFSEvent.ROOM_JOIN, OnRoomJoin);
        _smartFox.AddEventListener(SFSEvent.ROOM_JOIN_ERROR, OnRoomJoinError);
        _smartFox.AddEventListener(SFSEvent.USER_ENTER_ROOM, OnUserEnterRoom);
        _smartFox.AddEventListener(SFSEvent.USER_EXIT_ROOM, OnUserExitRoom);
        _smartFox.AddEventListener(SFSEvent.ROOM_ADD, OnRoomAdd);
        _smartFox.AddEventListener(SFSEvent.ROOM_CREATION_ERROR, OnRoomAddError);
        _smartFox.AddEventListener(SFSEvent.PUBLIC_MESSAGE, OnPublicMessage);
    }

    public void Connect()
    {
        ConfigData cfg = new ConfigData();
        cfg.Host = GameUtil.HOST;
        cfg.Port = GameUtil.PORT;
        cfg.Zone = GameUtil.ZONE;
        _smartFox.Connect(cfg);
        Debug.Log("CONNECT");
    }

    public void Login(string name, string password = null, Action complete = null)
    {
        _smartFox.Send(new LoginRequest(name));
        LoginHandler += complete;
    }

    public void CreateRoom(RoomSettings settings, Action complete = null)
    {
        _smartFox.Send(new CreateRoomRequest(settings));
    }

    void Update()
    {
        if (_smartFox != null)
            _smartFox.ProcessEvents();
    }
}


public partial class SmartFoxConnector
{
    void OnConnection(BaseEvent e)
    {
        Debug.Log("OnConnection");
        if ((bool)e.Params["success"])
        {
            Debug.Log("Connection Success!");
        }
        else
        {
            Debug.Log("Connection Failure: " + e.Params["errorMessage"]);
        }
    }

    void OnConnectionLost(BaseEvent e)
    {

    }

    void OnLogin(BaseEvent e)
    {
        Debug.Log("OnLogin");
        LoginHandler();
    }

    void OnLoginError(BaseEvent e)
    {

    }

    public void OnRoomJoin(BaseEvent e)
    {

    }

    public void OnRoomJoinError(BaseEvent e)
    {

    }

    public void OnUserEnterRoom(BaseEvent e)
    {

    }

    public void OnUserExitRoom(BaseEvent e)
    {

    }

    public void OnRoomAdd(BaseEvent e)
    {

    }

    public void OnRoomAddError(BaseEvent e)
    {

    }

    public void OnPublicMessage(BaseEvent e)
    {

    }

    public void OnRoomVariableUpdate(BaseEvent e)
    {

    }
}
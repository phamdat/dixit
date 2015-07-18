using UnityEngine;
using System.Collections;

using Sfs2X;
using Sfs2X.Core;
using Sfs2X.Entities;
using Sfs2X.Entities.Data;
using Sfs2X.Util;
using Sfs2X.Requests;
using Sfs2X.Entities.Variables;
using System;
using System.Collections.Generic;
using Newtonsoft.Json;

public enum TaskType
{
    ServerConnect,
    ServerDisconnect,
    Login,
    JoinRoom,
    LeaveRoom,
    RoomAdd,
    RoomFind,
}

public class NetworkEventArgs : EventArgs
{
    public Exception Exception { get; set; }

    public NetworkEventArgs(string exception)
    {
        if (!string.IsNullOrEmpty(exception))
            Exception = new Exception(exception);
    }
}

public class RoomEventArgs : NetworkEventArgs
{
    public RoomEventArgs(Room room, string exception)
        : base(exception)
    {
        this.Room = room;
    }

    public Room Room { get; private set; }
}

public class RoomAddEventArgs : RoomEventArgs
{
    public RoomAddEventArgs(Room room, string exception = null)
        : base(room, exception)
    {

    }
}
public class RoomRemoveEventArgs : RoomEventArgs
{
    public RoomRemoveEventArgs(Room room, string exception = null)
        : base(room, exception)
    {

    }
}

public class UserEnterRoomEventArgs : RoomEventArgs
{
    public User User { get; set; }
    public UserEnterRoomEventArgs(User user, Room room, string exception)
        : base(room, exception)
    {
        this.User = user;
    }
}

public class Network
{
    private static Network _instance;
    public static Network Instance
    {
        get
        {
            if (_instance == null)
                _instance = new Network();

            return _instance;
        }
    }

    public List<Room> Rooms { get { return _smartFox.RoomList; } }

    private SmartFox _smartFox;
    private Dictionary<TaskType, Action<Exception>> _pendingCallbacks;
    private Dictionary<string, Action<ISFSObject, Exception>> _extensionCallbacks;

    private event EventHandler<RoomAddEventArgs> _roomAdded;
    public event EventHandler<RoomAddEventArgs> RoomAdded
    {
        add { _roomAdded += value; }
        remove { _roomAdded -= value; }
    }

    private event EventHandler<RoomRemoveEventArgs> _roomRemoved;
    public event EventHandler<RoomRemoveEventArgs> RoomRemoved
    {
        add { _roomRemoved += value; }
        remove { _roomRemoved -= value; }
    }

    private event EventHandler<UserEnterRoomEventArgs> _userEntered;
    public event EventHandler<UserEnterRoomEventArgs> UserEntered
    {
        add { _userEntered += value; }
        remove { _userEntered -= value; }
    }

    public Network()
    {
        _smartFox = SmartFoxConnection.Connection;
        _pendingCallbacks = new Dictionary<TaskType, Action<Exception>>();
        _extensionCallbacks = new Dictionary<string, Action<ISFSObject, Exception>>();
    }

    public void Update()
    {
        ProcessEvents();
    }

    private void ProcessEvents()
    {
        if (_smartFox != null)
        {
            _smartFox.ProcessEvents();
        }
    }

    private void ExecuteAndRemoveCallback(TaskType taskType, Exception ex)
    {
        Action<Exception> callback;

        if (_pendingCallbacks.TryGetValue(taskType, out callback))
        {
            if (callback != null)
                callback(ex);

            _pendingCallbacks.Remove(taskType);
        }
    }

    private void ExecuteAndRemoveExtCallback(string cmd,ISFSObject data, Exception ex)
    {
        Action<ISFSObject, Exception> callback;
        if (_extensionCallbacks.TryGetValue(cmd, out callback))
        {
            if (callback != null)
                callback(data, ex);
            _extensionCallbacks.Remove(cmd);
        }
    }

    void SmartFoxConnect()
    {
        ConfigData cfg = new ConfigData();
        cfg.Host = GameUtil.HOST;
        cfg.Port = GameUtil.PORT;
        cfg.Zone = GameUtil.ZONE;
        _smartFox.Connect(cfg);
    }

    public void Connect(Action<Exception> callback = null)
    {
        // Reset the status. 
        _pendingCallbacks[TaskType.ServerConnect] = callback;

        _smartFox = new SmartFox();

        // Setup all the callbacks.
        RegisterEventListeners();

        // Finally connect.
        SmartFoxConnect();
    }

    public void Login(string username, string password = null, Action<Exception> callback = null)
    {
        _pendingCallbacks[TaskType.Login] = callback;
        _smartFox.Send(new LoginRequest(username));
    }

    public void JoinRoom(Room room, Action<Exception> callback = null)
    {
        _pendingCallbacks[TaskType.JoinRoom] = callback;
        _smartFox.Send(new JoinRoomRequest(room.Id));
    }

    public List<Room> GetAllRoom()
    {
        return _smartFox.RoomList;
    }

    public void CreateRoom(Action<Exception> callback = null)
    {
        _pendingCallbacks[TaskType.RoomAdd] = callback;
        var room = new RoomSettings(string.Format("room {0} ", Rooms.Count + 1));
        room.IsGame = true;
        room.MaxUsers = 10;

        _smartFox.Send(new CreateRoomRequest(room));
    }

    public void SendExtension(string cmd, SFSObject data = null, Room room = null, Action<ISFSObject, Exception> callback = null)
    {
        _extensionCallbacks[cmd] = callback;

        if (room != null)
            _smartFox.Send(new ExtensionRequest(cmd, data, room, false));
        else
            _smartFox.Send(new ExtensionRequest(cmd, data));
    }

    private void RegisterEventListeners()
    {
        _smartFox.RemoveAllEventListeners();

        _smartFox.AddEventListener(SFSEvent.CONNECTION, OnConnection);
        _smartFox.AddEventListener(SFSEvent.CONNECTION_LOST, OnConnectionLost);
        _smartFox.AddEventListener(SFSEvent.LOGIN, OnLogin);
        _smartFox.AddEventListener(SFSEvent.LOGIN_ERROR, OnLoginError);

        _smartFox.AddEventListener(SFSEvent.ROOM_JOIN, OnRoomJoin);
        _smartFox.AddEventListener(SFSEvent.ROOM_JOIN_ERROR, OnRoomJoinError);
        _smartFox.AddEventListener(SFSEvent.ROOM_ADD, OnRoomAdd);
        _smartFox.AddEventListener(SFSEvent.ROOM_CREATION_ERROR, OnRoomCreationError);
        _smartFox.AddEventListener(SFSEvent.ROOM_FIND_RESULT, OnRoomFindResult);
        _smartFox.AddEventListener(SFSEvent.ROOM_REMOVE, OnRoomRemove);
        _smartFox.AddEventListener(SFSEvent.USER_ENTER_ROOM, UserEnterRoom);

        _smartFox.AddEventListener(SFSEvent.EXTENSION_RESPONSE, OnExtensionResponse);
    }

    #region SmartFox event handler
    void OnConnection(BaseEvent evt)
    {
        bool success = (bool)evt.Params["success"];
        string reason = (string)evt.Params["reason"];

        if (success)
        {
            ExecuteAndRemoveCallback(TaskType.ServerConnect, null);
        }
        else
        {
            Debug.Log("SOMETHING WRONG WITH CONNECTION");
            ExecuteAndRemoveCallback(TaskType.ServerConnect, new Exception(reason));
        }
    }

    void OnConnectionLost(BaseEvent evt)
    {
        string reason = (string)evt.Params["reason"];
        Debug.Log("CONNECTION FAILED: " + reason);
        //ExecuteAndRemoveCallback(TaskType.ServerDisconnect, new Exception(reason));
    }

    void OnLogin(BaseEvent evt)
    {
        var user = evt.Params["user"];
        var data = evt.Params["data"];
        if (user != null)
        {
            Debug.Log("LOGIN");
            ExecuteAndRemoveCallback(TaskType.Login, null);
        }
    }

    void OnLoginError(BaseEvent e)
    {
        string errorMessage = e.Params["errorMessage"].ToString();
        string errorCode = e.Params["errorCode"].ToString();
        Debug.Log(string.Format("CONNECTION FAILED: {0} ---- code {1}", errorMessage, errorCode));
        ExecuteAndRemoveCallback(TaskType.Login, new Exception(errorMessage));
    }

    void OnRoomJoin(BaseEvent evt)
    {
        Room room = (Room)evt.Params["room"];
        if (room != null)
        {
            Debug.LogError("Room Joined");
            ExecuteAndRemoveCallback(TaskType.JoinRoom, null);
        }
    }

    void OnRoomJoinError(BaseEvent evt)
    {
        string errorMessage = evt.Params["errorMessage"].ToString();
        ExecuteAndRemoveCallback(TaskType.JoinRoom, new Exception(errorMessage));
    }

    void OnRoomAdd(BaseEvent e)
    {
        Room room = (Room)e.Params["room"];
        if (room != null)
        {
            Debug.Log("Room created");
            _roomAdded(this, new RoomAddEventArgs(room));
        }
    }

    void OnRoomCreationError(BaseEvent e)
    {
        string errorMessage = e.Params["errorMessage"].ToString();
        string errorCode = e.Params["errorCode"].ToString();

        Debug.Log(string.Format("Room created failed: {0} ---- code {1}", errorMessage, errorCode));
        _roomAdded(this, new RoomAddEventArgs(null, errorMessage));
    }

    void OnRoomFindResult(BaseEvent evt)
    {
        List<Room> rooms = (List<Room>)evt.Params["rooms"];
        ExecuteAndRemoveCallback(TaskType.RoomFind, null);
    }

    void OnRoomRemove(BaseEvent e)
    {
        Room room = (Room)e.Params["room"];
        if (room != null)
        {
            _roomRemoved(this, new RoomRemoveEventArgs(room, null));
        }
    }

    void UserEnterRoom(BaseEvent e)
    {
        User user = (User)e.Params["user"];
        Room room = (Room)e.Params["room"];

        _userEntered(this, new UserEnterRoomEventArgs(user, room, null));
    }

    void OnExtensionResponse(BaseEvent e)
    {
        string cmd = e.Params["cmd"].ToString();
        switch (cmd)
        {
            case "draw_card":
                ISFSObject responseParams = (ISFSObject)e.Params["params"];
                //var str = responseParams.GetUtfString("response");
                //Debug.Log("str: " + str);
                //var obj = JsonConvert.DeserializeObject<DrawCardResponse>(str);
                //Debug.Log("obj: " + obj.Cards.Count);
                ExecuteAndRemoveExtCallback(cmd, responseParams, null);
                break;
        }
    }
    #endregion
}

using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using Sfs2X.Requests;
using Sfs2X;
using Sfs2X.Core;
using Sfs2X.Entities;
using System.Collections.Generic;
using System;

public class RoomsController : BaseController
{
    public GameObject roomPrefab;
	public GameObject roomsHolder;

    private Action<Room> CreateRoomComplete;

    public Room selectedRoom { get; set; }

    protected override void Start()
    {
        base.Start();

        GetAllRooms();
    }

    protected override void RegisterHandler()
    {
        base.RegisterHandler();

        _smartFox.AddEventListener(SFSEvent.ROOM_JOIN, OnRoomJoin);
        _smartFox.AddEventListener(SFSEvent.ROOM_JOIN_ERROR, OnRoomJoinError);
        _smartFox.AddEventListener(SFSEvent.ROOM_ADD, OnRoomAdd);
        _smartFox.AddEventListener(SFSEvent.ROOM_CREATION_ERROR, OnRoomCreationError);
        _smartFox.AddEventListener(SFSEvent.ROOM_FIND_RESULT, OnRoomFindResult);
        _smartFox.AddEventListener(SFSEvent.ROOM_REMOVE, OnRoomRemove);
    }

    #region SmartFox Event Handler
    private void OnRoomJoin(BaseEvent e)
    {
        Room room = (Room)e.Params["room"];
        if (room != null)
        {
            Debug.LogError("Room Joined");
            UserService.currentRoom = room;
        }
    }
    private void OnRoomJoinError(BaseEvent e) { }

    private void OnRoomAdd(BaseEvent e)
    {
        Room room = (Room)e.Params["room"];
        if (room != null)
        {
            Debug.Log("Room created");

            CreateRoomUIComponent(room);

            CreateRoomComplete(room);
        }
    }

    private void OnRoomCreationError(BaseEvent e)
    {
        string errorMessage = e.Params["errorMessage"].ToString();
        string errorCode = e.Params["errorCode"].ToString();

        Debug.Log(string.Format("Room created failed: {0} ---- code {1}", errorMessage, errorCode));
    }
    private void OnRoomFindResult(BaseEvent e)
    {
        List<Room> rooms = (List<Room>)e.Params["rooms"];
        if (rooms != null && rooms.Count > 0)
        {
            // hien thi danh sach room
        }
    }

    private void OnRoomRemove(BaseEvent e)
    {
        Room room = (Room)e.Params["room"];
        if (room != null)
        {
            if (room.Id == UserService.currentRoom.Id)
            {
                // Room dang tham gia bi mat
            }

            // Xoa room tuong ung trong danh sach room
        }
    } 
    #endregion

    #region Private Method
    private void CreateRoomUIComponent(Room room)
    {
        var obj = Instantiate(roomPrefab);
        obj.transform.parent = roomsHolder.transform;
        obj.GetComponent<RoomPanelItemController>().QuitRoomEventHandler += (sender, args) => {

        };
        obj.GetComponent<RoomPanelItemController>().room = room;
    }

    private void CreateRoom()
    {
        var room = new RoomSettings("room 1");
        room.IsGame = true;
        room.MaxUsers = 10;

        _smartFox.Send(new CreateRoomRequest(room));
    }

    private void JoinRoom(Room room)
    {
        _smartFox.Send(new JoinRoomRequest(room.Id));
    }

    private void GetAllRooms()
    {
        var rooms = _smartFox.RoomList;
        Debug.LogError(rooms.Count);
        foreach (var room in rooms)
        {
            Debug.LogError(room);
            CreateRoomUIComponent(room);
        }
    } 
    #endregion

    #region UI Event Handler
    public void SelectRoom(GameObject roomGO)
    {
        var room = roomGO.GetComponent<RoomPanelItemController>().room;
        Debug.LogError(room);
        selectedRoom = room;
    }

    public void JoinGame()
    {
        JoinRoom(selectedRoom);
    }

    public void CreateGame()
    {
        CreateRoomComplete = (room) => { JoinRoom(room); };
        CreateRoom();
    }

    public void StartGame()
    {
        if (UserService.currentRoom != null && UserService.currentRoom.UserCount >= 3)
        {
            Application.LoadLevel(GameUtil.GAME_SCENCE);
        }
    }
    #endregion
}
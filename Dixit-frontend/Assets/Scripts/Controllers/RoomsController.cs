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

    private Action<RoomPanelItemController> CreateRoomComplete;

    public Room selectedRoom { get; set; }

    private RoomPanelItemController _selectedRoomController;
    public RoomPanelItemController selectedRoomController
    {
        get { return _selectedRoomController; }
        set
        {
            if (_selectedRoomController == value) return;

            _selectedRoomController = value;

            if (_selectedRoomController != null)
                selectedRoom = _selectedRoomController.room;
        }
    }

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
            selectedRoomController.NumberPlayerChanged();
        }
    }
    private void OnRoomJoinError(BaseEvent e) { }

    private void OnRoomAdd(BaseEvent e)
    {
        Room room = (Room)e.Params["room"];
        if (room != null)
        {
            Debug.Log("Room created");

            var go = CreateRoomUIComponent(room);
            CreateRoomComplete(go.GetComponent<RoomPanelItemController>());
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
    private GameObject CreateRoomUIComponent(Room room)
    {
        var obj = Instantiate(roomPrefab);
        obj.transform.parent = roomsHolder.transform;
        obj.GetComponent<RoomPanelItemController>().QuitRoom += (sender, args) => {

        };
        obj.GetComponent<RoomPanelItemController>().SelectRoom += (sender, args) => {
            selectedRoomController = sender as RoomPanelItemController;
            JoinGame();
        };

        obj.GetComponent<RoomPanelItemController>().room = room;

        return obj;
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
        selectedRoomController = roomGO.GetComponent<RoomPanelItemController>();
        Debug.LogError(selectedRoom);

        JoinGame();
    }

    public void JoinGame()
    {
        JoinRoom(selectedRoom);
    }

    public void CreateGame()
    {
        CreateRoomComplete = (roomController) => {
            selectedRoomController = roomController;
            JoinGame();
        };
        CreateRoom();
    }

    public void StartGame()
    {
        if (UserService.currentRoom != null && UserService.currentRoom.UserCount >= 2)
        {
            _smartFox.Send(new ExtensionRequest("", null, selectedRoom, true));
            Application.LoadLevel(GameUtil.GAME_SCENCE);
        }
    }
    #endregion
}
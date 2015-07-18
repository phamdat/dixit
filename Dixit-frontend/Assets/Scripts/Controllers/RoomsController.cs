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

    public List<GameObject> RoomGameObjects { get; set; }

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
        RoomGameObjects = new List<GameObject>();
        _network.RoomAdded += (sender, e) => {
            if(e.Exception != null)
            {
                return;
            }
            var go = CreateRoomUIComponent(e.Room);
            selectedRoomController = go.GetComponent<RoomPanelItemController>();
            JoinGame();
        };
        GetAllRooms();
    }

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
        
        RoomGameObjects.Add(obj);

        return obj;
    }

    private void CreateRoom()
    {
        var room = new RoomSettings(string.Format("room {0} ", _network.GetAllRoom().Count + 1));
        room.IsGame = true;
        room.MaxUsers = 10;
        
        _smartFox.Send(new CreateRoomRequest(room));
    }

    private void JoinRoom(Room room)
    {
        _network.JoinRoom(room, ex => {
            if(ex != null)
            {
                Debug.Log(ex.Message);
                return;
            }

            UserService.currentRoom = room;
            selectedRoomController.NumberPlayerChanged();
        });
    }

    private void GetAllRooms()
    {
        var rooms = _network.GetAllRoom();
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
        _network.CreateRoom(null);
    }

    public void StartGame()
    {
        if (UserService.currentRoom != null && UserService.currentRoom.UserCount >= 1)
        {
            Application.LoadLevel(GameUtil.GAME_SCENCE);
        }
    }
    #endregion
}
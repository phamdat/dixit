using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using Sfs2X.Requests;
using Sfs2X;
using Sfs2X.Core;
using Sfs2X.Entities;
using System.Collections.Generic;

public class MenuController : MonoBehaviour
{
    SmartFox _smartFox;

    void Awake()
    {
        _smartFox = SmartFoxConnection.Connection;

        RegisterHandler();
    }
        
    // Update is called once per frame
    void Update()
    {
        if (_smartFox != null)
            _smartFox.ProcessEvents();
    }

    private void RegisterHandler()
    {
        _smartFox.AddEventListener(SFSEvent.ROOM_JOIN, OnRoomJoin);
        _smartFox.AddEventListener(SFSEvent.ROOM_JOIN_ERROR, OnRoomJoinError);
        _smartFox.AddEventListener(SFSEvent.ROOM_ADD, OnRoomAdd);
        _smartFox.AddEventListener(SFSEvent.ROOM_CREATION_ERROR, OnRoomCreationError);
        _smartFox.AddEventListener(SFSEvent.ROOM_FIND_RESULT, OnRoomFindResult);
        _smartFox.AddEventListener(SFSEvent.ROOM_REMOVE, OnRoomRemove);
    }

    private void OnRoomJoin(BaseEvent e)
    {
        Room room = (Room)e.Params["room"];
        if (room != null)
        {
            UserService.currentRoom = room;
        }
    }
    private void OnRoomJoinError(BaseEvent e) { }
    private void OnRoomAdd(BaseEvent e)
    {
        Debug.Log("CREATE ROOM");
        Room room = (Room)e.Params["room"];
        if (room != null)
        {
            UserService.currentRoom = room;

            // Hien thi trong list room & disable join room
        }
    }
    private void OnRoomCreationError(BaseEvent e)
    {
        string errorMessage = e.Params["errorMessage"].ToString();
        string errorCode = e.Params["errorCode"].ToString();

        Debug.Log(string.Format("ROOM CREATE FAILED: {0} ---- code {1}", errorMessage, errorCode));
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

    public void JoinGame()
    {
        Debug.Log("JOIN GAME");
    }

    public void CreateGame()
    {
        Debug.Log("CREATE GAME");
        CreateRoom();
    }  

    private void CreateRoom()
    {
        var room = new RoomSettings("room 1");
        room.IsGame = true;
        room.MaxUsers = 10;

        _smartFox.Send(new CreateRoomRequest(room));
    }

    public void StartGame()
    {
        if (UserService.currentRoom != null && UserService.currentRoom.UserCount >= 3)
        {
            // bat dau game
            Application.LoadLevel(2);
        }
    }
}

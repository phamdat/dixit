using UnityEngine;
using UnityEngine.UI;

using System.Collections;
using Sfs2X.Entities;
using System;

public class RoomPanelItemController : MonoBehaviour
{
    private User _host;
    public User host
    {
        get { return _host; }
        set
        {
            if (_host == value) return;

            _host = value;
            hostName.text = _host.Name;
        }
    }

    private Room _room;
    public Room room
    {
        get { return _room; }
        set
        {
            if (_room == value) return;
            _room = value;
            numberOfPlayer.text = _room.UserCount.ToString();
        }
    }
    
    public Text hostName;
    public Text numberOfPlayer;
    public Button cancelButton;

    public event EventHandler QuitRoomEventHandler;
    

    public void QuitRoom()
    {
        var handle = QuitRoomEventHandler;
        if (handle != null)
            handle(this, null);
    }
}
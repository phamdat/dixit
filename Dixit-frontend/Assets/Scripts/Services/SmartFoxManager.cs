using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using Sfs2X.Requests;
using Sfs2X;
using Sfs2X.Core;
using Sfs2X.Entities;
using System.Collections.Generic;
using System;

public class SmartFoxManager : MonoBehaviour
{
    protected SmartFox _smartFox;

    void Awake()
    {
        _smartFox = SmartFoxConnection.Connection;

        RegisterHandler();
    }

    void RegisterHandler()
    {
        //_smartFox.AddEventListener(SFSEvent.ROOM_JOIN, OnRoomJoin);
        //_smartFox.AddEventListener(SFSEvent.ROOM_JOIN_ERROR, OnRoomJoinError);
        //_smartFox.AddEventListener(SFSEvent.ROOM_ADD, OnRoomAdd);
        //_smartFox.AddEventListener(SFSEvent.ROOM_CREATION_ERROR, OnRoomCreationError);
        //_smartFox.AddEventListener(SFSEvent.ROOM_FIND_RESULT, OnRoomFindResult);
        //_smartFox.AddEventListener(SFSEvent.ROOM_REMOVE, OnRoomRemove);
    }

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (_smartFox != null)
            _smartFox.ProcessEvents();
    }
}
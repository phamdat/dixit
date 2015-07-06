using System.Collections;

using UnityEngine;
using UnityEngine.UI;

using Sfs2X;
using Sfs2X.Util;
using Sfs2X.Core;
using Sfs2X.Requests;
using Sfs2X.Entities;

public class HomeController : BaseController
{
    public InputField nameField;

    protected override void RegisterHandler()
    {
        base.RegisterHandler();

        _smartFox.AddEventListener(SFSEvent.CONNECTION, OnConnection);
        _smartFox.AddEventListener(SFSEvent.CONNECTION_LOST, OnConnectionLost);
        _smartFox.AddEventListener(SFSEvent.LOGIN, OnLogin);
        _smartFox.AddEventListener(SFSEvent.LOGIN_ERROR, OnLoginError);

        SmartFoxConnect();
    }

    void OnConnection(BaseEvent e)
    {
        bool success = (bool)e.Params["success"];
        if (success)
        {
            Debug.Log("CONNECT");
        }
        else
        {
            Debug.Log("SOMETHING WRONG WITH CONNECTION");
        }
    }

    void OnConnectionLost(BaseEvent e)
    {
        string reason = e.Params["reason"].ToString();
        Debug.Log("CONNECTION FAILED: " + reason);
    }

    void OnLogin(BaseEvent e)
    {
        var user = e.Params["user"];
        var data = e.Params["data"];
        if (user != null)
        {
            UserService.currentUser = user as User;
            Application.LoadLevel(GameUtil.ROOM_LOBBY_SCENE);
            Debug.Log("LOGIN");
        }
    }

    void OnLoginError(BaseEvent e)
    {
        string errorMessage = e.Params["errorMessage"].ToString();
        string errorCode = e.Params["errorCode"].ToString();
        Debug.Log(string.Format("CONNECTION FAILED: {0} ---- code {1}", errorMessage, errorCode));
    }

    void SmartFoxConnect()
    {
        ConfigData cfg = new ConfigData();
        cfg.Host = GameUtil.HOST;
        cfg.Port = GameUtil.PORT;
        cfg.Zone = GameUtil.ZONE;
        _smartFox.Connect(cfg);
    }

    public void Connect()
    {
        string name = nameField.text;
        _smartFox.Send(new LoginRequest(name));
    }
}

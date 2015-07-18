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

    public void Connect()
    {
        string name = nameField.text;
        _network.Connect((ex) => {
            if (ex != null)
            {
                Debug.Log(ex.Message);
                return;
            }

            _network.Login(name, null, ex1 => {
                if (ex1 != null)
                {
                    Debug.Log(ex1.Message);
                    return;
                }
                Application.LoadLevel(GameUtil.ROOM_LOBBY_SCENE);
            });
        });
    }
}

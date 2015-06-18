using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using Sfs2X.Requests;

public class MenuController : MonoBehaviour
{

    public InputField nameField;

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void JoinGame()
    {
        Login();
        Debug.Log("JOIN GAME");
    }

    public void CreateGame()
    {
        Login();
        Debug.Log("CREATE GAME");
    }

    private void Login()
    {
        string name = nameField.text;

        SmartFoxConnector.Instance.Login(name, null, () => {
            Debug.Log("Login Complete");
        });
    }

    private void CreateRoom()
    {
        var room = new RoomSettings("room 1");
        room.IsGame = true;
        room.MaxUsers = 6;
        room.GroupId = "groupid";

        SmartFoxConnector.Instance.CreateRoom(room);
    }

    public void Connect()
    {
        SmartFoxConnector.Instance.Connect();
    }
}

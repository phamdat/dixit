using UnityEngine;
using System.Collections;
using Sfs2X;

public class SmartFoxConnection : MonoBehaviour
{

    private static SmartFoxConnection _smartFoxConnection;

    private static SmartFox _smartFox;
    public static SmartFox Connection
    {
        get
        {
            if (_smartFoxConnection == null)
                _smartFoxConnection = new GameObject("SmartFoxConnection").AddComponent<SmartFoxConnection>();

            if (_smartFox == null)
            {
                _smartFox = new SmartFox();
                _smartFox.Debug = true;
            }

            return _smartFox;
        }
    }

    void Awake()
    {
        DontDestroyOnLoad(this);
    }

    public static bool IsInitialized()
    {
        if (_smartFox == null)
            return false;
        return true;
    }

    void OnApplicationQuit()
    {
        if (_smartFox.IsConnected)
        {
            Debug.Log("Quit...");
            _smartFox.RemoveAllEventListeners();
            _smartFox.Disconnect();
        }
    }
}

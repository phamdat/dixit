using UnityEngine;
using System.Collections;
using Sfs2X;

public class BaseController : MonoBehaviour
{
    protected SmartFox _smartFox;

    protected Network _network;

    protected virtual void Awake()
    {
        //_smartFox = SmartFoxConnection.Connection;

        //RegisterHandler();

        _network = Network.Instance;
    }



    protected virtual void RegisterHandler()
    {
    }

    // Use this for initialization
    protected virtual void Start()
    {

    }

    // Update is called once per frame
    protected virtual void Update()
    {
        _network.Update();
        //if (_smartFox != null)
        //    _smartFox.ProcessEvents();
    }
}
using UnityEngine;
using System.Collections;
using Sfs2X;

public class BaseController : MonoBehaviour
{
    protected SmartFox _smartFox;

    protected virtual void Awake()
    {
        _smartFox = SmartFoxConnection.Connection;

        RegisterHandler();
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
        if (_smartFox != null)
            _smartFox.ProcessEvents();
    }
}
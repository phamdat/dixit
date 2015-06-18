using UnityEngine;
using System.Collections;
using Sfs2X;
using Sfs2X.Util;

public class HomeController : MonoBehaviour
{
    public void Connect()
    {
        SmartFoxConnector.Instance.Connect();
    }
}

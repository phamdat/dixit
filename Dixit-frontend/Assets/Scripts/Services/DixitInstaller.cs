using UnityEngine;
using System.Collections;
using Zenject;

public class DixitInstaller : MonoInstaller
{
    public override void InstallBindings()
    {
        //Container.Bind<SmartFoxConnection>().ToSingleGameObject("SmartFoxConnection");
        //Container.Bind<IUserService>().ToSingle<UserService>();
        Container.Bind<ITickable>().ToSingle<DixitRunner>();
        Container.Bind<IInitializable>().ToSingle<DixitRunner>();        
    }
}

public class DixitRunner : ITickable, IInitializable
{
    public void Initialize()
    {
        Debug.Log("Hello World");
    }

    public void Tick()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("Exiting!");
            Application.Quit();
        }
    }
}

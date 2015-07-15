using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Sfs2X.Core;

public class GameController : BaseController
{
    public GameObject _mainBoard;
    public GameObject _cardPanel;
    public GameObject _imageItem;
    
    private List<GameObject> _gameObjects;
    private GameObject _selectedCard;

    void Awake()
    {
        _gameObjects = new List<GameObject>(6);
    }

    protected override void Start()
    {
        base.Start();

        for (int i = 0; i < 6; i++)
        {
            var go = Instantiate(_imageItem);
            go.transform.SetParent(_cardPanel.transform);
            go.GetComponent<CardController>().SelectCard += (sender, arg) => {
                _selectedCard = (sender as CardController).gameObject;
                foreach (var card in _gameObjects)
                {
                    if (card != _selectedCard)
                        card.GetComponent<CardController>().OnDeselected();
                }
            };
            _gameObjects.Add(go);
        }
    }

    protected override void RegisterHandler()
    {
        base.RegisterHandler();

        _smartFox.AddEventListener(SFSEvent.OBJECT_MESSAGE, OnObjectMessage);
        _smartFox.AddEventListener(SFSEvent.PUBLIC_MESSAGE, OnPublicMessage);
        _smartFox.AddEventListener(SFSEvent.EXTENSION_RESPONSE, OnExtensionResponse);
    }

    void OnPublicMessage(BaseEvent e)
    {

    }

    void OnObjectMessage(BaseEvent e)
    {

    }

    void OnExtensionResponse(BaseEvent e)
    {

    }

    public void ChooseCard()
    {

    }
}
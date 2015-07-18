using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Sfs2X.Core;
using Sfs2X.Requests;
using Sfs2X.Entities.Data;
using Newtonsoft.Json;

public class Card
{
    [JsonProperty("id")]
    public string Id { get; set; }

    [JsonProperty("url")]
    public string Url { get; set; }
}

public class DrawCardResponse
{
    [JsonProperty("cards")]
    public List<Card> Cards { get; set; }
}

public class GameController : BaseController
{
    public GameObject _mainBoard;
    public GameObject _cardPanel;
    public GameObject _imageItem;
    
    private List<GameObject> _gameObjects;
    private GameObject _selectedCard;

    protected override void Awake()
    {
        base.Awake();
        _gameObjects = new List<GameObject>(6);
    }

    protected override void Start()
    {
        base.Start();

        for (int i = 0; i < 6; i++)
        {
            var go = Instantiate(_imageItem);
            go.transform.SetParent(_cardPanel.transform);
            var controller = go.GetComponent<CardController>();
            controller.ImageUrl = "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-frontend/Assets/Resources/Images/6.jpg";
            controller.SelectCard += (sender, arg) => {
                _selectedCard = (sender as CardController).gameObject;
                foreach (var card in _gameObjects)
                {
                    if (card != _selectedCard)
                        card.GetComponent<CardController>().OnDeselected();
                }
            };
            _gameObjects.Add(go);
        }
        
        Debug.Log("selected room: " + UserService.currentRoom);
        //SFSObject obj = new SFSObject();
        //_smartFox.Send(new ExtensionRequest("start_game", obj));
        _network.SendExtension("start_game", null, null, (data, ex) => {
            var str = data.GetUtfString("response");
            Debug.Log("str: " + str);
            var obj = JsonConvert.DeserializeObject<DrawCardResponse>(str);
            Debug.Log("obj: " + obj.Cards.Count);
        });
    }

    void DrawCard()
    {

    }
}
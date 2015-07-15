using UnityEngine;
using System.Collections;
using System;
using UnityEngine.UI;

public class CardController : MonoBehaviour
{
    public event EventHandler SelectCard;

    public GameObject border;

    private string _imageUrl;
    public string ImageUrl
    {
        get { return _imageUrl; }
        set
        {
            _imageUrl = value;
            LoadImage(_imageUrl);
        }
    }

    private RawImage _image;

    void Awake()
    {
        _image = gameObject.GetComponentInChildren<RawImage>();
    }

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void OnSelected()
    {
        border.SetActive(true);
        var handle = SelectCard;
        if (handle != null)
            handle(this, null);
    }

    public void OnDeselected()
    {
        border.SetActive(false);
    }

    private void LoadImage(string url)
    {
        StartCoroutine("StartLoadingImage");

    }

    IEnumerator StartLoadingImage()
    {
        if (string.IsNullOrEmpty(ImageUrl))
            yield break;

        WWW www = new WWW(ImageUrl);
        yield return www;
        _image.texture = www.texture;
    }
}
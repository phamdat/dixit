using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class LoadImageUrl : MonoBehaviour
{
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

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    void Awake()
    {
        _image = gameObject.GetComponentInChildren<RawImage>();
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
using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Net;
using System.Collections.Specialized;

namespace Vital.Game.Services
{
    public enum DataType
    {
        Normal = 0,
        Data
    }

    public class RestService : MonoBehaviour
    {
        public enum SendType
        {
            GET = 0,
            POST,
            PUT,
            UPDATE
        }

        //private readonly string ROOT = ServiceConfigs.ROOT;
        private readonly string ROOT = "";

        //private static RestService connector;
        //public static RestService instance
        //{
        //    get
        //    {
        //        if (connector == null)
        //            connector = new GameObject("RestService").AddComponent<RestService>() as RestService;
        //        return connector;
        //    }
        //}

        public void DoSomething(IEnumerator method)
        {
            StartCoroutine(method);
        }

        public void Get<T>(string url, Action<T, Exception> complete = null, DataType dataType = DataType.Normal) where T : class
        {
            StartCoroutine(SendRequest<T>(string.Format(ROOT + url), null, complete, SendType.GET, dataType));
        }

        public void Post<T>(string url, Dictionary<object, object> parameters = null, Action<T, Exception> complete = null, DataType dataType = DataType.Normal) where T : class
        {
            StartCoroutine(SendRequest<T>(string.Format(ROOT + url), parameters, complete, SendType.POST, dataType));
        }

        public void Put<T>(string url, Dictionary<object, object> parameters = null, Action<T, Exception> complete = null, SendType type = SendType.PUT, DataType dataType = DataType.Normal) where T : class
        {
            WebClient client = new WebClient();
            var values = new NameValueCollection();
            client.UploadValuesCompleted += (sender, e) => {

                complete(null, null);
            };
            client.UploadValuesAsync(new Uri(ROOT + url), "PUT", values);

        }

        protected IEnumerator SendRequest<T>(string url, Dictionary<object, object> parameters = null, Action<T, Exception> complete = null, SendType type = SendType.GET, DataType dataType = DataType.Normal) where T : class
        {
            Debug.Log(url);
            WWW w = null;
            if (type == SendType.GET)
            {
                w = new WWW(url);
            }
            else
            {
                WWWForm form = new WWWForm();
                foreach (var param in parameters)
                {
                    Debug.Log("param: " + param.Value);
                    if (param.Value is string)
                        form.AddField(param.Key.ToString(), param.Value.ToString());
                    else if (param.Value is int)
                        form.AddField(param.Key.ToString(), (int)param.Value);
                }

                w = new WWW(url, form);
            }

            while (!w.isDone)
            {
                Debug.Log("Receive data progress: " + w.progress);
                yield return null;
            }

            if (!string.IsNullOrEmpty(w.error))
            {
                Debug.Log(w.error);
                if (complete != null)
                    complete(null, new Exception(w.error));
            }
            else
            {
                if (dataType == DataType.Normal)
                {
                    Debug.Log("result: " + w.text);
                    var data = JsonConvert.DeserializeObject<T>(w.text);
                    if (complete != null)
                        complete(data, null);
                }
                else
                {
                    T data = w.bytes as T;
                    if (complete != null)
                        complete(data, null);
                }
            }
        }
    }
}
using UnityEngine;
using System.Collections;

public class GameUtil
{
    public static string HOST = "127.0.0.1";
    public static int PORT = 9933;
    public static string ZONE = "Dixit";

    public static string MENU_SCENE = "menu";
    public static string ROOM_LOBBY_SCENE = "room lobby";
    public static string GAME_SCENCE = "game";

    public static GameState GameState;    
}

public enum GameState
{
    Starting = 0,
    HostTurn,
    GuestTurn,
    GuessCard,
    WatchResult,
}
//
//  SFNetwork.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/13/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation

enum TaskType : Printable
{
    case ServerConnect
    case ServerDisconnect
    case Login
    case JoinRoom
    case LeaveRoom
    case RoomAdd
    case RoomRemove
    case RoomFind
    case LoadConfig
    case UserExitRoom
    case UserEnterRoom
    
    var description: String
    {
        switch self
        {
        case .ServerConnect: return "ServerConnect"
        case .ServerDisconnect: return "ServerDisconnect"
        case .UserEnterRoom: return "UserEnterRoom"
        case .UserExitRoom: return "UserExitRoom"
        case .RoomAdd: return "RoomAdd"
        case .RoomRemove: return "RoomRemove"
        case .Login: return "Login"
        case .JoinRoom: return "JoinRoom"
        case .RoomFind: return "RoomFind"
        case .LeaveRoom: return "LeaveRoom"
        default: return ""
        }
    }
}

public enum Result {
    case Success(AnyObject?)
    case Failure(String?)
}

//typealias EventHandler = ((TaskType, AnyObject?) -> ())?
typealias FuckEventHandler = ((AnyObject?) -> ())?

class EventHandlerWrapper
{
    var event: FuckEventHandler
    
    required init(e: FuckEventHandler)
    {
        event = e
    }
}


final class SFNetwork : NSObject, ISFSEvents
{
    static let sharedInstance = SFNetwork()
    
//    lazy var smartFox : SmartFox2XClient = { if return SmartFox2XClient(smartFoxWithDebugMode: true, delegate: self) }()
    var _smartFox : SmartFox2XClient?
    var smartFox : SmartFox2XClient
    {
        get
        {
            if _smartFox == nil
            {
                _smartFox = SmartFox2XClient(smartFoxWithDebugMode: true, delegate: self)
            }
            return _smartFox!
        }
    }    
    
    var pendingCallbacks = Dictionary<TaskType, Result -> ()>()
    var extensionCallbacks = Dictionary<String, (SFSObject?, Result) -> ()>()
    
    var rooms : [AnyObject]
    {
        get { return smartFox.roomList }
    }
    
    required override init()
    {
        super.init()
    }
    
    //MARK: - common methods
    
    func sendExtension(cmd : String, data : SFSObject?, room : Room?, callback : ((SFSObject?, Result) -> ()))
    {
        extensionCallbacks[cmd] = callback
        smartFox.send(ExtensionRequest(extCmd: cmd, params: data, room: nil, isUDP: false))
    }
    
//    func broadcastData(messageName: String, data: NSDictionary)
//    {
//        NSNotificationCenter.defaultCenter().postNotificationName(messageName, object: self, userInfo: data as [NSObject : AnyObject])
//    }
    
    func broadcastData(messageName: String, data: Dictionary<NSObject, AnyObject>)
    {
        NSNotificationCenter.defaultCenter().postNotificationName(messageName, object: self, userInfo: data)
    }
    
    func executeAndRemoveCallback(taskType : TaskType, result : Result) -> Bool
    {
        if let action = pendingCallbacks[taskType]
        {
            action(result)
            pendingCallbacks.removeValueForKey(taskType)
            return true
        }
        
        return false
    }
    
    func executeAndRemoveExtensionCallback(cmd: String, data: SFSObject?, result: Result) -> Bool
    {
        if let action = extensionCallbacks[cmd]
        {
            action(data, result)
            extensionCallbacks.removeValueForKey(cmd)
            return true
        }
        
        return false
    }
    
    //MARK: - action
    func start(callback : (Result -> ())?)
    {
        smartFox.logger.loggingLevel = LogLevel_DEBUG
        
        pendingCallbacks[TaskType.LoadConfig] = callback
        smartFox.loadConfig("config.xml", connectOnSuccess: false)
    }
    
    func connect(callback : (Result -> ())?)
    {
        pendingCallbacks[TaskType.ServerConnect] = callback
        smartFox.connect()
    }
    
    func joinRoom(room : Room, callback : (Result -> ())?)
    {
        pendingCallbacks[TaskType.JoinRoom] = callback
        if let request = JoinRoomRequest.requestWithId(room.name()) as? JoinRoomRequest
        {
            smartFox.send(request)
        }
    }
    
    func login(username : String, password : String, callback : (Result -> ())?)
    {
        pendingCallbacks[TaskType.Login] = callback
        smartFox.send(LoginRequest(userName: username, password: password, zoneName: "Dixit", params: nil))
    }
    
    func createRoom(roomName: String?, callback : (Result -> ())?)
    {
        pendingCallbacks[TaskType.RoomAdd] = callback
        var roomSettings: RoomSettings
        if let name = roomName
        {
            roomSettings = RoomSettings(name: roomName)
        }
        else
        {
            roomSettings = RoomSettings(name: "\(UserInfo.sharedInstance.currentUser?.name())'s Room")
        }
        
        roomSettings.isGame = true
        roomSettings.maxUsers = 10
        smartFox.send(CreateRoomRequest(roomSettings: roomSettings, autoJoin: true, roomToLeave: nil))
    }
    
    func leaveRoom(callback : (Result -> ())?)
    {
        pendingCallbacks[TaskType.LeaveRoom] = callback
        if let room = UserInfo.sharedInstance.currentRoom
        {
            if let request = LeaveRoomRequest.requestWithRoom(room) as? LeaveRoomRequest
            {
                smartFox.send(request)
            }
        }
    }
    
    func getUsers() -> [User]?
    {
        return UserInfo.sharedInstance.currentRoom?.playerList() as? [User]
    }
    
    func drawCard(callback: (SFSObject?, Result) -> ())
    {
        sendExtension("draw_card", data: SFSObject(), room: nil, callback: callback)
    }
    
    //MARK: - SFSEvent
    
    func onConfigLoadSuccess(evt: SFSEvent!) {
        executeAndRemoveCallback(TaskType.LoadConfig, result: Result.Success(nil))
    }
    
    func onConfigLoadFailure(evt: SFSEvent!) {
        let msg = (evt.params["message"] as? String)!
        println(msg)
        executeAndRemoveCallback(TaskType.LoadConfig, result: Result.Failure(msg))
    }
    
    func onConnection(evt: SFSEvent!) {
        let success : Bool = (evt.params["success"] as? Bool)!
        println("nhin ne \(success)")
        executeAndRemoveCallback(TaskType.ServerConnect, result: Result.Success(nil))
    }
    
    func onConnectionLost(evt: SFSEvent!) {
        let msg = (evt.params["reason"] as? String)
        println(msg)
        executeAndRemoveCallback(TaskType.Login, result: Result.Failure(msg))
    }
    
    func onLogin(evt: SFSEvent!) {
        let user = (evt.params["user"] as? User)        
        executeAndRemoveCallback(TaskType.Login, result: Result.Success(user))
    }
    
    func onLoginError(evt: SFSEvent!) {
        handleRequestError(evt, taskType: TaskType.Login)
    }
    
    func onRoomJoin(evt: SFSEvent!) {
        let msg = (evt.params["errorMessage"] as? String)
        println(msg)
        executeAndRemoveCallback(TaskType.JoinRoom, result: Result.Failure(msg))
    }
    
    func onUserExitRoom(evt: SFSEvent!) {
        println("onUserExitRoom")
        let room = (evt.params["room"] as? Room)
        let user = (evt.params["user"] as? User)
        executeAndRemoveCallback(TaskType.UserExitRoom, result: Result.Success(nil))
        broadcastData(TaskType.UserExitRoom.description, data:["room": room!])
    }
    
    func onUserEnterRoom(evt: SFSEvent!) {
        println("onUserEnterRoom")
        let room = (evt.params["room"] as! Room)
        let user = (evt.params["user"] as! User)
        executeAndRemoveCallback(TaskType.UserEnterRoom, result: Result.Success(nil))
        broadcastData(TaskType.UserEnterRoom.description, data: ["room": room])
    }
    
    func onRoomJoinError(evt: SFSEvent!) {
        println("join error")
        handleRequestError(evt, taskType: TaskType.JoinRoom)
    }
    
    func onRoomAdd(evt: SFSEvent!) {
        let room = evt.params["room"] as! Room
        
        if !executeAndRemoveCallback(TaskType.RoomAdd, result: Result.Success(room))
        {
            println("room added")
            broadcastData(TaskType.RoomAdd.description, data: ["room": room])
        }
    }
    
    func onRoomRemove(evt: SFSEvent!) {
        let room = evt.params["room"] as! Room
        
        if !executeAndRemoveCallback(TaskType.RoomRemove, result: Result.Success(room))
        {
            
            println("room removed")
            broadcastData(TaskType.RoomRemove.description, data: ["room": room])
        }
    }
    
    func onExtensionResponse(evt: SFSEvent!)
    {
        let cmd = evt.params["cmd"] as! String
        let params = evt.params["params"] as! SFSObject
        
        let response = params.getUtfString("response")
        
        var error: NSError?
        var jsonData: NSData = response.dataUsingEncoding(NSUTF8StringEncoding)!
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as! Dictionary<NSObject, AnyObject>
        self.broadcastData(cmd, data: jsonDict)
        
        executeAndRemoveExtensionCallback(cmd, data: nil, result: Result.Success(nil))
    }
    
    func handleRequestError(evt : SFSEvent!, taskType : TaskType)
    {
        let msg = (evt.params["errorMessage"] as? String)
        println(msg)
        executeAndRemoveCallback(taskType, result: Result.Failure(msg))
    }    
}
//
//  SFNetwork.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/13/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation

enum TaskType
{
    case ServerConnect
    case ServerDisconnect
    case Login
    case JoinRoom
    case LeaveRoom
    case RoomAdd
    case RoomFind
    case LoadConfig
}

public enum Result {
    case Success(AnyObject?)
    case Failure(String?)
}

class SFNetwork : NSObject, ISFSEvents
{
    static let sharedInstance = SFNetwork()
    
    lazy var smartFox : SmartFox2XClient = { return SmartFox2XClient(smartFoxWithDebugMode: true, delegate: self) }()
    
    var pendingCallbacks = Dictionary<TaskType, Result -> ()>()
    var extensionCallbacks = Dictionary<String, ((SFSObject, Result) -> ())?>()
    
    var incomingData : ((TaskType, AnyObject?) -> ())?

    var rooms : [AnyObject]
    {
        get { return smartFox.roomList }
    }
    
    required override init()
    {
        super.init()
    }
    
    func executeAndRemoveCallback(taskType : TaskType, result : Result)
    {
        let action = pendingCallbacks[taskType]
        if action != nil
        {
            action!(result)
            pendingCallbacks.removeValueForKey(taskType)
        }
    }
    
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
        smartFox.send(JoinRoomRequest(id: room.id()))
    }
    
    func login(username : String, password : String, callback : (Result -> ())?)
    {
        pendingCallbacks[TaskType.Login] = callback
        smartFox.send(LoginRequest(userName: username, password: password, zoneName: "Dixit", params: nil))
    }
    
    func createRoom(callback : (Result -> ())?)
    {
        pendingCallbacks[TaskType.RoomAdd] = callback
        let room = RoomSettings(name: "room \(rooms.count + 1)")
        room.isGame = true
        room.maxUsers = 10
        smartFox.send(CreateRoomRequest(roomSettings: room, autoJoin: true, roomToLeave: nil))
    }
    
    func sendExtension(cmd : String, data : SFSObject?, room : Room?, callback : ((SFSObject, Result) -> ()))
    {
        extensionCallbacks[cmd] = callback
        if room != nil
        {
            
        }
    }
    
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
        if user != nil
        {
            
        }
        
        executeAndRemoveCallback(TaskType.Login, result: Result.Success(nil))
    }
    
    func onLoginError(evt: SFSEvent!) {
        handleRequestError(evt, taskType: TaskType.Login)
    }
    
    func onRoomJoin(evt: SFSEvent!) {
        let msg = (evt.params["errorMessage"] as? String)
        println(msg)
        executeAndRemoveCallback(TaskType.Login, result: Result.Failure(msg))
    }
    
    func onRoomJoinError(evt: SFSEvent!) {
        handleRequestError(evt, taskType: TaskType.JoinRoom)
    }
    
    func onRoomAdd(evt: SFSEvent!) {
        let room = evt.params["room"] as? Room
        if room != nil
        {
            println("room added")
            if let action = incomingData
            {
                action(TaskType.RoomAdd, room)
            }
        }
        
        executeAndRemoveCallback(TaskType.RoomAdd, result: Result.Success(nil))
    }
    
    func handleRequestError(evt : SFSEvent!, taskType : TaskType)
    {
        let msg = (evt.params["errorMessage"] as? String)
        println(msg)
        executeAndRemoveCallback(taskType, result: Result.Failure(msg))
    }    
}
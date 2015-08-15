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
    case RoomRemove
    case RoomFind
    case LoadConfig
    case UserExitRoom
    case UserEnterRoom
}

public enum Result {
    case Success(AnyObject?)
    case Failure(String?)
}

final class SFNetwork : NSObject, ISFSEvents
{
    static let sharedInstance = SFNetwork()
    
    lazy var smartFox : SmartFox2XClient = { return SmartFox2XClient(smartFoxWithDebugMode: true, delegate: self) }()
    
    var pendingCallbacks = Dictionary<TaskType, Result -> ()>()
    var extensionCallbacks = Dictionary<String, ((SFSObject, Result) -> ())?>()
    
    var incomingData : Array<((TaskType, AnyObject?) -> ())?> = Array<((TaskType, AnyObject?) -> ())?>()

    var rooms : [AnyObject]
    {
        get { return smartFox.roomList }
    }
    
    required override init()
    {

        super.init()
    }
    
    func executeAndRemoveCallback(taskType : TaskType, result : Result) -> Bool
    {
        let action = pendingCallbacks[taskType]
        if action != nil
        {
            action!(result)
            pendingCallbacks.removeValueForKey(taskType)
            return true
        }
        
        return false
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
        if let request = JoinRoomRequest.requestWithId(room.name()) as? JoinRoomRequest
        {
            smartFox.send(request)
        }
    }
    
    func login(username : String, password : String, callback : (Result -> ())?)
    {
        pendingCallbacks[TaskType.Login] = callback
        smartFox.send(LoginRequest(userName: username, password: password, zoneName: "BasicExamples", params: nil))
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
        smartFox.send(CreateRoomRequest(roomSettings: roomSettings, autoJoin: true, roomToLeave: nil))    }
    
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
    }
    
    func onRoomJoinError(evt: SFSEvent!) {
        println("join error")
        handleRequestError(evt, taskType: TaskType.JoinRoom)
    }
    
    func onRoomAdd(evt: SFSEvent!) {
        let room = evt.params["room"] as? Room
        
        if !executeAndRemoveCallback(TaskType.RoomAdd, result: Result.Success(room))
        {
            if room != nil
            {
                println("room added")
                for action in incomingData
                {
                    if action != nil
                    {
                        action!(TaskType.RoomAdd, room)
                    }
                }
//                if let action = incomingData
//                {
//                    action(TaskType.RoomAdd, room)
//                }
            }
        }
    }
    
    func onRoomRemove(evt: SFSEvent!) {
        let room = evt.params["room"] as? Room        
        
        if !executeAndRemoveCallback(TaskType.RoomRemove, result: Result.Success(room))
        {
            
            println("room removed")
            for action in incomingData
            {
                if action != nil
                {
                    action!(TaskType.RoomRemove, room)
                }
            }

//            if let action = incomingData
//            {
//                action(TaskType.RoomRemove, room)
//            }
            
        }
    }
    
    func handleRequestError(evt : SFSEvent!, taskType : TaskType)
    {
        let msg = (evt.params["errorMessage"] as? String)
        println(msg)
        executeAndRemoveCallback(taskType, result: Result.Failure(msg))
    }    
}
//
//  CommandHelper.swift
//  MDNS
//
//  Created by 童世超 on 2024/7/15.
//

import UIKit

enum Command: String {
    case power  = "SRAF_KEY_RC_POWER"                   // Power
    case home  = "SRAF_KEY_RC_HOME"                     // Home
    case up = "SRAF_KEY_RC_UP"                          // Up
    case down = "SRAF_KEY_RC_DOWN"                      // Down
    case left = "SRAF_KEY_RC_LEFT"                      // Left
    case right = "SRAF_KEY_RC_RIGHT"                    // Right
    case enter = "SRAF_KEY_RC_ENTER"                    // OK
    case back = "SRAF_KEY_RC_BACK"                      // Back
    case menu = "SRAF_KEY_RC_MENU"                      // Menu
    case pageUp = "SRAF_KEY_RC_PAGE_UP"                 // Netflix
    case pageDown = "SRAF_KEY_RC_PAGE_DOWN"             // Youtube
    case update = "SRAF_KEY_RC_UPDATE"                  // Prime video
    case record = "SRAF_KEY_RC_RECORD"                  // OpenBrowser
    case volumeUp = "SRAF_KEY_RC_VOLUME_UP"             // Volume down
    case volumeDown = "SRAF_KEY_RC_VOLUME_DOWN"         // Volume up
    case volumeMute = "SRAF_KEY_RC_VOLUME_MUTE"         // Volume mute
    case channelUp = "SRAF_KEY_RC_CHANNEL_UP"           // Focus +
    case channelDown = "SRAF_KEY_RC_CHANNEL_DOWN"       // Focus -
}

enum EventType: String {
    case key = "keyEvent"
}

class EventHelper: NSObject {
    
    public static let shared = EventHelper()
    
    private override init() {}
    
    func sendEvent(type: EventType = .key, command: Command, socket: GCDAsyncSocket?) {
        guard let socket = socket else {
            print("socket can not nil")
            return
        }
        if type == .key {
            let eventData = EventData(type: type, command: command)
            guard let bodyData = eventData.data else {
                print("invalid data")
                return
            }
            var header = bodyData.count
            var headerData = Data(bytes: &header, count: eventData.headerLengh)
            headerData.reverse()
//            socket.write(headerData + bodyData, withTimeout: -1.0, tag: DataTag.header.rawValue)
            socket.write(headerData, withTimeout: -1.0, tag: DataTag.header.rawValue)
            socket.write(bodyData, withTimeout: -1.0, tag: DataTag.body.rawValue)
        } else {
            print("invalid EventType")
        }
    }
    
}

fileprivate struct EventData {
    
    private var type: EventType
    private var command: Command
    
    var headerLengh: Int { 4 }
    
    var data: Data? {
        let dict = [
            "etype": type.rawValue,
            "edata": command.rawValue
        ]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return nil
        }
        return bodyData
    }
    
    init(type: EventType, command: Command) {
        self.type = type
        self.command = command
    }
}

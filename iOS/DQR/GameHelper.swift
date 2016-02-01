//
//  GameHelper.swift
//  DQR
//
//  Created by Apple on 1/31/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import Foundation

class GameHelper {
    
    // Constants to define commands to send TO server.
    static let COMMAND_ADD_PLAYER: String = "a:"
    static let COMMAND_GET_SCORE: String = "s:"
    static let COMMAND_GET_TARGET: String = "t:"
    static let COMMAND_LIST_PLAYERS: String = "l:"
    static let COMMAND_PLAYER_SCAN: String = "n:"
    
    // Constants to define commands received FROM server.
    static let NOTIFY_PLAYER_SCORE: String = COMMAND_GET_SCORE
    static let NOTIFY_PLAYER_TARGET: String = COMMAND_GET_TARGET
    static let NOTIFY_PLAYER_LIST: String = COMMAND_LIST_PLAYERS
    static let NOTIFY_PLAYER_KILLED: String = "k:"
    
    /**
     * This function is called by NetHelper when a command is received from the server.
     * The command is then parsed and forwarded to the function for handling that command.
     */
    class func onServerCommandReceived(command: String) {
        
        // Split the command string into chunks of command[0]:arguments[1]
        let chunks = command.characters.split{$0 == ":"}.map(String.init)
        
        switch chunks[0] {
        case NOTIFY_PLAYER_SCORE:
            onNotifyPlayerScore(chunks[1])
            break;
        case NOTIFY_PLAYER_TARGET:
            onNotifyPlayerTarget(chunks[1])
            break;
        case NOTIFY_PLAYER_LIST:
            onNotifyPlayerList(chunks[1])
            break;
        case NOTIFY_PLAYER_KILLED:
            onNotifyPlayerKilled(chunks[1])
            break;
        default:
            print("Command \(command) not recognized.")
        }
    }
    
    /** 
     * Generates the command to register a player with the server.
     */
    class func executeAddPlayerCommand(playerName: String) {
        
        if playerName == "" {
            print("Player name invalid")
            return
        }
        NetHelper.getNetHelper().sendToServer(COMMAND_ADD_PLAYER + playerName)
    }
    
    /**
     * Generates the command to check a given player's score.
     */
    class func executeScoreCheckCommand(playerName: String) {
        
        if playerName == "" {
            print("Player name invalid")
            return
        }
        NetHelper.getNetHelper().sendToServer(COMMAND_GET_SCORE + playerName)
    }
    
    /**
     * Generates the command to check a given player's target.
     */
    class func executeTargetCheckCommand(playerName: String) {
        
        if playerName == "" {
            print("Player name invalid")
            return
        }
        NetHelper.getNetHelper().sendToServer(COMMAND_GET_TARGET)
    }
    
    /**
     * Generates the command to request a list of all players.
     */
    class func executeListCommand() {
        
        NetHelper.getNetHelper().sendToServer(COMMAND_LIST_PLAYERS)
    }
    
    /**
     * Generates the command to notify the server that a player has been attacked.
     */
    class func executeScanCommand(victim: String) {
        
        if victim == "" {
            
            print("Victim name cannot be blank")
            return
        }
        
        if victim.rangeOfString(":") != nil {
            
            print("Victim name cannot contain ':'")
            return
        }
        
        if victim.rangeOfString(",") != nil {
            
            print("Victim name cannot contain ','")
            return
        }
        
        NetHelper.getNetHelper().sendToServer(COMMAND_PLAYER_SCAN + victim)
    }
    
    class func onNotifyPlayerScore(playerScore: String) {
        
    }
    
    class func onNotifyPlayerTarget(playerScore: String) {
        
    }
    
    class func onNotifyPlayerList(playerList: String) {
        
    }
    
    class func onNotifyPlayerKilled(player: String) {
        
    }
}
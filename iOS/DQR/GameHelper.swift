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
     * Generates the command to register a player with the server.
     */
    class func getRegisterCommand(playerName: String) -> String? {
        
        if playerName == "" {
            print("Player name invalid")
            return nil
        }
        return COMMAND_ADD_PLAYER + playerName
    }
    
    /**
     * Generates the command to check a given player's score.
     */
    class func getScoreCheckCommand(playerName: String) -> String? {
        
        if playerName == "" {
            print("Player name invalid")
            return nil
        }
        return COMMAND_GET_SCORE + playerName
    }
    
    /**
     * Generates the command to check a given player's target.
     */
    class func getTargetCheckCommand(playerName: String) -> String? {
        
        if playerName == "" {
            print("Player name invalid")
            return nil
        }
        return COMMAND_GET_TARGET + playerName
    }
    
    /**
     * Generates the command to request a list of all players.
     */
    class func getListCommand() -> String {
        
        return COMMAND_LIST_PLAYERS
    }
    
    /**
     * Generates the command to notify the server that a player has been attacked.
     */
    class func getAttackCommand(victim: String) -> String? {
        
        if victim == "" {
            
            print("Victim name cannot be blank")
            return nil
        }
        
        if victim.rangeOfString(":") != nil {
            
            print("Victim name cannot contain ':'")
            return nil
        }
        
        if victim.rangeOfString(",") != nil {
            
            print("Victim name cannot contain ','")
            return nil;
        }
        
        return COMMAND_PLAYER_SCAN + victim;
    }
    
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
    
    class func onNotifyPlayerScore(playerScore: String) {
        
    }
    
    class func onNotifyPlayerTarget(playerScore: String) {
        
    }
    
    class func onNotifyPlayerList(playerList: String) {
        
    }
    
    class func onNotifyPlayerKilled(player: String) {
        
    }
}
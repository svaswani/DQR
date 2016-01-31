//
//  GameHelper.swift
//  DQR
//
//  Created by Apple on 1/31/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import Foundation

class GameHelper {
    
    static let COMMAND_ADD_PLAYER: String = "a:"
    static let COMMAND_GET_SCORE: String = "s:"
    static let COMMAND_GET_TARGET: String = "t:"
    static let COMMAND_LIST_PLAYERS: String = "l:"
    static let COMMAND_NOTIFY_ATTACK: String = "n:"
    
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
        
        return COMMAND_NOTIFY_ATTACK + victim;
    }
}
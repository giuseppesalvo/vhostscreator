//
//  ScriptsHelper.swift
//
//  Created by Giuseppe Salvo on 09/07/15.
//  Copyright (c) 2015 Giuseppe Salvo. All rights reserved.
//  giuseppesalvo@outlook.it
//

import Cocoa
import Foundation

class ScriptsController {
    
    // This function runs an apple script contains the shell command ( 1... or more )
    // Apple script natively ask you the password, without security framework
    // sudo commands works
    func run(inScript:String...) -> Bool {
        
        var script = ""
        for myscript in inScript {
            script += "do shell script \"\(myscript)\" with administrator privileges\n"
        }
        
        let appleScript = NSAppleScript(source: script)
        
        let result = appleScript!.executeAndReturnError( nil ) as NSAppleEventDescriptor
        
        //print( result.description )
        
        if result.description == "" {
            return false
        } else {
            return true
        }
        
    }

    // This function generate terminal command for append text to a file
    func getAppend( string: String, pathFile: String ) -> String {
        let script = " printf '\(string)' >> \(pathFile)";
        return script
    }
    
    // This function append text to a file
    func appendStringToFile( string: String, pathFile: String ) -> Bool {
        let script = " printf '\(string)' >> \(pathFile)";
        return self.run( script )
    }

}



//
//  AppleScript.swift
//  vHosts
//
//  Created by Ampelio on 09/07/15.
//  Copyright (c) 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import Foundation

class ScriptsController {
    
    // Questa funzione lancia un apple script contenente il comando da eseguire nella console.
    // Il comando viene lanciato attraverso apple script perchè chiede in automatico i privilegi
    // senza il bisogno di inserire secureframework
    func run(inScript:String...) -> Bool {
        
        var script = ""
        for myscript in inScript {
            script += "do shell script \"\(myscript)\" with administrator privileges\n"
        }
        
        var appleScript = NSAppleScript(source: script)
        var eventResult = appleScript!.executeAndReturnError(nil)
        
        if eventResult == nil {
            return false
        } else {
            return true
        }
    }

    // This function generate terminal command for append text to a file
    func getAppend( string: String, pathFile: String ) -> String {
        var script = " printf '\(string)' >> \(pathFile)";
        return script
    }
    
    // This function append text to a file
    func appendStringToFile( string: String, pathFile: String ) -> Bool {
        var script = " printf '\(string)' >> \(pathFile)";
        return self.run( script )
    }

}



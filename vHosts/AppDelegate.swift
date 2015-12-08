//
//  AppDelegate.swift
//  vHosts
//
//  Created by Giuseppe Salvo on 21/06/15.
//  Copyright (c) 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa

@NSApplicationMain


class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    //Quit application on window close
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
}


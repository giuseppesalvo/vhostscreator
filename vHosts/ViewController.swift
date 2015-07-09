//
//  ViewController.swift
//  vHosts
//
//  Created by Giuseppe Salvo on 21/06/15.
//  Copyright (c) 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import Foundation
import QuartzCore

class ViewController: NSViewController, NSTextFieldDelegate {

    
    // - - - - - - - - - - - - -
    // @ Parameters
    // - - - - - - - - - - - - -
    
    // View Elements
    @IBOutlet weak var titlelbl: NSTextField!
    @IBOutlet weak var serverName: NSTextField!
    @IBOutlet weak var serverAdmin: NSTextField!
    @IBOutlet weak var documentRootLabel: NSTextField!
    @IBOutlet weak var browseDirBtn: NSButton!
    @IBOutlet weak var btnCreate: NSButton!
    
    // Paths of file
    let hostsFile  = "/etc/hosts"
    let vhostsFile = "/etc/apache2/extra/httpd-vhosts.conf"
    
    // Classes
    let Interface = InterfaceController()
    let Scripts   = ScriptsController()
    
    
    // - - - - - - - - - - - - -
    // @ App load
    // - - - - - - - - - - - - -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Interface.button( btnCreate )
        Interface.text( serverName, serverAdmin, documentRootLabel )
    }
    
    // @ On Appear - - - - - - - - -
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //Get current window
        var window : NSWindow? = self.view.window
        Interface.window( window! )
    }
    
     @IBAction func browseDirectory(sender: AnyObject) {
        
        var openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
        
                let url = openPanel.URL?.path
                
                self.documentRootLabel.stringValue = url!
                
            }
        }
        
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        
        var name  = serverName.stringValue.lowercaseString
        var admin = serverAdmin.stringValue.lowercaseString
        var root  = documentRootLabel.stringValue
        
        if name != "" && admin != "" && root != ""
        {
            
            let vhost : String = "\n\n# \(name.uppercaseString)\n<VirtualHost *:80>\n\tServerAdmin \(admin)\n\tDocumentRoot '\(root)'\n\tServerName \(name)\n\tServerAlias www.\(name)\n\tErrorLog '/private/var/log/apache2/\(name)-error_log'\n\tCustomLog '/private/var/log/apache2/\(name)-access_log' comm$\n</VirtualHost>"
            let hosts = "\n\n# \(name.uppercaseString)\n127.0.0.1\t\(name) www.\(name)"
            
            if Scripts.run( Scripts.getAppend(vhost, pathFile: vhostsFile),
                            Scripts.getAppend(hosts, pathFile: hostsFile),
                            "apachectl restart" )
            {
                Interface.popup("Success", text: "Virtual host created")
            }
            else
            {
                 Interface.popup( "Error", text: "Error while creating virtual host" )
            }
        
        }
        else
        {
            Interface.popup("Error", text: "There are empty fields!")
        }
        
        
       
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


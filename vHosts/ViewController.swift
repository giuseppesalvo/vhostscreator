//
//  ViewController.swift
//  vHosts
//
//  Created by Giuseppe Salvo on 21/06/15.
//  Copyright (c) 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    
    @IBOutlet weak var serverName: NSTextField!
    @IBOutlet weak var serverAdmin: NSTextField!
    @IBOutlet weak var documentRootLabel: NSTextField!
    
    let hostsFile  = "/etc/hosts"
    let vhostsFile = "/etc/apache2/extra/httpd-vhosts.conf"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //Class for read and check files
    class File {
        class func exists (path: String) -> Bool {
            return NSFileManager().fileExistsAtPath(path)
        }
        class func read (path: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
            if File.exists(path) {
                return String( contentsOfFile: path, encoding: encoding )
            }
            
            return nil
        }
    }
    
    // Questa funzione lancia un apple script contenente il comando da eseguire nella console.
    // Il comando viene lanciato attraverso apple script perchè chiede in automatico i privilegi
    // senza il bisogno di inserire secureframework
    func doScriptWithAdmin(inScript:String) -> Bool {
        let script = "do shell script \"\(inScript)\" with administrator privileges"
        var appleScript = NSAppleScript(source: script)
        var eventResult = appleScript!.executeAndReturnError(nil)
        if eventResult == nil {
            return false
        }else{
            return true
        }
    }
    
    func threeScriptWithAdmin( firstScript:String, secondScript:String, thirdScript:String ) -> Bool {
        let script = "do shell script \"\(firstScript)\" with administrator privileges\ndo shell script \"\(secondScript)\" with administrator privileges\ndo shell script \"\(thirdScript)\" with administrator privileges"
        var appleScript = NSAppleScript(source: script)
        var eventResult = appleScript!.executeAndReturnError(nil)
        if eventResult == nil {
            return false
        }else{
            return true
        }
    }
    
    func returnAppend( string: String, pathFile: String ) -> String {
        var script = " printf '\(string)' >> \(pathFile)";
        return script
    }
    
    func appendStringToFile( string: String, pathFile: String ) -> Bool {
        var script = " printf '\(string)' >> \(pathFile)";
        return doScriptWithAdmin( script )
    }
    
    func createPopup(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
        myPopup.addButtonWithTitle("OK")
        let res = myPopup.runModal()
        if res == 1000 {
            return true
        }
        return false
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        
        var name  = serverName.stringValue.lowercaseString
        var admin = serverAdmin.stringValue.lowercaseString
        var root  = documentRootLabel.stringValue
        
        if name != "" && admin != "" && root != "" {
            
            let vhost : String = "\n\n# \(name.uppercaseString)\n<VirtualHost *:80>\n\tServerAdmin \(admin)\n\tDocumentRoot '\(root)'\n\tServerName \(name)\n\tServerAlias www.\(name)\n\tErrorLog '/private/var/log/apache2/\(name)-error_log'\n\tCustomLog '/private/var/log/apache2/\(name)-access_log' comm$\n</VirtualHost>"
            let hosts = "\n\n# \(name.uppercaseString)\n127.0.0.1\t\(name) www.\(name)"
            
            //println( vhost )
            //println( hosts )
            
            if threeScriptWithAdmin( returnAppend(vhost, pathFile: vhostsFile) ,
                                     secondScript: returnAppend(hosts, pathFile: hostsFile),
                                     thirdScript: "apachectl restart" )
            {
                createPopup("Success", text: "Virtual host created")
            }
            else
            {
                 createPopup( "Error", text: "Error while creating virtual host" )
            }
        
        } else {
            createPopup("Errore", text: "Compila tutti i campi")
        }
        
        
       
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


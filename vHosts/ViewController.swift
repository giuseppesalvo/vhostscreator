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

    
    @IBOutlet weak var titlelbl: NSTextField!
    @IBOutlet weak var serverName: NSTextField!
    @IBOutlet weak var serverAdmin: NSTextField!
    @IBOutlet weak var documentRootLabel: NSTextField!
    @IBOutlet weak var browseDirBtn: NSButton!

    @IBOutlet weak var btnCreate: NSButton!
    
    let hostsFile  = "/etc/hosts"
    let vhostsFile = "/etc/apache2/extra/httpd-vhosts.conf"

    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        var window : NSWindow? = self.view.window
        
        window?.titleVisibility = .Hidden
        window?.titlebarAppearsTransparent = true
        window?.movableByWindowBackground = true
        
    }
    
    func setTextStyle( text : NSTextField... ) {
        
        for t in text {
            t.focusRingType = .None
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // buttonCreate.layer.co
        btnCreate.layer?.cornerRadius = 8.0
        btnCreate.layer?.masksToBounds = true
        btnCreate.layer?.borderWidth = 4
        btnCreate.layer?.borderColor = NSColor.whiteColor().CGColor
        btnCreate.wantsLayer = true
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .CenterTextAlignment
        
        let font = NSFont(name: "Courier New Bold", size: 14 )
        
         btnCreate.attributedTitle = NSAttributedString(string: btnCreate.title,
            attributes: [
                NSForegroundColorAttributeName : titlelbl.textColor!,
                NSParagraphStyleAttributeName : pstyle,
                NSFontAttributeName : font!
            ])


        setTextStyle( serverName, serverAdmin, documentRootLabel )
      
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


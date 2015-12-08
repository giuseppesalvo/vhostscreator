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

class ViewController: NSViewController, NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource {

    
    // - - - - - - - - - - - - -
    // MARK: Parameters
    // - - - - - - - - - - - - -
    
    // View Elements
    @IBOutlet weak var titlelbl          : NSTextField!
    @IBOutlet weak var serverName        : NSTextField!
    @IBOutlet weak var serverAdmin       : NSTextField!
    @IBOutlet weak var documentRootLabel : NSTextField!
    @IBOutlet weak var browseDirBtn      : NSButton!
    @IBOutlet weak var btnCreate         : NSButton!
    @IBOutlet weak var portText: NSTextField!
    
    
    @IBOutlet var HostsTableView: NSTableView!
    
    // Paths of file
    let hostsFile  = "/etc/hosts"
    let vhostsFile = "/etc/apache2/extra/httpd-vhosts.conf"
    
    // Classes
    let UI = UIController()
    let Scripts   = ScriptsController()
    
    
    // - - - - - - - - - - - - -
    // MARK: App load
    // - - - - - - - - - - - - -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UI.styleButton(btnCreate, cornerRadius: 4, borderWidth: 0, background: true, whiteText: true)
        UI.styleButton(browseDirBtn, cornerRadius: browseDirBtn.frame.size.height/2, borderWidth: 1, background: false, whiteText: false)
        UI.text( serverName, serverAdmin, documentRootLabel, portText )
    }
    
    // - - - - - - - - - - - - -
    // MARK: On Appear
    // - - - - - - - - - - - - -
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //Get current window
        let window : NSWindow? = self.view.window
        UI.window( window! )
    }
    
    
    // - - - - - - - - - - - - -
    // MARK: browseDirectory
    // - - - - - - - - - - - - -
    
    @IBAction func browseDirectory(sender: AnyObject) {
        
        let openPanel = NSOpenPanel()
        
        openPanel.allowsMultipleSelection  = false
        openPanel.canChooseDirectories     = true
        openPanel.canCreateDirectories     = true
        openPanel.canChooseFiles           = false
        
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
        
                let url = openPanel.URL?.path
                
                self.documentRootLabel.stringValue = url!
                
            }
        }
        
    }
    
    
    // - - - - - - - - - - - - -
    // MARK: Create vHost
    // - - - - - - - - - - - - -
    @IBAction func buttonAction(sender: AnyObject) {
        
        let name  = serverName.stringValue.lowercaseString
        let admin = serverAdmin.stringValue.lowercaseString
        let root  = documentRootLabel.stringValue
        
        if name != "" && admin != "" && root != ""
        {
            
            var port = ""
            
            if portText.stringValue != "" && portText.stringValue != "80" {
                port = String( portText.integerValue )
                port = "\n\tProxyPreserveHost On\n\tProxyPass / http://localhost:\(port)/\n\tProxyPassReverse / http://localhost:\(port)/\n\n"
            }
            
            
            let vhost : String = "\n\n# \(name.uppercaseString)\n<VirtualHost *:80>\n\tServerAdmin \(admin)\n\tDocumentRoot '\(root)'\n\tServerName \(name)\n\tServerAlias www.\(name)\n\tErrorLog '/private/var/log/apache2/\(name)-error_log'\n\tCustomLog '/private/var/log/apache2/\(name)-access_log' comm$\n\(port)</VirtualHost>"
            let hosts = "\n\n# \(name.uppercaseString)\n127.0.0.1\t\(name) www.\(name)"
            
            if Scripts.run( Scripts.getAppend(vhost, pathFile: vhostsFile),
                            Scripts.getAppend(hosts, pathFile: hostsFile),
                            "apachectl restart" )
            {
                UI.popup("Success", text: "Virtual host created")
            }
            else
            {
                 UI.popup( "Error", text: "Error while creating virtual host" )
            }
        
        }
        else
        {
            UI.popup("Error", text: "There are empty fields!")
        }
    }
    
    //
    // Table View's delegate
    //
    
    let tableArray:[String] = [ "Hi", "Hello", "Ciao" ]
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int
    {
        let numberOfRows : Int = self.tableArray.count
        return numberOfRows
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell : CustomCell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! CustomCell
        cell.title.stringValue = self.tableArray[ row ]
        return cell
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?
    {
        let newString = self.tableArray[ row ]
        return newString
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let myCustomView = CustomRowSelection()
        return myCustomView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 48
    }
    
    //
    // END TABLE VIEW
    //

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


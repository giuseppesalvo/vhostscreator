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

class ViewController: NSViewController, NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource, CustomCellDelegate {

    
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
    
    // Classes
    let UI = UIController()
    
    // - - - - - - - - - - - - -
    // MARK: App load
    // - - - - - - - - - - - - -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UI.styleButton(btnCreate, cornerRadius: 4, borderWidth: 0, background: true, whiteText: true)
        UI.styleButton(browseDirBtn, cornerRadius: 4, borderWidth: 1, background: false, whiteText: false)
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
    
    var NSPanelOpened : Bool = false
    
    @IBAction func browseDirectory(sender: AnyObject) {
        
        if !self.NSPanelOpened {
            
            self.NSPanelOpened = true
        
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
                
                self.NSPanelOpened = false
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
        let port  = portText.stringValue
        
        if name != "" && admin != "" && root != "" {
            
            let command = Command.get( name , serveradmin: admin, documentroot: root, port: port )
            
            let result = VHost.addOrUpdate(
                name,
                serveradmin: admin,
                documentroot: root,
                port: port,
                vhostText: command["vhosts"]!,
                hostText: command["hosts"]!
            )
            
            if result {
                
                reloadTable()
                
                UI.popup("Success", text: "Virtual host created")
            }
            else {
                 UI.popup( "Error", text: "Error while creating virtual host" )
            }
        
        }
        else {
            UI.popup("Error", text: "There are empty fields!")
        }
    }
    
    //
    // Table View's delegate
    //
    
    var tableArray = VHost.all()
    
    func reloadTable () {
        tableArray = VHost.all()
        HostsTableView.reloadData()
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        let numberOfRows : Int = self.tableArray.count
        return numberOfRows
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell : CustomCell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! CustomCell
        cell.delegate = self
        cell.title.stringValue = self.tableArray[ row ].servername
        return cell
    }
    
    //
    // CELL DELEGATES
    //
    
    func tableViewRowEdit( cell: CustomCell ) {
        
        let current = VHost.get( cell.title.stringValue )
        
        serverName.stringValue        = current.servername
        serverAdmin.stringValue       = current.serveradmin
        documentRootLabel.stringValue = current.documentroot
        portText.stringValue          = current.port
    }
    
    func tableViewRowDelete( cell: CustomCell ) {
        
        if VHost.delete( cell.title.stringValue ) {
            reloadTable()
            UI.popup("Success", text: "Virtual Host deleted" )
        } else {
            UI.popup("Error", text: "Error while deleting Virtual Host" )
        }
    
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?
    {
        let newString = self.tableArray[ row ].servername
        return newString
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let myCustomView = CustomRowSelection()
        return myCustomView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 48
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


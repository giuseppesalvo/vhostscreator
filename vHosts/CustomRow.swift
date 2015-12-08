//
//  CustomRow.swift
//  vHosts
//
//  Created by Giuseppe Salvo on 08/12/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa

class CustomRowSelection: NSTableRowView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if selected == true {
            NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6).set()
            NSRectFill(dirtyRect)
        }
    }
}

class CustomCell : NSTableCellView {
    
    @IBOutlet var title: NSTextField!
    
}
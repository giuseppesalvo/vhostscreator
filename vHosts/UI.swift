//
//  StyleController.swift
//  vHosts
//
//  Created by Ampelio on 09/07/15.
//  Copyright (c) 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import Foundation
import QuartzCore

class UIController {
    
    let currentFont : String  = "Courier New Bold"
    let fontSize    : CGFloat = 14.0
    let textColor   : NSColor = NSColor(red:120/255, green: 140/255, blue: 200/255, alpha: 1)
    
    //Set window style
    func window( window : NSWindow... ) {
       
        for w in window {
            // Remove title bar
            w.titleVisibility = .Hidden
            w.titlebarAppearsTransparent = true
            w.movableByWindowBackground = true
            w.backgroundColor = NSColor.whiteColor()
        }
   
    }
    
    //Set styles for all text
    func text( text : NSTextField... ) {
        
        for t in text {
            t.focusRingType = .None
        }
        
    }
    
    //Set styles for all buttons
    func button( button : NSButton... ) {
        for b in button {
            b.wantsLayer = true
            
            let pstyle = NSMutableParagraphStyle()
            pstyle.alignment = NSTextAlignment.Center
            
            let font = NSFont( name: currentFont, size: fontSize )
            
            b.attributedTitle = NSAttributedString(string: b.title,
                attributes: [
                    NSForegroundColorAttributeName : textColor,
                    NSParagraphStyleAttributeName : pstyle,
                    NSFontAttributeName : font!
                ])
            
        }
    }
    
    //Set styles for all buttons
    func styleButton( button : NSButton, cornerRadius : CGFloat, borderWidth : CGFloat, background: Bool, whiteText: Bool ) {
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = NSTextAlignment.Center
 
        
        button.wantsLayer = true
        button.layer?.cornerRadius = cornerRadius
        button.layer?.borderWidth = borderWidth
        button.layer?.borderColor = self.textColor.CGColor
        if background {
            button.layer?.backgroundColor = self.textColor.CGColor
        }
        
        let textColor : NSColor = ( whiteText ? NSColor.whiteColor() : self.textColor )
        
        let coloredTitle = NSMutableAttributedString( attributedString: button.attributedTitle )
        let range : NSRange = NSMakeRange(0, coloredTitle.length )
        coloredTitle.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)
        button.attributedTitle = coloredTitle
        
    }
    
    // Create dialog box on screen
    func popup(question: String, text: String) -> Bool {
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
    
}

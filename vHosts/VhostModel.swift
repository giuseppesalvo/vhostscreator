//
//  VhostsModel.swift
//  vHosts
//
//  Created by Giuseppe Salvo on 08/12/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Foundation
import RealmSwift

// vhosts model
class VHostModel: Object {
    dynamic var servername  = ""
    dynamic var serveradmin = ""
    dynamic var documentroot = ""
    dynamic var port = ""
    
    dynamic var vhostText = ""
    dynamic var hostText  = ""
}

class VHost {
    
    //
    // GET ALL
    //
    class func all () -> Results<VHostModel> {
        
        let realm = RealmSingleton.get
        
        return realm.objects( VHostModel )
    }
    
    //
    // ADD NEW
    //
    class func add ( servername:String, serveradmin: String, documentroot:String, port: String, vhostText:String, hostText:String ) -> Bool {
        
        let realm = RealmSingleton.get
        
        let scripts = [
            Scripts.getAppend(vhostText, pathFile: Command.paths["vhosts"]!),
            Scripts.getAppend(hostText , pathFile: Command.paths["hosts"]!),
            "apachectl restart"
        ]
        
        if Scripts.run( scripts ) {
        
            let newVHost = VHostModel()
            newVHost.servername = servername
            newVHost.serveradmin = serveradmin
            newVHost.documentroot = documentroot
            newVHost.port = port
            newVHost.vhostText = vhostText
            newVHost.hostText = hostText
        
            try! realm.write {
                realm.add( newVHost )
            }
            
            return true
        }
        else {
            return false
        }
    }
    
    //
    // ADD OR UPDATE
    //
    class func addOrUpdate ( servername:String, serveradmin: String, documentroot:String, port: String, vhostText:String, hostText:String ) -> Bool {
        
        let realm = RealmSingleton.get
        
        let search = realm.objects(VHostModel).filter("servername = '\(servername)'")
        
        if ( search.count > 0 ) {
        
            let current = search[0]
        
            let scripts = [
                Scripts.getReplace(current.vhostText, replace: vhostText, pathFile: Command.paths["vhosts"]!),
                Scripts.getReplace(current.hostText , replace: hostText, pathFile: Command.paths["hosts"]!),
                "apachectl restart"
            ]
            
            if Scripts.run( scripts ) {
            
                try! realm.write {
                    current.servername  = servername
                    current.serveradmin = serveradmin
                    current.documentroot = documentroot
                    current.port = port
                    current.vhostText = vhostText
                    current.hostText = hostText
                }
                
                return true
                
            } else {
                return false
            }
            
        } else {
            return add(servername, serveradmin: serveradmin, documentroot: documentroot, port: port, vhostText: vhostText, hostText: hostText )
        }
    }
    
    //
    // GET FROM SERVERNAME
    //
    
    class func get( servername: String ) -> VHostModel {
        
        let realm = RealmSingleton.get
        
        let current = realm.objects(VHostModel).filter("servername = '\(servername)'")[0]
     
        return current
        
    }
    
    
    //
    // DELETE
    //
    
    class func delete ( servername:String ) -> Bool {
        
        let realm = RealmSingleton.get
        
        let current = realm.objects(VHostModel).filter("servername = '\(servername)'")[0]
        
        let scripts = [
            Scripts.getReplace(current.vhostText, replace: "", pathFile: Command.paths["vhosts"]!),
            Scripts.getReplace(current.hostText , replace: "", pathFile: Command.paths["hosts"]!),
            "apachectl restart"
        ]
    
        if Scripts.run( scripts ) {
        
            try! realm.write {
                realm.delete(current)
            }
            
            return true
            
        } else {
            
            return false
        
        }
    
    }
    
}
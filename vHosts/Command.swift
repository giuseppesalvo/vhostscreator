//
//  Command.swift
//  vHosts
//
//  Created by Giuseppe Salvo on 08/12/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Foundation

class Command {
    
    //
    // MARK:PATHS
    //
    static let paths : [String:String] = [
        "vhosts" : "/etc/hosts",
        "hosts"  : "/etc/apache2/extra/httpd-vhosts.conf"
    ]
    
    //
    // MARK: FORMATS
    //
    static let formats : [String:String] = [
        
        "vhosts" : "\n\n# {{servername}}\n<VirtualHost *:80>\n\tServerAdmin {{admin}}\n\tDocumentRoot '{{documentroot}}'\n\tServerName {{servername}}\n\tServerAlias www.{{servername}}\n\tErrorLog '/private/var/log/apache2/{{servername}}-error_log'\n\tCustomLog '/private/var/log/apache2/{{servername}}-access_log' comm$\n{{port}}</VirtualHost>",
        
        "port" : "\n\tProxyPreserveHost On\n\tProxyPass / http://localhost:{{portnumber}}/\n\tProxyPassReverse / http://localhost:{{portnumber}}/\n\n",
        
        "hosts" : "\n\n# {{servername}}\n127.0.0.1\t{{servername}} www.{{servername}}"
    ]
    
    //
    // MARK: SELECTORS
    //
    static let selectors:[String:String] = [
        "servername"    : "{{servername}}",
        "admin"         : "{{admin}}",
        "documentroot"  : "{{documentroot}}",
        "port"          : "{{port}}",
        "portnumber"    : "{{portnumber}}"
    ]
    
    //
    // MARK: GET STRING
    //
    class func get ( servername:String, serveradmin:String, documentroot:String, port:NSString ) -> [String:String] {
    
        var vhosts = formats["vhosts"]!
            .stringByReplacingOccurrencesOfString( selectors["servername"]! , withString: servername)
            .stringByReplacingOccurrencesOfString( selectors["admin"]!      , withString: serveradmin)
            .stringByReplacingOccurrencesOfString( selectors["servername"]! , withString: documentroot)
        
        if port != "" && port != "80" {
            
            let portNumber = String( port.integerValue )
            
            let portString = formats["port"]!
                .stringByReplacingOccurrencesOfString( selectors["portnumber"]!, withString: portNumber)
            
            vhosts = vhosts
                .stringByReplacingOccurrencesOfString( selectors["port"]!, withString: portString )
        
        }
        
        let hosts = formats["hosts"]!
                .stringByReplacingOccurrencesOfString( selectors["servername"]!, withString: servername )
    
        return [
            "vhosts" : vhosts,
            "hosts"  : hosts
        ]
    }
    
    
}

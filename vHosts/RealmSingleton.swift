//
//  RealmSingleton.swift
//  vHosts
//
//  Created by Giuseppe Salvo on 12/12/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSingleton {
    
    static let get = try! Realm()
    
    private init () {}

}
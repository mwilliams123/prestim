//
//  Data.swift
//  prestim
//
//  Created by Megan Williams on 12/22/17.
//  Copyright © 2017 Prestimulus. All rights reserved.
//


import Foundation
import UIKit
import AWSDynamoDB

class Data: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _lTM: [String]?
    var _rE: [String]?
    
    class func dynamoDBTableName() -> String {
        
        return "prestim-mobilehub-27967563-ExperimentData"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_userId" : "userId",
            "_lTM" : "LTM",
            "_rE" : "RE",
        ]
    }
}

//
//  hype.swift
//  Hype
//
//  Created by Matthew O'Connor on 10/14/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit
import CloudKit

// MARK: - Hype Strings
struct HypeStrings {
    static let recordTypeKey = "Hype"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
}
//MARK: - Class Declaration
class Hype {
    var body: String
    var timestamp: Date
    
    init(body: String, timestamp: Date = Date()) {
        self.body = body
        self.timestamp = timestamp
    }
}
//MARK: -Convenience init extension
///cloud -> Hype
extension Hype  {
    /**
     convenience failable initializer that finds the key/value pairs in the passed in CKRecord and initializes a Hype from this
     
     - Parameters:
     - ckRecord: CKRecord object should contain the key/value pairs of a hype object stored in the cloud
     */
    convenience init?(ckRecord: CKRecord) {
        
        // unwrapping the values for the keys stored in the CKRecord
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
            let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
            else {return nil}
        
        self.init(body: body, timestamp: timestamp)
    }
}


//MARK: -CKRecord Extension
///hype -> cloud
extension CKRecord {
    /**
     convenience initializer to create a CKRecord and set the key/value pairs based on our hype model objects.
     
     - Parameters:
     - hype: hype object we want to set the CKRecord key/value pair for
     */
    convenience init(hype: Hype) {
        //initializes a CKRecord
        self.init(recordType: HypeStrings.recordTypeKey)
        //set key/value pairs for CKRecord
        self.setValuesForKeys([
            HypeStrings.bodyKey : hype.body,
            HypeStrings.timestampKey : hype.timestamp
        ])
    }
}

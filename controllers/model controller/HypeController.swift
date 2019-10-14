//
//  HypeController.swift
//  Hype
//
//  Created by Matthew O'Connor on 10/14/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    //shared instance
    static let shared = HypeController()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //source of truth
    var hypes: [Hype] = []
    
    //crud
    /**
     saves a hype object to the public database
     
     - Parameters:
     - text: string value for the hype's body.
     - completion: escaping completion block for the method.
     - success: boolean value returned in the completion block indicating success or failue on saving the CKRecord to CloudKit and reinitializing as the object.
     */
    func saveHype (with text: String, completion: @escaping(_ success: Bool) -> Void) {
        // declares newHype, assigns it to an initialized Hype object, taking the text parameter and passing it in for the body
        let newHype = Hype(body: text)
        // initializes a new CKRecord using our convenience init on our CKRecord extension
        let hypeRecord = CKRecord(hype: newHype)
        //access the save method on our database to save the hypeRecord, completes with an optional record and error
        publicDB.save(hypeRecord) { (record, error) in
            //handling the error, complete false
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            //unwrap the record that was saved then turnoing into our model object using our failable convience initializer
            guard let record = record,
                let savedHype = Hype(ckRecord: record)
                else {completion(false); return}
            //append the saved hype to our source of truth, completing true
            self.hypes.append(savedHype)
            completion(true)
        }
    }
    
    //fetch
    func fetchAllHypes(completion: @escaping (_ success: Bool) -> Void) {
        //Step 3: creating a predicate to pass into the CKQuery
        let predicate = NSPredicate(value: true)
        //Step 2: creating a query constant and assigning it to a CKQuery, initialized with our recordTypeKEy and it requires a predicate
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        // step 1: call the perform method on the public, which requires a CKQuery
        publicDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion (false)
                return
            }
            //check to make sure we retrieved recoreds if not complete false and reture
            guard let records = foundRecords else {completion(false);return}
            //creating an array of hypes from the records array, compactmaping through it to return non-nil value
            let hypes = records.compactMap( { Hype(ckRecord: $0) } )
            //assign our SOT
            self.hypes = hypes
            completion(true)
            
        }
    }
}

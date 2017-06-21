//
//  Model.swift
//  Pincode
//
//  Created by Deepak Dewani on 20/02/16.
//  Copyright © 2016 Deepak Dewani. All rights reserved.
//

import Foundation
import CoreData

class Model: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    @NSManaged var pincode: String?
    @NSManaged var officeName: String?
    @NSManaged var officeType: String?
    @NSManaged var deliveryStatus: String?
    @NSManaged var divisionName: String?
    @NSManaged var regionName: String?
    @NSManaged var circleName: String?
    @NSManaged var taluqName: String?
    @NSManaged var districtName: String?
    @NSManaged var stateName: String?
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
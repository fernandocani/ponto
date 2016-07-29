//
//  DefaultTime.swift
//  
//
//  Created by Fernando Cani on 8/31/15.
//
//

import Foundation
import CoreData

@objc(DefaultTime)
class DefaultTime: NSManagedObject {
    
    @NSManaged var totalHor:Int16
    @NSManaged var totalMin:Int16
    @NSManaged var time1: String
    @NSManaged var time2: String
    @NSManaged var time3: String
    @NSManaged var time4: String

}

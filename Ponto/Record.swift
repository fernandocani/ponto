//
//  Record.swift
//  
//
//  Created by Fernando Cani on 8/24/15.
//
//

import Foundation
import CoreData

@objc(Record)
class Record: NSManagedObject {
    
    @NSManaged var totalHor:Int16
    @NSManaged var totalMin:Int16
    @NSManaged var comment: String
    @NSManaged var time4:   String
    @NSManaged var time3:   String
    @NSManaged var time2:   String
    @NSManaged var time1:   String
    @NSManaged var date:    Date

}

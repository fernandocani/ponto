//
//  DataStore.swift
//  
//
//  Created by Fernando Cani on 8/24/15.
//
//

import UIKit
import CoreData

public class DataStore {
    public let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    // MARK: - Singleton
    public class var sharedInstance: DataStore {
        struct Static {
            static let instance: DataStore = DataStore()
        }
        return Static.instance
    }
    
    // MARK: - Create (Record)
    
    public func saveData(Date date: NSDate, Time1 time1: String, Time2 time2: String, Time3 time3: String, Time4 time4: String, Comment comment: String, TotalHor totalHor: Int16, TotalMin totalMin: Int16) -> Bool {
        if getRecordByDate(date) == nil {
            let userEntity = NSEntityDescription.entityForName("Record", inManagedObjectContext: managedContext)
            let record = Record(entity: userEntity!, insertIntoManagedObjectContext: managedContext)
            record.totalHor = totalHor
            record.totalMin = totalMin
            record.comment = comment
            record.time4 = time4
            record.time3 = time3
            record.time2 = time2
            record.time1 = time1
            record.date = date
            do {
                try managedContext.save()
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
    // MARK: - Read (Record)

    public func getAllRecords() -> NSArray {
        let request = NSFetchRequest(entityName: "Record")
        let recordList = (try! managedContext.executeFetchRequest(request)) as! [Record]
        let recordArray = NSArray(array: recordList)
        return recordArray
    }
    
    func getRecordByID(id: Int) -> Record! {
        let request = NSFetchRequest(entityName: "Registro")
        let predicate = NSPredicate(format: "id LIKE[cd] %@", id)
        request.predicate = predicate
        var objects: [AnyObject]?
        objects = (try! managedContext.executeFetchRequest(request))
        if objects!.count > 0 {
            let match = objects?.first as! Record
            return match
        } else {
            return nil
        }
    }
    
    func getRecordByDate(date: NSDate) -> Record! {
        let request = NSFetchRequest(entityName: "Record")
        let predicate = NSPredicate(format: "date == %@", date)
        request.predicate = predicate
        var objects: [AnyObject]?
        objects = (try! managedContext.executeFetchRequest(request))
        if objects!.count > 0 {
            return objects!.first as! Record
        } else {
            return nil
        }
    }
    
    // MARK: - Update (Record)
    
    public func updateRecordByDate(CurrentDate currentDate: NSDate, SaveDate saveDate: NSDate, Time1 time1: String, Time2 time2: String, Time3 time3: String, Time4 time4: String, Comment comment: String, TotalHor totalHor: Int16, TotalMin totalMin: Int16) -> Bool {
        let request = NSFetchRequest(entityName: "Record")
        let predicate = NSPredicate(format: "date == %@", currentDate)
        request.predicate = predicate
        let recordList = (try! managedContext.executeFetchRequest(request)) as! [Record]
        if recordList.count > 0 {
            let request2 = NSFetchRequest(entityName: "Record")
            let predicate2 = NSPredicate(format: "date == %@", saveDate)
            request2.predicate = predicate2
            let recordList2 = (try! managedContext.executeFetchRequest(request2)) as! [Record]
            if recordList2.count != 0 {
                if currentDate == saveDate {
                    recordList2.first!.date      = saveDate
                    recordList2.first!.time1     = time1
                    recordList2.first!.time2     = time2
                    recordList2.first!.time3     = time3
                    recordList2.first!.time4     = time4
                    recordList2.first!.comment   = comment
                    recordList2.first!.totalHor  = totalHor
                    recordList2.first!.totalMin  = totalMin
                    do {
                        try managedContext.save()
                        return true
                    } catch {
                        return false
                    }
                } else {
//                    let jaTem = UIAlertController(title: "Atenção!", message: "Já existem um registro nessa data. Deseja manter a atual ou efetuar a alteração assim mesmo? ", preferredStyle: UIAlertControllerStyle.Alert)
//                    jaTem.addAction(UIAlertAction(title: "Alteração", style: .Destructive, handler: { (action: UIAlertAction!) in }))
//                    jaTem.addAction(UIAlertAction(title: "Manter", style: .Default, handler: { (action: UIAlertAction!) in }))
//                    self.presentViewController(jaTem, animated: true, completion: nil )
                    return false
                }
            } else {
                if saveData(Date: saveDate, Time1: time1, Time2: time2, Time3: time3, Time4: time4, Comment: comment, TotalHor: totalHor, TotalMin: totalMin) {
                    if removeRecordByDate(currentDate) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    // MARK: - Remove (Record)

    public func removeRecordByDate(date: NSDate) -> Bool {
        let request = NSFetchRequest(entityName: "Record")
        let predicate = NSPredicate(format: "date == %@", date)
        request.predicate = predicate
        do {
            let record = try managedContext.executeFetchRequest(request) as! [Record]
            if record.count > 0 {
                managedContext.deleteObject(record.first!)
                do {
                    try managedContext.save()
                    return true
                } catch {
                    return false
                }
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    public func removeAllRecords() -> Bool {
        let request = NSFetchRequest(entityName: "Record")
        let recordList = (try! managedContext.executeFetchRequest(request)) as! [Record]
        if recordList.count > 0 {
            for valor in 0...(recordList.count - 1){
                let record = recordList[valor]
                managedContext.deleteObject(record)
            }
            do {
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    // MARK: - Create (DefaulTime)
    
    public func saveDataDefaultTime(Time1 time1: String, Time2 time2: String, Time3 time3: String, Time4 time4: String, TotalHor totalHor: Int16, TotalMin totalMin: Int16) -> Bool {
        let userEntity = NSEntityDescription.entityForName("DefaultTime", inManagedObjectContext: managedContext)
        let defaultTime = DefaultTime(entity: userEntity!, insertIntoManagedObjectContext: managedContext)
        defaultTime.totalMin = totalMin
        defaultTime.totalHor = totalHor
        defaultTime.time4 = time4
        defaultTime.time3 = time3
        defaultTime.time2 = time2
        defaultTime.time1 = time1
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Read (DefaulTime)
    
    public func getAllDefaultTime() -> NSArray {
        let request = NSFetchRequest(entityName: "DefaultTime")
        let defaultTimeList = (try! managedContext.executeFetchRequest(request)) as! [DefaultTime]
        let defaultTimeArray = NSArray(array: defaultTimeList)
        return defaultTimeArray
    }
    
    // MARK: - Update (DefaulTime)

    public func updateDefaulTime(Time1 time1: String, Time2 time2: String, Time3 time3: String, Time4 time4: String, TotalHor totalHor: Int16, TotalMin totalMin: Int16) -> Bool{
        let request = NSFetchRequest(entityName: "DefaultTime")
        let defaultTimeList = (try! managedContext.executeFetchRequest(request)) as! [DefaultTime]
        if defaultTimeList.count > 0 {
            for defaultTime in defaultTimeList {
                defaultTime.totalMin = totalMin
                defaultTime.totalHor = totalHor
                defaultTime.time1 = time1
                defaultTime.time2 = time2
                defaultTime.time3 = time3
                defaultTime.time4 = time4
            }
            do {
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    // MARK: - Remove (DefaulTime)

}
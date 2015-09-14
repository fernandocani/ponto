//
//  EditSingleton.swift
//  
//
//  Created by Fernando Cani on 8/28/15.
//
//

import UIKit

class EditSingleton: NSObject {
    
    var dateSelected = NSDate()
    
    class var sharedInstance: EditSingleton {
        struct Static {
            static let instance: EditSingleton = EditSingleton()
        }
        return Static.instance
    }
    
    // MARK: - Difference
    
    func calculateDifference1 (StartTime1 startTime1: NSDate, EndTime1 endTime1: NSDate) -> NSDateComponents {
        let userCalendar = NSCalendar.currentCalendar()
        let _: NSCalendarUnit = .Day
        let hourMinuteComponents1: NSCalendarUnit = [.Hour, .Minute]
        let timeDifference1 = userCalendar.components(
            hourMinuteComponents1,
            fromDate: startTime1,
            toDate: endTime1,
            options: [])
        return timeDifference1
    }
    
    func calculateDifference2 (StartTime2 startTime2: NSDate, EndTime2 endTime2: NSDate) -> NSDateComponents {
        let userCalendar = NSCalendar.currentCalendar()
        let _: NSCalendarUnit = .Day
        let hourMinuteComponents2: NSCalendarUnit = [.Hour, .Minute]
        let timeDifference2 = userCalendar.components(
            hourMinuteComponents2,
            fromDate: startTime2,
            toDate: endTime2,
            options: [])
        return timeDifference2
    }
    
    func calculateDifference(hora1: NSDate!, hora2: NSDate!, hora3: NSDate!, hora4: NSDate!) -> String {
        var caseSelected = 1
        var somaMin = 0
        var somaHor = 0
        var timeDifference1: NSDateComponents?
        var timeDifference2: NSDateComponents?
        
        let _: NSCalendarUnit = [.Hour, .Minute]
        if hora1 != nil && hora2 != nil && hora3 != nil && hora4 != nil {
            caseSelected = 1
        } else {
            if hora1 != nil && hora2 != nil {
                caseSelected = 2
            } else if hora3 != nil && hora4 != nil {
                caseSelected = 3
            } else if (hora2 == nil && hora3 == nil) && (hora1 != nil && hora4 != nil) {
                caseSelected = 4
            } else {
                caseSelected = 5
            }
        }
        switch (caseSelected) {
        case 1:
            timeDifference1 = calculateDifference1(StartTime1: hora1, EndTime1: hora2)
            timeDifference2 = calculateDifference2(StartTime2: hora3, EndTime2: hora4)
            somaMin = timeDifference1!.minute + timeDifference2!.minute
            somaHor = timeDifference1!.hour + timeDifference2!.hour
            break
        case 2:
            timeDifference1 = calculateDifference1(StartTime1: hora1, EndTime1: hora2)
            somaMin = timeDifference1!.minute
            somaHor = timeDifference1!.hour
            break
        case 3:
            timeDifference2 = calculateDifference2(StartTime2: hora3, EndTime2: hora4)
            somaMin = timeDifference2!.minute
            somaHor = timeDifference2!.hour
            break
        case 4:
            timeDifference1 = calculateDifference1(StartTime1: hora1, EndTime1: hora4)
            somaMin = timeDifference1!.minute
            somaHor = timeDifference1!.hour
            break
        case 5:
            break
        default:
            break
        }
        if somaMin >= 60 {
            somaHor = somaHor + 1
            somaMin = somaMin - 60
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        var somaFormatada: NSDate!
        somaFormatada = formatter.dateFromString(String(somaHor) + ":" + String(somaMin))
        if somaFormatada != nil {
            let somaString = formatter.stringFromDate(somaFormatada!)
            return somaString
        } else {
            return "erro no cálculo!"
        }
    }
}

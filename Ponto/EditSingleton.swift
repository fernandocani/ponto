//
//  EditSingleton.swift
//  
//
//  Created by Fernando Cani on 8/28/15.
//
//

import UIKit

class EditSingleton: NSObject {
    
    var dateSelected = Date()
    
    class var sharedInstance: EditSingleton {
        struct Static {
            static let instance: EditSingleton = EditSingleton()
        }
        return Static.instance
    }
    
    // MARK: - Difference
    
    func calculateDifference1 (StartTime1 startTime1: Date, EndTime1 endTime1: Date) -> DateComponents {
        let userCalendar = Calendar.current
        let _: NSCalendar.Unit = .day
        let timeDifference1 = userCalendar.dateComponents(
            [.hour, .minute],
            from: startTime1,
            to: endTime1)
        return timeDifference1
    }
    
    func calculateDifference2 (StartTime2 startTime2: Date, EndTime2 endTime2: Date) -> DateComponents {
        let userCalendar = Calendar.current
        let _: NSCalendar.Unit = .day
        let timeDifference2 = userCalendar.dateComponents(
            [.hour, .minute],
            from: startTime2,
            to: endTime2)
        return timeDifference2
    }
    
    func calculateDifference(_ hora1: Date!, hora2: Date!, hora3: Date!, hora4: Date!) -> String {
        var caseSelected = 1
        var somaMin = 0
        var somaHor = 0
        var timeDifference1: DateComponents?
        var timeDifference2: DateComponents?
        
        let _: NSCalendar.Unit = [.hour, .minute]
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
            somaMin = timeDifference1!.minute! + timeDifference2!.minute!
            somaHor = timeDifference1!.hour! + timeDifference2!.hour!
            break
        case 2:
            timeDifference1 = calculateDifference1(StartTime1: hora1, EndTime1: hora2)
            somaMin = timeDifference1!.minute!
            somaHor = timeDifference1!.hour!
            break
        case 3:
            timeDifference2 = calculateDifference2(StartTime2: hora3, EndTime2: hora4)
            somaMin = timeDifference2!.minute!
            somaHor = timeDifference2!.hour!
            break
        case 4:
            timeDifference1 = calculateDifference1(StartTime1: hora1, EndTime1: hora4)
            somaMin = timeDifference1!.minute!
            somaHor = timeDifference1!.hour!
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
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var somaFormatada: Date!
        somaFormatada = formatter.date(from: String(somaHor) + ":" + String(somaMin))
        if somaFormatada != nil {
            let somaString = formatter.string(from: somaFormatada!)
            return somaString
        } else {
            return "erro no cálculo!"
        }
    }
}

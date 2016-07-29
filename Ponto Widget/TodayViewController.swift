//
//  TodayViewController.swift
//  Ponto Widget
//
//  Created by Fernando Cani on 9/11/15.
//  Copyright © 2015 Fernando Cani. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblHora1: UILabel!
    @IBOutlet var lblHora2: UILabel!
    @IBOutlet var lblHora3: UILabel!
    @IBOutlet var lblHora4: UILabel!
    @IBOutlet var btnHora1: UIButton!
    @IBOutlet var btnHora2: UIButton!
    @IBOutlet var btnHora3: UIButton!
    @IBOutlet var btnHora4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        lblDate.text = formatter.string(from: Date())
        
        
//        let defaultTimes = DataStore.sharedInstance.getAllDefaultTime()
//        lblHora1.text = defaultTimes[0] as? String
//        lblHora2.text = defaultTimes[1] as? String
//        lblHora3.text = defaultTimes[2] as? String
//        lblHora4.text = defaultTimes[3] as? String
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "HH:mm"
//        lblHora1.text = formatter.stringFromDate(NSDate())
        
        let defaults = UserDefaults(suiteName: "group.br.com.fernandocani.ponto")
        let hora1 = (defaults!.object(forKey: "hora1") as! String)
        let hora2 = (defaults!.object(forKey: "hora2") as! String)
        let hora3 = (defaults!.object(forKey: "hora3") as! String)
        let hora4 = (defaults!.object(forKey: "hora4") as! String)
        
        lblHora1.text = hora1
        lblHora2.text = hora2
        lblHora3.text = hora3
        lblHora4.text = hora4
        
        if hora1 == "--:--" {
            lblHora1.textColor = UIColor.red()
        } else {
            lblHora1.textColor = UIColor.green()
        }
        
        if hora2 == "--:--" {
            lblHora2.textColor = UIColor.red()
        } else {
            lblHora2.textColor = UIColor.green()
        }
        
        if hora3 == "--:--" {
            lblHora3.textColor = UIColor.red()
        } else {
            lblHora3.textColor = UIColor.green()
        }
        
        if hora4 == "--:--" {
            lblHora4.textColor = UIColor.red()
        } else {
            lblHora4.textColor = UIColor.green()
        }
        
        completionHandler(NCUpdateResult.newData)
    }
}

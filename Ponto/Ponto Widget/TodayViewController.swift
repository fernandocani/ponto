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
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        lblDate.text = formatter.stringFromDate(NSDate())
        
        
//        let defaultTimes = DataStore.sharedInstance.getAllDefaultTime()
//        lblHora1.text = defaultTimes[0] as? String
//        lblHora2.text = defaultTimes[1] as? String
//        lblHora3.text = defaultTimes[2] as? String
//        lblHora4.text = defaultTimes[3] as? String
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "HH:mm"
//        lblHora1.text = formatter.stringFromDate(NSDate())
        
        let defaults = NSUserDefaults(suiteName: "group.br.com.fernandocani.ponto")
        let hora1 = (defaults!.objectForKey("hora1") as! String)
        let hora2 = (defaults!.objectForKey("hora2") as! String)
        let hora3 = (defaults!.objectForKey("hora3") as! String)
        let hora4 = (defaults!.objectForKey("hora4") as! String)
        
        lblHora1.text = hora1
        lblHora2.text = hora2
        lblHora3.text = hora3
        lblHora4.text = hora4
        
        if hora1 == "--:--" {
            lblHora1.textColor = UIColor.redColor()
        } else {
            lblHora1.textColor = UIColor.greenColor()
        }
        
        if hora2 == "--:--" {
            lblHora2.textColor = UIColor.redColor()
        } else {
            lblHora2.textColor = UIColor.greenColor()
        }
        
        if hora3 == "--:--" {
            lblHora3.textColor = UIColor.redColor()
        } else {
            lblHora3.textColor = UIColor.greenColor()
        }
        
        if hora4 == "--:--" {
            lblHora4.textColor = UIColor.redColor()
        } else {
            lblHora4.textColor = UIColor.greenColor()
        }
        
        completionHandler(NCUpdateResult.NewData)
    }
}
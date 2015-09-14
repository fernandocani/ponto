//
//  MainViewController.swift
//  
//
//  Created by Fernando Cani on 8/24/15.
//
//

import UIKit

// MARK: - ViewController
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnTrash: UIBarButtonItem!

    // MARK: - Variables
    var dataArray = NSArray()
    var cellArray = NSMutableArray()
    var yearsString     = NSMutableArray()
    var monthsString    = NSMutableArray()
    var daysString      = NSMutableArray()
    var daysAuxString   = NSMutableArray()
    var yearsArray      = NSMutableArray()
    var monthsArray     = NSMutableArray()
    var daysArray       = NSMutableArray()
    var anoSelecionado  = "2015"
    
    var ano = NSMutableDictionary()
    var meses = NSMutableDictionary()
    var dias = NSMutableDictionary()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setWidget()
    }
    
    override func viewWillAppear(animated: Bool) {
        clearInformations()
        populate()
        tableView.reloadData()
    }
    
    func setWidget() {
        let defaults = NSUserDefaults(suiteName: "group.br.com.fernandocani.ponto")
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let date = DataStore.sharedInstance.getRecordByDate(formatter.dateFromString(formatter.stringFromDate(NSDate()))!)
        
        if date == nil {
            defaults!.setObject("--:--", forKey: "hora1")
            defaults!.setObject("--:--", forKey: "hora2")
            defaults!.setObject("--:--", forKey: "hora3")
            defaults!.setObject("--:--", forKey: "hora4")
        } else {
            let data = (date as Record).date
            let record = ((DataStore.sharedInstance.getRecordByDate(data)) as Record)
            defaults!.setObject(record.time1, forKey: "hora1")
            defaults!.setObject(record.time2, forKey: "hora2")
            defaults!.setObject(record.time3, forKey: "hora3")
            defaults!.setObject(record.time4, forKey: "hora4")
        }
        defaults!.synchronize()
    }
    
    func clearInformations() {
        yearsArray.removeAllObjects()
        monthsArray.removeAllObjects()
        daysArray.removeAllObjects()
        yearsString.removeAllObjects()
        monthsString.removeAllObjects()
        daysString.removeAllObjects()
        dataArray = []
    }
    
    // MARK: - Populate
    func populate() {
        clearInformations()
        let formatter = NSDateFormatter()
        //Faz um sort por Data
        dataArray = DataStore.sharedInstance.getAllRecords()
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
        dataArray = dataArray.sortedArrayUsingDescriptors([sortDescriptor1])
        formatter.dateFormat = "dd/MM/yyyy"
        if dataArray.count == 0 {
            return
        }
        // Vai varrer todo mundo do dataArray
        if dataArray.count > 0 {
            formatter.dateFormat = "yyyy"
            if yearsString.count > 0 {
                yearsString.removeAllObjects()
            }
            for valor1 in 0...(dataArray.count - 1) {
                if yearsString.count == 0 {
                    yearsString.addObject(formatter.stringFromDate((dataArray[valor1] as! Record).date))
                } else {
                    var validacao = false
                    for valor2 in 0...(yearsString.count - 1) {
                        if (formatter.stringFromDate((dataArray[valor1] as! Record).date) == yearsString[valor2] as! String) {
                            validacao = true
                            break
                        }
                    }
                    if validacao == false {
                        yearsString.addObject(formatter.stringFromDate((dataArray[valor1] as! Record).date))
                    }
                }
            }
            
            //String com todos os Anos do dataArray
            for valor3 in 0...(yearsString.count - 1) {
                if yearsArray.count > 0 {
                    yearsArray.removeAllObjects()
                }
                formatter.dateFormat = "yyyy"
                for valor4 in 0...(dataArray.count - 1) {
                    if formatter.stringFromDate((dataArray[valor4] as! Record).date) == yearsString[valor3] as! String {
                        yearsArray.addObject(dataArray[valor4])
                    }
                }
                
                //Array por Ano
                if monthsString.count > 0 {
                    monthsString.removeAllObjects()
                }
                for valor5 in 0...(yearsArray.count - 1) {
                    formatter.dateFormat = "MM"
                    if monthsString.count == 0 {
                        monthsString.addObject(formatter.stringFromDate((yearsArray[valor5] as! Record).date))
                    } else {
                        var validacao = false
                        for valor6 in 0...(monthsString.count - 1) {
                            if (formatter.stringFromDate((yearsArray[valor5] as! Record).date) == monthsString[valor6] as! String) {
                                validacao = true
                                break
                            }
                        }
                        if validacao == false {
                            monthsString.addObject(formatter.stringFromDate((yearsArray[valor5] as! Record).date))
                        }
                    }
                }
                
                //Todos os meses do yearsArray
                for valor7 in 0...(monthsString.count - 1) {
                    if monthsArray.count > 0 {
                        monthsArray.removeAllObjects()
                    }
                    formatter.dateFormat = "MM"
                    for valor8 in 0...(yearsArray.count - 1) {
                        if formatter.stringFromDate((yearsArray[valor8] as! Record).date) == monthsString[valor7] as! String {
                            monthsArray.addObject(yearsArray[valor8])
                        }
                    }
                    
                    //Separa por Mês
                    if daysString.count > 0 {
                        daysString.removeAllObjects()
                    }
                    for valor9 in 0...(monthsArray.count - 1) {
                        formatter.dateFormat = "dd"
                        if daysString.count == 0 {
                            daysString.addObject(formatter.stringFromDate((monthsArray[valor9] as! Record).date))
                        } else {
                            var validacao = false
                            for valor10 in 0...(daysString.count - 1) {
                                if (formatter.stringFromDate((monthsArray[valor9] as! Record).date) == daysString[valor10] as! String) {
                                    validacao = true
                                    break
                                }
                            }
                            if validacao == false {
                                daysString.addObject(formatter.stringFromDate((monthsArray[valor9] as! Record).date))
                            }
                        }
                    }
                    
                    //Todos os dias do monthsArray
                    if daysArray.count > 0 {
                        daysArray.removeAllObjects()
                    }
                    for valor11 in 0...(daysString.count - 1) {
                        formatter.dateFormat = "dd"
                        for valor12 in 0...(monthsArray.count - 1) {
                            if formatter.stringFromDate((monthsArray[valor12] as! Record).date) == daysString[valor11] as! String {
                                daysArray.addObject(monthsArray[valor12])
                            }
                        }
                    }
                    
                    //Separa por Dia
                    for valor13 in 0...(daysArray.count - 1) {
                        let diaSelecionado = daysArray[valor13] as! Record
                        dias.setObject(diaSelecionado, forKey: "\(daysString[valor13])")
                    }
                    meses.setObject(dias, forKey: "\(monthsString[valor7])")
                    dias = NSMutableDictionary()
                }
                ano.setObject(meses, forKey: "\(yearsString[valor3])")
                meses = NSMutableDictionary()
            }
        }
        populateMonths()
    }
    
    func populateMonths() {
        if monthsString.count > 0 {
            monthsString.removeAllObjects()
        }
        if (ano.objectForKey(anoSelecionado)) != nil {
            monthsString.addObjectsFromArray((ano.objectForKey(anoSelecionado) as! NSDictionary).allKeys)
            let arrayAux2 = NSMutableArray()
            for valor14 in 0...(monthsString.count - 1) {
                let str: String = (monthsString[valor14]) as! String
                arrayAux2.addObject(str)
            }
            //Sort os Arrays
            let arrayAux:NSArray = arrayAux2.sortedArrayUsingSelector("localizedCaseInsensitiveCompare:")
            monthsString.removeAllObjects()
            for (var valor15 = arrayAux.count; valor15 > 0; valor15--) {
                monthsString.addObject(arrayAux.objectAtIndex(valor15 - 1))
            }
            populateDays()
        }
    }
    
    func populateDays() {
        if daysAuxString.count > 0 {
            daysAuxString.removeAllObjects()
        }
        for valor in 0...(monthsString.count - 1) {
            let daysString2 = NSMutableArray()
            if (ano.objectForKey(anoSelecionado)?.objectForKey((monthsString[valor]) as! String) != nil) {
                let _ = ((ano.objectForKey(anoSelecionado)?.objectForKey((monthsString[valor] as! String))) as! NSDictionary).count
                daysString2.addObjectsFromArray((ano.objectForKey(anoSelecionado)?.objectForKey(monthsString[valor]) as! NSDictionary).allKeys)
                let arrayAux2 = NSMutableArray()
                for valor1 in 0...(daysString2.count - 1) {
                    let str: String = (daysString2[valor1]) as! String
                    arrayAux2.addObject(str)
                }
                //Sort os Arrays
                let arrayAux:NSArray = arrayAux2.sortedArrayUsingSelector("localizedCaseInsensitiveCompare:")
                daysString2.removeAllObjects()
                for (var valor2 = arrayAux.count; valor2 > 0; valor2--) {
                    daysString2.addObject(arrayAux.objectAtIndex(valor2 - 1))
                }
                daysAuxString.insertObject(daysString2, atIndex: daysAuxString.count)
            }
        }
    }
    
    // MARK: - Calculate
    func calculateTotal(month: String) -> String {
        let month: AnyObject? = ano.objectForKey(anoSelecionado)?.objectForKey(month)
        if (month != nil) {
            let days = (month as! NSDictionary).allKeys
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            let totalPorDiaHor = NSMutableArray()
            let totalPorDiaMin = NSMutableArray()
            for valor1 in 0...(days.count - 1) {
                totalPorDiaHor.addObject(Int((month?.objectForKey(days[valor1]) as! Record).totalHor))
                totalPorDiaMin.addObject(Int((month?.objectForKey(days[valor1]) as! Record).totalMin))
            }
            var somaHor = 0
            var somaMin = 0
            for valor2 in 0...(days.count - 1) {
                somaHor = somaHor + Int(totalPorDiaHor[valor2] as! NSNumber)
                somaMin = somaMin + Int(totalPorDiaMin[valor2] as! NSNumber)
            }
            if somaMin > 60 {
                let divisao = Int(floor(Float(somaMin) / Float(60)))
                for _ in 0...(divisao - 1) {
                    somaMin = somaMin - 60
                    somaHor = somaHor + 1
                }
            }
            var stringHor = String(somaHor)
            var stringMin = String(somaMin)
            if somaHor < 10 {
                stringHor = "0" + stringHor
            }
            if somaMin < 10 {
                stringMin = "0" + stringMin
            }
            return stringHor + ":" + stringMin
        } else {
            return "Deu ruim"
        }
    }
    
    func calculateTotalDifference(totalTrabalhado: String, totalParaTrabalhar: String) -> String {
        let arrayTotalTrabalhado = totalTrabalhado.componentsSeparatedByString(":")
        var horTrabalhado = Int(arrayTotalTrabalhado[0])!
        var minTrabalhado = Int(arrayTotalTrabalhado[1])!
        let arrayTotalParaTrabalhar = totalParaTrabalhar.componentsSeparatedByString(":")
        let horParaTrabalhar = Int(arrayTotalParaTrabalhar[0])!
        let minParaTrabalhar = Int(arrayTotalParaTrabalhar[1])!
        if minTrabalhado < minParaTrabalhar {
            minTrabalhado = minTrabalhado + 60
            horTrabalhado = horTrabalhado - 1
        }
        let difMin = minTrabalhado - minParaTrabalhar
        let difHor = horTrabalhado - horParaTrabalhar
        var stringDifHor = String(difHor)
        var stringDifMin = String(difMin)
        if difMin < 10 && difMin >= 0 {
            stringDifMin = "0" + stringDifMin
        }
        if difHor < 10 && difHor >= 0{
            stringDifHor = "0" + stringDifHor
        }
        if difHor < 0 && difHor > -10 {
            stringDifHor = "-0" + String(-difHor)
        }
        return stringDifHor + ":" + stringDifMin
    }
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return monthsString.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var daysCount = 0
        var totalHor = Int16(0)
        var totalMin = Int16(0)
        var days = NSDictionary()
        if (((ano.objectForKey(anoSelecionado)?.objectForKey((monthsString[section] as! String)))) != nil) {
            days = ((ano.objectForKey(anoSelecionado)?.objectForKey((monthsString[section] as! String))) as! NSDictionary)
            daysCount = days.count
            
            totalHor = ((DataStore.sharedInstance.getAllDefaultTime().firstObject) as! DefaultTime).totalHor * Int16(daysCount)
            totalMin = ((DataStore.sharedInstance.getAllDefaultTime().firstObject) as! DefaultTime).totalMin * Int16(daysCount)
            if totalMin > 60 {
                let countMin = Int(floor(Float(totalMin) / Float(60)))
                for _ in 0...(countMin - 1) {
                    totalMin = totalMin - 60
                    totalHor = totalHor + 1
                }
            }
            
            daysCount = daysCount * 8
        }
        var mesTitle = monthsString[section] as! String
        let mesTitleNum = mesTitle
        switch(mesTitle) {
        case "01":
            mesTitle = "Janeiro"
            break
        case "02":
            mesTitle = "Fevereiro"
            break
        case "03":
            mesTitle = "Março"
            break
        case "04":
            mesTitle = "Abril"
            break
        case "05":
            mesTitle = "Maio"
            break
        case "06":
            mesTitle = "Junho"
            break
        case "07":
            mesTitle = "Julho"
            break
        case "08":
            mesTitle = "Agosto"
            break
        case "09":
            mesTitle = "Setembro"
            break
        case "10":
            mesTitle = "Outubro"
            break
        case "11":
            mesTitle = "Novembro"
            break
        case "12":
            mesTitle = "Dezembro"
            break
        default:
            mesTitle = ""
            break
        }
        let totalTrabalhado = calculateTotal(mesTitleNum)
        
        var strHor = String(totalHor)
        var strMin = String(totalMin)
        if totalHor < 10 && totalHor >= 0 {
            strHor = "0" + strHor
        }
        if totalMin < 10 && totalMin >= 0 {
            strMin = "0" + strMin
        }
        let totalParaTrabalhar = strHor + ":" + strMin
        
        mesTitle = mesTitle + " - " + totalTrabalhado + " / " + totalParaTrabalhar + " | " + calculateTotalDifference(totalTrabalhado, totalParaTrabalhar: totalParaTrabalhar)
        return mesTitle
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mesesCount = 0
        if (((ano.objectForKey(anoSelecionado)?.objectForKey((monthsString[section] as! String)))) != nil) {
            mesesCount = ((ano.objectForKey(anoSelecionado)?.objectForKey((monthsString[section] as! String))) as! NSDictionary).count
        }
        return mesesCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! TableViewCell
        if monthsString.count != 0 {
            let mesSelecionado: (AnyObject?) = (ano.objectForKey(anoSelecionado)!.objectForKey(monthsString[indexPath.section])!.objectForKey((daysAuxString[indexPath.section] as! NSArray)[indexPath.row] as! String))
            let diaSelecionado = (mesSelecionado as! Record)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd" //"dd EEEE"
            cell.lblDate.text = "Dia " + formatter.stringFromDate(diaSelecionado.date)
//            formatter.timeZone = NSTimeZone(abbreviation: "GMT-00")
            var hora1 = diaSelecionado.time1
            var hora2 = diaSelecionado.time2
            var hora3 = diaSelecionado.time3
            var hora4 = diaSelecionado.time4
            
            
            formatter.dateFormat = "HH:mm"
            var total = EditSingleton.sharedInstance.calculateDifference(formatter.dateFromString(hora1), hora2: formatter.dateFromString(hora2), hora3: formatter.dateFromString(hora3), hora4: formatter.dateFromString(hora4))
            if hora1 == "--:--" {
                hora1 = "00:00"
            }
            if hora2 == "--:--" {
                hora2 = "00:00"
            }
            if hora3 == "--:--" {
                hora3 = "00:00"
            }
            if hora4 == "--:--" {
                hora4 = "00:00"
            }
            if total == "00:00" {
                total = "--:--"
            }
            cell.lblDate.text = cell.lblDate.text! + " | Total: " + total
            cell.lblTime.text = diaSelecionado.time1 + " / " + diaSelecionado.time2 + " / " + diaSelecionado.time3 + " / " + diaSelecionado.time4
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let mesSelecionado = (ano.objectForKey(anoSelecionado)!.objectForKey(monthsString[indexPath.section])!.objectForKey((daysAuxString[indexPath.section] as! NSArray)[indexPath.row] as! String) as! Record)
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if DataStore.sharedInstance.removeRecordByDate(mesSelecionado.date) {
                populate()
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                if tableView.numberOfRowsInSection(indexPath.section) == 1 {
                    tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                }
                tableView.endUpdates()
                tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        EditSingleton.sharedInstance.dateSelected = (ano.objectForKey(anoSelecionado)!.objectForKey(monthsString[indexPath.section])!.objectForKey((daysAuxString[indexPath.section] as! NSArray)[indexPath.row] as! String) as! Record).date
    }
}

// MARK: - TableViewCell
class TableViewCell: UITableViewCell {
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
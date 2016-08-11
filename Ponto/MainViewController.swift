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
    var anoSelecionado  = "2016"
    
    var ano     = NSMutableDictionary()
    var meses   = NSMutableDictionary()
    var dias    = NSMutableDictionary()
    
    let dateFormatter = DateFormatter()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
//        setWidget()
        
        if (DataStore.sharedInstance.getAllDefaultTime().count <= 0) {
            let hor1 = "08:00"
            let hor2 = "12:00"
            let hor3 = "14:00"
            let hor4 = "18:00"
            
            
            dateFormatter.dateFormat! = "HH:mm"
            print(dateFormatter)
            print(dateFormatter.date(from: hor1))
            let time1 = dateFormatter.date(from: hor1)
            let time2 = dateFormatter.date(from: hor2)
            let time3 = dateFormatter.date(from: hor3)
            let time4 = dateFormatter.date(from: hor4)
            
            let userCalendar = Calendar.current
            let _: NSCalendar.Unit = .day
            let startTime1 = time1
            let endTime1 = time2
            let timeDifference1 = userCalendar.dateComponents(
                [.hour, .minute],
                from:   startTime1!,
                to:     endTime1!)
            let startTime2 = time3
            let endTime2 = time4
            let timeDifference2 = userCalendar.dateComponents(
                [.hour, .minute],
                from:   startTime2!,
                to:     endTime2!)
            var somaMin = timeDifference1.minute! + timeDifference2.minute!
            var somaHor = timeDifference1.hour! + timeDifference2.hour!
            if somaMin >= 60 {
                somaHor = somaHor + 1
                somaMin = somaMin - 60
            }
            let totalHor = Int16(somaHor)
            let totalMin = Int16(somaMin)
            DataStore.sharedInstance.saveDataDefaultTime(Time1: hor1, Time2: hor2, Time3: hor3, Time4: hor4, TotalHor: totalHor, TotalMin: totalMin)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearInformations()
        populate()
        tableView.reloadData()
    }
    
    func setWidget() {
        let defaults = UserDefaults(suiteName: "group.br.com.fernandocani.ponto")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let date = DataStore.sharedInstance.getRecordByDate(formatter.date(from: formatter.string(from: Date()))!)
        
        if date == nil {
            defaults!.set("--:--", forKey: "hora1")
            defaults!.set("--:--", forKey: "hora2")
            defaults!.set("--:--", forKey: "hora3")
            defaults!.set("--:--", forKey: "hora4")
        } else {
            let data = (date! as Record).date
            let record = ((DataStore.sharedInstance.getRecordByDate(data)) as Record)
            defaults!.set(record.time1, forKey: "hora1")
            defaults!.set(record.time2, forKey: "hora2")
            defaults!.set(record.time3, forKey: "hora3")
            defaults!.set(record.time4, forKey: "hora4")
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
        let formatter = DateFormatter()
        //Faz um sort por Data
        dataArray = DataStore.sharedInstance.getAllRecords()
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
        dataArray = dataArray.sortedArray(using: [sortDescriptor1])
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
                    yearsString.add(formatter.string(from: (dataArray[valor1] as! Record).date as Date))
                } else {
                    var validacao = false
                    for valor2 in 0...(yearsString.count - 1) {
                        if (formatter.string(from: (dataArray[valor1] as! Record).date as Date) == yearsString[valor2] as! String) {
                            validacao = true
                            break
                        }
                    }
                    if validacao == false {
                        yearsString.add(formatter.string(from: (dataArray[valor1] as! Record).date as Date))
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
                    if formatter.string(from: (dataArray[valor4] as! Record).date as Date) == yearsString[valor3] as! String {
                        yearsArray.add(dataArray[valor4])
                    }
                }
                
                //Array por Ano
                if monthsString.count > 0 {
                    monthsString.removeAllObjects()
                }
                for valor5 in 0...(yearsArray.count - 1) {
                    formatter.dateFormat = "MM"
                    if monthsString.count == 0 {
                        monthsString.add(formatter.string(from: (yearsArray[valor5] as! Record).date as Date))
                    } else {
                        var validacao = false
                        for valor6 in 0...(monthsString.count - 1) {
                            if (formatter.string(from: (yearsArray[valor5] as! Record).date as Date) == monthsString[valor6] as! String) {
                                validacao = true
                                break
                            }
                        }
                        if validacao == false {
                            monthsString.add(formatter.string(from: (yearsArray[valor5] as! Record).date as Date))
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
                        if formatter.string(from: (yearsArray[valor8] as! Record).date as Date) == monthsString[valor7] as! String {
                            monthsArray.add(yearsArray[valor8])
                        }
                    }
                    
                    //Separa por Mês
                    if daysString.count > 0 {
                        daysString.removeAllObjects()
                    }
                    for valor9 in 0...(monthsArray.count - 1) {
                        formatter.dateFormat = "dd"
                        if daysString.count == 0 {
                            daysString.add(formatter.string(from: (monthsArray[valor9] as! Record).date as Date))
                        } else {
                            var validacao = false
                            for valor10 in 0...(daysString.count - 1) {
                                if (formatter.string(from: (monthsArray[valor9] as! Record).date as Date) == daysString[valor10] as! String) {
                                    validacao = true
                                    break
                                }
                            }
                            if validacao == false {
                                daysString.add(formatter.string(from: (monthsArray[valor9] as! Record).date as Date))
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
                            if formatter.string(from: (monthsArray[valor12] as! Record).date as Date) == daysString[valor11] as! String {
                                daysArray.add(monthsArray[valor12])
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
        if (ano.object(forKey: anoSelecionado)) != nil {
            monthsString.addObjects(from: (ano.object(forKey: anoSelecionado) as! NSDictionary).allKeys)
            let arrayAux2 = NSMutableArray()
            for valor14 in 0...(monthsString.count - 1) {
                let str: String = (monthsString[valor14]) as! String
                arrayAux2.add(str)
            }
            //Sort os Arrays
            let arrayAux:NSArray = arrayAux2.sortedArray(using: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            monthsString.removeAllObjects()
            for valor15 in ((0 + 1)...arrayAux.count).reversed() {
                monthsString.add(arrayAux.object(at: valor15 - 1))
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
            if (ano.object(forKey: anoSelecionado)?.object(forKey: (monthsString[valor]) as! String) != nil) {
                let _ = ((ano.object(forKey: anoSelecionado)?.object(forKey: (monthsString[valor] as! String))) as! NSDictionary).count
                daysString2.addObjects(from: ((ano.object(forKey: anoSelecionado) as! NSDictionary).object(forKey: monthsString[valor]) as! NSDictionary).allKeys)
                let arrayAux2 = NSMutableArray()
                for valor1 in 0...(daysString2.count - 1) {
                    let str: String = (daysString2[valor1]) as! String
                    arrayAux2.add(str)
                }
                //Sort os Arrays
                let arrayAux:NSArray = arrayAux2.sortedArray(using: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
                daysString2.removeAllObjects()
                for valor2 in ((0 + 1)...arrayAux.count).reversed() {
                    daysString2.add(arrayAux.object(at: valor2 - 1))
                }
                daysAuxString.insert(daysString2, at: daysAuxString.count)
            }
        }
    }
    
    // MARK: - Calculate
    func calculateTotal(_ month: String) -> String {
        let month: AnyObject? = ano.object(forKey: anoSelecionado)?.object(forKey: month)
        if (month != nil) {
            let days = (month as! NSDictionary).allKeys
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let totalPorDiaHor = NSMutableArray()
            let totalPorDiaMin = NSMutableArray()
            for valor1 in 0...(days.count - 1) {
                totalPorDiaHor.add(Int(((month as! NSDictionary).object(forKey: days[valor1]) as! Record).totalHor))
                totalPorDiaMin.add(Int(((month as! NSDictionary).object(forKey: days[valor1]) as! Record).totalMin))
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
    
    func calculateTotalDifference(_ totalTrabalhado: String, totalParaTrabalhar: String) -> String {
        let arrayTotalTrabalhado = totalTrabalhado.components(separatedBy: ":")
        var horTrabalhado = Int(arrayTotalTrabalhado[0])!
        var minTrabalhado = Int(arrayTotalTrabalhado[1])!
        let arrayTotalParaTrabalhar = totalParaTrabalhar.components(separatedBy: ":")
        let horParaTrabalhar = Int(arrayTotalParaTrabalhar[0])!
        let minParaTrabalhar = Int(arrayTotalParaTrabalhar[1])!
        
        
        if horParaTrabalhar == horTrabalhado {
            //Horas iguais
            if minParaTrabalhar == minTrabalhado {
                //Minutos iguais
            } else if minParaTrabalhar > minTrabalhado {
                //Mais Trabalhou
            } else if minParaTrabalhar < minTrabalhado {
                //Menos trabalhou
            }
        } else if horParaTrabalhar > horTrabalhado {
            //Mais trabalhou
        } else if horParaTrabalhar < horTrabalhado {
            //Menos trabalhou
        }
        
        
        
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return monthsString.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var daysCount = 0
        var totalHor = Int16(0)
        var totalMin = Int16(0)
        var days = NSDictionary()
        if (((ano.object(forKey: anoSelecionado)?.object(forKey: (monthsString[section] as! String)))) != nil) {
            days = ((ano.object(forKey: anoSelecionado)?.object(forKey: (monthsString[section] as! String))) as! NSDictionary)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mesesCount = 0
        if (((ano.object(forKey: anoSelecionado)?.object(forKey: (monthsString[section] as! String)))) != nil) {
            mesesCount = ((ano.object(forKey: anoSelecionado)?.object(forKey: (monthsString[section] as! String))) as! NSDictionary).count
        }
        return mesesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        if monthsString.count != 0 {
            let mesSelecionado: (AnyObject?) = ((ano.object(forKey: anoSelecionado) as! NSDictionary).object(forKey: monthsString[(indexPath as NSIndexPath).section])!.object(forKey: (daysAuxString[(indexPath as NSIndexPath).section] as! NSArray)[(indexPath as NSIndexPath).row] as! String))
            let diaSelecionado = (mesSelecionado as! Record)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd" //"dd EEEE"
            cell.lblDate.text = "Dia " + formatter.string(from: diaSelecionado.date as Date)
//            formatter.timeZone = NSTimeZone(abbreviation: "GMT-00")
            var hora1 = diaSelecionado.time1
            var hora2 = diaSelecionado.time2
            var hora3 = diaSelecionado.time3
            var hora4 = diaSelecionado.time4
            
            
            formatter.dateFormat = "HH:mm"
            var total = EditSingleton.sharedInstance.calculateDifference(formatter.date(from: hora1), hora2: formatter.date(from: hora2), hora3: formatter.date(from: hora3), hora4: formatter.date(from: hora4))
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
            cell.lblHora1.text = diaSelecionado.time1
            cell.lblHora2.text = diaSelecionado.time2
            cell.lblHora3.text = diaSelecionado.time3
            cell.lblHora4.text = diaSelecionado.time4
            
            formatter.dateFormat = "EEEE"
            let dayOfWeek = formatter.string(from: diaSelecionado.date as Date)
            switch (dayOfWeek) {
            case "Monday":
                cell.lblWeekday.text = " M"
                cell.lblWeekday.backgroundColor = UIColor.red
//                cell.lblWeekday.backgroundColor = UIColor.clearColor()
//                let gradient: CAGradientLayer = CAGradientLayer()
//                gradient.frame = cell.lblWeekday.bounds
//                gradient.colors = [UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor]
//                cell.lblWeekday.layer.insertSublayer(gradient, atIndex: 0)
                break
            case "Tuesday":
                cell.lblWeekday.text = " T"
                cell.lblWeekday.backgroundColor = UIColor.orange
                break
            case "Wednesday":
                cell.lblWeekday.text = " W"
                cell.lblWeekday.backgroundColor = UIColor.yellow
                break
            case "Thursday":
                cell.lblWeekday.text = " T"
                cell.lblWeekday.backgroundColor = UIColor.blue
                break
            case "Friday":
                cell.lblWeekday.text = " F"
                cell.lblWeekday.backgroundColor = UIColor.green
                break
            case "Saturday":
                cell.lblWeekday.text = " S"
                cell.lblWeekday.backgroundColor = UIColor.lightGray
                break
            case "Sunday":
                cell.lblWeekday.text = " S"
                cell.lblWeekday.backgroundColor = UIColor.gray
                break
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let mesSelecionado = ((ano.object(forKey: anoSelecionado)! as! NSDictionary).object(forKey: monthsString[(indexPath as NSIndexPath).section])!.object(forKey: (daysAuxString[(indexPath as NSIndexPath).section] as! NSArray)[(indexPath as NSIndexPath).row] as! String) as! Record)
        if editingStyle == UITableViewCellEditingStyle.delete {
            if DataStore.sharedInstance.removeRecordByDate(mesSelecionado.date) {
                populate()
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if tableView.numberOfRows(inSection: (indexPath as NSIndexPath).section) == 1 {
                    tableView.deleteSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .automatic)
                }
                tableView.endUpdates()
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EditSingleton.sharedInstance.dateSelected = ((ano.object(forKey: anoSelecionado)! as! NSDictionary).object(forKey: monthsString[(indexPath as NSIndexPath).section])!.object(forKey: (daysAuxString[(indexPath as NSIndexPath).section] as! NSArray)[(indexPath as NSIndexPath).row] as! String) as! Record).date
    }
}

// MARK: - TableViewCell
class TableViewCell: UITableViewCell {
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblHora1: UILabel!
    @IBOutlet var lblHora2: UILabel!
    @IBOutlet var lblHora3: UILabel!
    @IBOutlet var lblHora4: UILabel!
    @IBOutlet var lblWeekday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//
//  SettingsViewController.swift
//  
//
//  Created by Fernando Cani on 8/31/15.
//
//

import UIKit

class SettingsViewController: UIViewController, SMDatePickerDelegate {
    
    @IBOutlet var btnHora1: UIButton!
    @IBOutlet var btnHora2: UIButton!
    @IBOutlet var btnHora3: UIButton!
    @IBOutlet var btnHora4: UIButton!
    
    var pickerAtual = ""
    var picker: SMDatePicker = SMDatePicker()
    var activePicker: SMDatePicker?
    var btnSelected = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    // MARK: - Populate
    
    func populateData() {
        let defaultTime = DataStore.sharedInstance.getAllDefaultTime()
        let strHora1 = (defaultTime.firstObject as! DefaultTime).time1
        let strHora2 = (defaultTime.firstObject as! DefaultTime).time2
        let strHora3 = (defaultTime.firstObject as! DefaultTime).time3
        let strHora4 = (defaultTime.firstObject as! DefaultTime).time4
        btnHora1.setTitle(strHora1, forState: .Normal)
        btnHora2.setTitle(strHora2, forState: .Normal)
        btnHora3.setTitle(strHora3, forState: .Normal)
        btnHora4.setTitle(strHora4, forState: .Normal)
    }
    
    func populateTxt() {
        if DataStore.sharedInstance.getAllRecords().count > 0 {
            DataStore.sharedInstance.removeAllRecords()
        }
        let formatter = NSDateFormatter()
        var splitText1: NSArray             = [] //
        var splitText2: NSArray             = [] //
        var splitText3: NSArray             = [] //
        var splitText4: NSArray             = [] //
        var splitText5: NSArray             = [] //
        var splitText6: NSArray             = [] //
        
        let path = NSBundle.mainBundle().pathForResource("ImportData", ofType: "txt")
        let txt: String?
        do {
            txt = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch _ {
            txt = nil
        }
        
        splitText1 = txt!.componentsSeparatedByString("*")
        for valor in 0...(splitText1.count - 1) {
            if (splitText1[valor] as! String) != "" {
                //Quebra em |, divisões de clubes
                splitText2 = splitText1[valor].componentsSeparatedByString("\n")
                //Ano/Mês
                splitText3 = splitText2.objectAtIndex(0).componentsSeparatedByString("+")
                let anoTxt = splitText3[0] as! String
                let mesTxt = splitText3[1] as! String
                //Varre o resto
                for valor1 in 1...(splitText2.count - 1) {
                    //splitText3 = array de linhas de Dias
                    splitText4 = splitText2.objectAtIndex(valor1).componentsSeparatedByString("#")
                    //splitText4 = array da linhas por Horarios
                    let diaTxt = splitText4.objectAtIndex(0) as! String
                    if splitText4.count > 1 {
                        splitText5 = splitText4.objectAtIndex(1).componentsSeparatedByString("|")
                        var hor1Txt = splitText5.objectAtIndex(0) as! String
                        var hor2Txt = splitText5.objectAtIndex(1) as! String
                        var hor3Txt = splitText5.objectAtIndex(2) as! String
                        var hor4Txt = splitText5.objectAtIndex(3) as! String
                        let comment = splitText5.objectAtIndex(4) as! String
                        if (hor1Txt == "") {
                            hor1Txt = "--:--"
                        }
                        if (hor2Txt == "") {
                            hor2Txt = "--:--"
                        }
                        if (hor3Txt == "") {
                            hor3Txt = "--:--"
                        }
                        if (hor4Txt == "") {
                            hor4Txt = "--:--"
                        }
                        formatter.dateFormat = "dd/MM/yyyy"
                        let dateTxt = formatter.dateFromString(diaTxt + "/" + mesTxt + "/" + anoTxt)
                        formatter.dateFormat = "HH:mm"
                        let hora1 = formatter.dateFromString(hor1Txt)
                        let hora2 = formatter.dateFromString(hor2Txt)
                        let hora3 = formatter.dateFromString(hor3Txt)
                        let hora4 = formatter.dateFromString(hor4Txt)
                        let totalTxt = EditSingleton.sharedInstance.calculateDifference(hora1, hora2: hora2, hora3: hora3, hora4: hora4)
                        splitText6 = totalTxt.componentsSeparatedByString(":")
                        let totalHorTxt = Int16(Int((splitText6[0] as! String))!)
                        let totalMinTxt = Int16(Int((splitText6[1] as! String))!)
                        DataStore.sharedInstance.saveData(Date: dateTxt!, Time1: hor1Txt, Time2: hor2Txt, Time3: hor3Txt, Time4: hor4Txt, Comment: comment, TotalHor: totalHorTxt, TotalMin: totalMinTxt)
                    }
                }
            }
        }
    }
    
    // MARK: - Picker
    
    func configPicker() {
        activePicker?.hidePicker(true)
        switch (btnSelected){
        case 1:
            pickerAtual = btnHora1.titleLabel!.text!
            break
        case 2:
            pickerAtual = btnHora2.titleLabel!.text!
            break
        case 3:
            pickerAtual = btnHora3.titleLabel!.text!
            break
        case 4:
            pickerAtual = btnHora4.titleLabel!.text!
            break
        default:
            pickerAtual = btnHora1.titleLabel!.text!
            break
        }
        let formatter = NSDateFormatter()
        
        picker.pickerMode = UIDatePickerMode.Time
        formatter.dateFormat = "HH:mm"
        
        picker.showPickerInView(view, animated: true)
        picker.toolbarBackgroundColor = UIColor.grayColor()
        picker.pickerBackgroundColor = UIColor.lightGrayColor()
        let data = formatter.dateFromString(pickerAtual)
        picker.pickerDate = data!
        picker.delegate = self
        activePicker = picker
    }
    
    func datePicker(picker: SMDatePicker, didPickDate date: NSDate) {
        let formatter = NSDateFormatter()
        var hora1: NSDate?
        var hora2: NSDate?
        var hora3: NSDate?
        var hora4: NSDate?
        formatter.dateFormat = "HH:mm"
        hora1 = formatter.dateFromString(btnHora1.titleLabel!.text!)
        hora2 = formatter.dateFromString(btnHora2.titleLabel!.text!)
        hora3 = formatter.dateFromString(btnHora3.titleLabel!.text!)
        hora4 = formatter.dateFromString(btnHora4.titleLabel!.text!)
        let dataFormatada = formatter.stringFromDate(date)
        let erroDeHorario = UIAlertController(title: "Erro", message: "Horário inválido, Verifiqe novamente.", preferredStyle: UIAlertControllerStyle.Alert)
        erroDeHorario.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
        switch (btnSelected){
        case 1:
            if (date.compare(hora2!) == NSComparisonResult.OrderedDescending || date.compare(hora3!) == NSComparisonResult.OrderedDescending || date.compare(hora4!) == NSComparisonResult.OrderedDescending) {
                //data 1 > data 2
                self.presentViewController(erroDeHorario, animated: true, completion: nil)
            } else {
                //data 1 < data 2
                btnHora1.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora1 = formatter.dateFromString(dataFormatada)
            }
            break
        case 2:
            if (date.compare(hora1!) == NSComparisonResult.OrderedAscending || date.compare(hora3!) == NSComparisonResult.OrderedDescending || date.compare(hora4!) == NSComparisonResult.OrderedDescending) {
                self.presentViewController(erroDeHorario, animated: true, completion: nil)
            } else {
                btnHora2.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora2 = formatter.dateFromString(dataFormatada)
            }
            break
        case 3:
            if (date.compare(hora1!) == NSComparisonResult.OrderedAscending || date.compare(hora2!) == NSComparisonResult.OrderedAscending || date.compare(hora4!) == NSComparisonResult.OrderedDescending) {
                self.presentViewController(erroDeHorario, animated: true, completion: nil)
            } else {
                btnHora3.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora3 = formatter.dateFromString(dataFormatada)
            }
            break
        case 4:
            if (date.compare(hora1!) == NSComparisonResult.OrderedAscending || date.compare(hora2!) == NSComparisonResult.OrderedAscending || date.compare(hora3!) == NSComparisonResult.OrderedAscending) {
                self.presentViewController(erroDeHorario, animated: true, completion: nil)
            } else {
                btnHora4.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora4 = formatter.dateFromString(dataFormatada)
            }
            break
        default:
            btnHora1.setTitle(dataFormatada, forState: UIControlState.Normal)
            break
        }
    }
    
    func datePickerDidCancel(picker: SMDatePicker) {
        switch (btnSelected){
        case 1:
            btnHora1.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        case 2:
            btnHora2.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        case 3:
            btnHora3.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        case 4:
            btnHora4.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        default:
            btnHora1.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        }
    }
    
    // MARK: - Btn
    
    @IBAction func btnHora1(sender: AnyObject) {
        btnSelected = 1
        configPicker()
    }
    
    @IBAction func btnHora2(sender: AnyObject) {
        btnSelected = 2
        configPicker()
    }
    
    @IBAction func btnHora3(sender: AnyObject) {
        btnSelected = 3
        configPicker()
    }
    
    @IBAction func btnHora4(sender: AnyObject) {
        btnSelected = 4
        configPicker()
    }
    
    @IBAction func btnImport(sender: UIButton) {
        populateTxt()
        let sucesso = UIAlertController(title: "Sucesso!", message: "Registro importado com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
        sucesso.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
        self.presentViewController(sucesso, animated: true, completion: nil )
    }
    
    @IBAction func btnDelete(sender: UIButton) {
        let deletarTudo = UIAlertController(title: "Atenção!", message: "Deseja apagar todos os dados?", preferredStyle: UIAlertControllerStyle.Alert)
        deletarTudo.addAction(UIAlertAction(title: "Sim", style: .Destructive, handler: { (action: UIAlertAction) in
            DataStore.sharedInstance.removeAllRecords()
            let sucesso = UIAlertController(title: "Sucesso!", message: "Registros apagados com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
            sucesso.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
            self.presentViewController(sucesso, animated: true, completion: nil )
        }))
        deletarTudo.addAction(UIAlertAction(title: "Não", style: .Cancel, handler: { (action: UIAlertAction) in }))
        self.presentViewController(deletarTudo, animated: true, completion: nil )
    }
    
    @IBAction func btnDone(sender: UIBarButtonItem) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        let strHora1 = btnHora1.titleLabel!.text
        let strHora2 = btnHora2.titleLabel!.text
        let strHora3 = btnHora3.titleLabel!.text
        let strHora4 = btnHora4.titleLabel!.text
        let hora1 = formatter.dateFromString(strHora1!)
        let hora2 = formatter.dateFromString(strHora2!)
        let hora3 = formatter.dateFromString(strHora3!)
        let hora4 = formatter.dateFromString(strHora4!)
        let dif = EditSingleton.sharedInstance.calculateDifference(hora1, hora2: hora2, hora3: hora3, hora4: hora4)
        let arrayDif = dif.componentsSeparatedByString(":")
        
        if DataStore.sharedInstance.updateDefaulTime(Time1: strHora1!, Time2: strHora2!, Time3: strHora3!, Time4: strHora4!, TotalHor: Int16(Int(arrayDif[0])!), TotalMin: Int16(Int(arrayDif[1])!)) {
            let sucesso = UIAlertController(title: "Sucesso!", message: "Horários padrões alterados com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
            sucesso.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
            self.presentViewController(sucesso, animated: true, completion: nil )
        }
    }
}
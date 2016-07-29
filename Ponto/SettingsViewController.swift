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
        btnHora1.setTitle(strHora1, for: UIControlState())
        btnHora2.setTitle(strHora2, for: UIControlState())
        btnHora3.setTitle(strHora3, for: UIControlState())
        btnHora4.setTitle(strHora4, for: UIControlState())
    }
    
    func populateTxt() {
        if DataStore.sharedInstance.getAllRecords().count > 0 {
            DataStore.sharedInstance.removeAllRecords()
        }
        let formatter = DateFormatter()
        var splitText1: NSArray             = [] //
        var splitText2: NSArray             = [] //
        var splitText3: NSArray             = [] //
        var splitText4: NSArray             = [] //
        var splitText5: NSArray             = [] //
        var splitText6: NSArray             = [] //
        
        let path = Bundle.main.pathForResource("ImportData", ofType: "txt")
        let txt: String?
        do {
            txt = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch _ {
            txt = nil
        }
        
        splitText1 = txt!.components(separatedBy: "*")
        for valor in 0...(splitText1.count - 1) {
            if (splitText1[valor] as! String) != "" {
                //Quebra em |, divisões de clubes
                splitText2 = splitText1[valor].components(separatedBy: "\n")
                //Ano/Mês
                splitText3 = splitText2.object(at: 0).components(separatedBy: "+")
                let anoTxt = splitText3[0] as! String
                let mesTxt = splitText3[1] as! String
                //Varre o resto
                for valor1 in 1...(splitText2.count - 1) {
                    //splitText3 = array de linhas de Dias
                    splitText4 = splitText2.object(at: valor1).components(separatedBy: "#")
                    //splitText4 = array da linhas por Horarios
                    let diaTxt = splitText4.object(at: 0) as! String
                    if splitText4.count > 1 {
                        splitText5 = splitText4.object(at: 1).components(separatedBy: "|")
                        var hor1Txt = splitText5.object(at: 0) as! String
                        var hor2Txt = splitText5.object(at: 1) as! String
                        var hor3Txt = splitText5.object(at: 2) as! String
                        var hor4Txt = splitText5.object(at: 3) as! String
                        let comment = splitText5.object(at: 4) as! String
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
                        let dateTxt = formatter.date(from: diaTxt + "/" + mesTxt + "/" + anoTxt)
                        formatter.dateFormat = "HH:mm"
                        let hora1 = formatter.date(from: hor1Txt)
                        let hora2 = formatter.date(from: hor2Txt)
                        let hora3 = formatter.date(from: hor3Txt)
                        let hora4 = formatter.date(from: hor4Txt)
                        let totalTxt = EditSingleton.sharedInstance.calculateDifference(hora1, hora2: hora2, hora3: hora3, hora4: hora4)
                        splitText6 = totalTxt.components(separatedBy: ":")
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
        let formatter = DateFormatter()
        
        picker.pickerMode = UIDatePickerMode.time
        formatter.dateFormat = "HH:mm"
        
        picker.showPickerInView(view, animated: true)
        picker.toolbarBackgroundColor = UIColor.gray()
        picker.pickerBackgroundColor = UIColor.lightGray()
        let data = formatter.date(from: pickerAtual)
        picker.pickerDate = data!
        picker.delegate = self
        activePicker = picker
    }
    
    func datePicker(_ picker: SMDatePicker, didPickDate date: Date) {
        let formatter = DateFormatter()
        var hora1: Date?
        var hora2: Date?
        var hora3: Date?
        var hora4: Date?
        formatter.dateFormat = "HH:mm"
        hora1 = formatter.date(from: btnHora1.titleLabel!.text!)
        hora2 = formatter.date(from: btnHora2.titleLabel!.text!)
        hora3 = formatter.date(from: btnHora3.titleLabel!.text!)
        hora4 = formatter.date(from: btnHora4.titleLabel!.text!)
        let dataFormatada = formatter.string(from: date)
        let erroDeHorario = UIAlertController(title: "Erro", message: "Horário inválido, Verifiqe novamente.", preferredStyle: UIAlertControllerStyle.alert)
        erroDeHorario.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
        switch (btnSelected){
        case 1:
            if (date.compare(hora2!) == ComparisonResult.orderedDescending || date.compare(hora3!) == ComparisonResult.orderedDescending || date.compare(hora4!) == ComparisonResult.orderedDescending) {
                //data 1 > data 2
                self.present(erroDeHorario, animated: true, completion: nil)
            } else {
                //data 1 < data 2
                btnHora1.setTitle(dataFormatada, for: UIControlState())
                hora1 = formatter.date(from: dataFormatada)
            }
            break
        case 2:
            if (date.compare(hora1!) == ComparisonResult.orderedAscending || date.compare(hora3!) == ComparisonResult.orderedDescending || date.compare(hora4!) == ComparisonResult.orderedDescending) {
                self.present(erroDeHorario, animated: true, completion: nil)
            } else {
                btnHora2.setTitle(dataFormatada, for: UIControlState())
                hora2 = formatter.date(from: dataFormatada)
            }
            break
        case 3:
            if (date.compare(hora1!) == ComparisonResult.orderedAscending || date.compare(hora2!) == ComparisonResult.orderedAscending || date.compare(hora4!) == ComparisonResult.orderedDescending) {
                self.present(erroDeHorario, animated: true, completion: nil)
            } else {
                btnHora3.setTitle(dataFormatada, for: UIControlState())
                hora3 = formatter.date(from: dataFormatada)
            }
            break
        case 4:
            if (date.compare(hora1!) == ComparisonResult.orderedAscending || date.compare(hora2!) == ComparisonResult.orderedAscending || date.compare(hora3!) == ComparisonResult.orderedAscending) {
                self.present(erroDeHorario, animated: true, completion: nil)
            } else {
                btnHora4.setTitle(dataFormatada, for: UIControlState())
                hora4 = formatter.date(from: dataFormatada)
            }
            break
        default:
            btnHora1.setTitle(dataFormatada, for: UIControlState())
            break
        }
    }
    
    func datePickerDidCancel(_ picker: SMDatePicker) {
        switch (btnSelected){
        case 1:
            btnHora1.setTitle(pickerAtual, for: UIControlState())
            break
        case 2:
            btnHora2.setTitle(pickerAtual, for: UIControlState())
            break
        case 3:
            btnHora3.setTitle(pickerAtual, for: UIControlState())
            break
        case 4:
            btnHora4.setTitle(pickerAtual, for: UIControlState())
            break
        default:
            btnHora1.setTitle(pickerAtual, for: UIControlState())
            break
        }
    }
    
    // MARK: - Btn
    
    @IBAction func btnHora1(_ sender: AnyObject) {
        btnSelected = 1
        configPicker()
    }
    
    @IBAction func btnHora2(_ sender: AnyObject) {
        btnSelected = 2
        configPicker()
    }
    
    @IBAction func btnHora3(_ sender: AnyObject) {
        btnSelected = 3
        configPicker()
    }
    
    @IBAction func btnHora4(_ sender: AnyObject) {
        btnSelected = 4
        configPicker()
    }
    
    @IBAction func btnImport(_ sender: UIButton) {
        populateTxt()
        let sucesso = UIAlertController(title: "Sucesso!", message: "Registro importado com sucesso", preferredStyle: UIAlertControllerStyle.alert)
        sucesso.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
        self.present(sucesso, animated: true, completion: nil )
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        let deletarTudo = UIAlertController(title: "Atenção!", message: "Deseja apagar todos os dados?", preferredStyle: UIAlertControllerStyle.alert)
        deletarTudo.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { (action: UIAlertAction) in
            DataStore.sharedInstance.removeAllRecords()
            let sucesso = UIAlertController(title: "Sucesso!", message: "Registros apagados com sucesso", preferredStyle: UIAlertControllerStyle.alert)
            sucesso.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
            self.present(sucesso, animated: true, completion: nil )
        }))
        deletarTudo.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { (action: UIAlertAction) in }))
        self.present(deletarTudo, animated: true, completion: nil )
    }
    
    @IBAction func btnDone(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let strHora1 = btnHora1.titleLabel!.text
        let strHora2 = btnHora2.titleLabel!.text
        let strHora3 = btnHora3.titleLabel!.text
        let strHora4 = btnHora4.titleLabel!.text
        let hora1 = formatter.date(from: strHora1!)
        let hora2 = formatter.date(from: strHora2!)
        let hora3 = formatter.date(from: strHora3!)
        let hora4 = formatter.date(from: strHora4!)
        let dif = EditSingleton.sharedInstance.calculateDifference(hora1, hora2: hora2, hora3: hora3, hora4: hora4)
        let arrayDif = dif.components(separatedBy: ":")
        
        if DataStore.sharedInstance.updateDefaulTime(Time1: strHora1!, Time2: strHora2!, Time3: strHora3!, Time4: strHora4!, TotalHor: Int16(Int(arrayDif[0])!), TotalMin: Int16(Int(arrayDif[1])!)) {
            let sucesso = UIAlertController(title: "Sucesso!", message: "Horários padrões alterados com sucesso", preferredStyle: UIAlertControllerStyle.alert)
            sucesso.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
            self.present(sucesso, animated: true, completion: nil )
        }
    }
}

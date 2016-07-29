//
//  NewRegisterViewController.swift
//  
//
//  Created by Fernando Cani on 8/24/15.
//
//

import UIKit

class NewRegisterViewController: UIViewController, UITextViewDelegate, SMDatePickerDelegate {

    @IBOutlet var btnDate:                  UIButton!
    @IBOutlet var btnHoraEntrada:           UIButton!
    @IBOutlet var btnHoraSaidaParaAlmoco:   UIButton!
    @IBOutlet var btnHoraEntradaDoAlmoco:   UIButton!
    @IBOutlet var btnHoraSaida:             UIButton!
    @IBOutlet var btnDone:                  UIBarButtonItem!
    @IBOutlet var lblTotal:                 UILabel!
    @IBOutlet var txtComments:              UITextView!
    
    var pickerAtual = ""
    var picker: SMDatePicker = SMDatePicker()
    var activePicker: SMDatePicker?
    var btnSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBtnText()
    }
    
    func setBtnText() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.local
        formatter.dateFormat = "dd/MM/yyyy"
        let dataFormatada = formatter.string(from: currentDate)
        btnDate.setTitle(dataFormatada, for: UIControlState())
        formatter.dateFormat = "HH:mm"
        let defaultTime = DataStore.sharedInstance.getAllDefaultTime()
        let strHora1 = (defaultTime.firstObject as! DefaultTime).time1
        let strHora2 = (defaultTime.firstObject as! DefaultTime).time2
        let strHora3 = (defaultTime.firstObject as! DefaultTime).time3
        let strHora4 = (defaultTime.firstObject as! DefaultTime).time4
        btnHoraEntrada.setTitle(        strHora1, for: UIControlState())
        btnHoraSaidaParaAlmoco.setTitle(strHora2, for: UIControlState())
        btnHoraEntradaDoAlmoco.setTitle(strHora3, for: UIControlState())
        btnHoraSaida.setTitle(          strHora4, for: UIControlState())
        lblTotal.text = EditSingleton.sharedInstance.calculateDifference(formatter.date(from: strHora1), hora2: formatter.date(from: strHora2), hora3: formatter.date(from: strHora3), hora4: formatter.date(from: strHora4))
        txtComments.text = "Comentários:"
        txtComments.textColor = UIColor.lightGray()
        txtComments.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtComments.text = ""
        txtComments.textColor = UIColor.black()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if txtComments.text.characters.count == 0 {
            txtComments.textColor = UIColor.lightGray()
            txtComments.text = "Comentários:"
            txtComments.resignFirstResponder()
        }
    }
    
    // MARK: - DatePicker
    
    @IBAction func btnDate(_ sender: AnyObject) {
        btnSelected = 0
        configPicker()
    }
    
    @IBAction func btnHoraEntrada(_ sender: AnyObject) {
        btnSelected = 1
        configPicker()
    }
    
    @IBAction func btnHoraSaidaParaAlmoco(_ sender: AnyObject) {
        btnSelected = 2
        configPicker()
    }
    
    @IBAction func btnHoraEntradaDoAlmoco(_ sender: AnyObject) {
        btnSelected = 3
        configPicker()
    }
    
    @IBAction func btnHoraSaida(_ sender: AnyObject) {
        btnSelected = 4
        configPicker()
    }
    
    func configPicker() {
        activePicker?.hidePicker(true)
        switch (btnSelected){
        case 0:
            pickerAtual = btnDate.titleLabel!.text!
            break
        case 1:
            pickerAtual = btnHoraEntrada.titleLabel!.text!
            break
        case 2:
            pickerAtual = btnHoraSaidaParaAlmoco.titleLabel!.text!
            break
        case 3:
            pickerAtual = btnHoraEntradaDoAlmoco.titleLabel!.text!
            break
        case 4:
            pickerAtual = btnHoraSaida.titleLabel!.text!
            break
        default:
            pickerAtual = btnDate.titleLabel!.text!
            break
        }
        if pickerAtual == "--:--" {
            pickerAtual = "00:00"
        }
        let formatter = DateFormatter()        
        if btnSelected == 0 {
            picker.pickerMode = UIDatePickerMode.date
            formatter.dateFormat = "dd/MM/yyyy"
        } else {
            picker.pickerMode = UIDatePickerMode.time
            formatter.dateFormat = "HH:mm"
        }
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
        if btnSelected == 0 {
            formatter.dateFormat = "dd/MM/yyyy"
        } else {
            formatter.dateFormat = "HH:mm"
            hora1 = formatter.date(from: btnHoraEntrada.titleLabel!.text!)
            hora2 = formatter.date(from: btnHoraSaidaParaAlmoco.titleLabel!.text!)
            hora3 = formatter.date(from: btnHoraEntradaDoAlmoco.titleLabel!.text!)
            hora4 = formatter.date(from: btnHoraSaida.titleLabel!.text!)
        }
        var dataFormatada = formatter.string(from: date)
        if dataFormatada == "00:00" {
            dataFormatada = "--:--"
        }
        let erroDeHorario = UIAlertController(title: "Erro", message: "Horário inválido, Verifiqe novamente.", preferredStyle: UIAlertControllerStyle.alert)
        erroDeHorario.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
        switch (btnSelected){
        case 0:
            btnDate.setTitle(dataFormatada, for: UIControlState())
            break
        case 1:
//            if (date.compare(hora2!) == NSComparisonResult.OrderedDescending || date.compare(hora3!) == NSComparisonResult.OrderedDescending || date.compare(hora4!) == NSComparisonResult.OrderedDescending)
                btnHoraEntrada.setTitle(dataFormatada, for: UIControlState())
                hora1 = formatter.date(from: dataFormatada)
            break
        case 2:
                btnHoraSaidaParaAlmoco.setTitle(dataFormatada, for: UIControlState())
                hora2 = formatter.date(from: dataFormatada)

            break
        case 3:
                btnHoraEntradaDoAlmoco.setTitle(dataFormatada, for: UIControlState())
                hora3 = formatter.date(from: dataFormatada)
            break
        case 4:
                btnHoraSaida.setTitle(dataFormatada, for: UIControlState())
                hora4 = formatter.date(from: dataFormatada)
            break
        default:
            btnDate.setTitle(dataFormatada, for: UIControlState())
            break
        }
        if btnSelected != 0 {
            lblTotal.text = EditSingleton.sharedInstance.calculateDifference(hora1, hora2: hora2, hora3: hora3, hora4: hora4)
        }
    }
    
    func datePickerDidCancel(_ picker: SMDatePicker) {
        switch (btnSelected){
        case 0:
            btnDate.setTitle(pickerAtual, for: UIControlState())
            break
        case 1:
            btnHoraEntrada.setTitle(pickerAtual, for: UIControlState())
            break
        case 2:
            btnHoraSaidaParaAlmoco.setTitle(pickerAtual, for: UIControlState())
            break
        case 3:
            btnHoraEntradaDoAlmoco.setTitle(pickerAtual, for: UIControlState())
            break
        case 4:
            btnHoraSaida.setTitle(pickerAtual, for: UIControlState())
            break
        default:
            btnDate.setTitle(pickerAtual, for: UIControlState())
            break
        }
    }
        
    // MARK: - Done
    
    @IBAction func btnDone(_ sender: AnyObject) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: btnDate.titleLabel!.text!)
        formatter.dateFormat = "HH:mm"
        let time1 = btnHoraEntrada.titleLabel!.text!
        let time2 = btnHoraSaidaParaAlmoco.titleLabel!.text!
        let time3 = btnHoraEntradaDoAlmoco.titleLabel!.text!
        let time4 = btnHoraSaida.titleLabel!.text!
        var comment = ""
        if txtComments.text != "Comentários:" {
            comment = txtComments.text
        }
        let total = formatter.date(from: lblTotal.text!)
        formatter.dateFormat = "HH"
        let totalHor = Int(formatter.string(from: total!))!
        formatter.dateFormat = "mm"
        let totalMin = Int(formatter.string(from: total!))!
        
        if DataStore.sharedInstance.saveData(Date: date!, Time1: time1, Time2: time2, Time3: time3, Time4: time4, Comment: comment, TotalHor: Int16(totalHor), TotalMin: Int16(totalMin)) {
            let diaSalvo = UIAlertController(title: "Sucesso!", message: "Horários salvos com sucesso.", preferredStyle: UIAlertControllerStyle.alert)
            diaSalvo.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
            self.present(diaSalvo, animated: true, completion: {( self.setBtnText() )})
        } else {
            let diaNaoSalvo = UIAlertController(title: "Erro!", message: "Já existe um registro com essa data.", preferredStyle: UIAlertControllerStyle.alert)
            diaNaoSalvo.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
            self.present(diaNaoSalvo, animated: true, completion: nil)
        }
    }
}

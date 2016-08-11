//
//  EditViewController.swift
//  
//
//  Created by Fernando Cani on 8/28/15.
//
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate, SMDatePickerDelegate {

    @IBOutlet var btnDate:      UIButton!
    @IBOutlet var btnHora1:     UIButton!
    @IBOutlet var btnHora2:     UIButton!
    @IBOutlet var btnHora3:     UIButton!
    @IBOutlet var btnHora4:     UIButton!
    @IBOutlet var btnDone:      UIBarButtonItem!
    @IBOutlet var lblTotal:     UILabel!
    @IBOutlet var txtComment:   UITextView!
    
    var pickerAtual = ""
    var picker: SMDatePicker = SMDatePicker()
    var activePicker: SMDatePicker?
    var btnSelected = 0
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBtnText()
    }
    
    func setBtnText() {
        let formatter = DateFormatter()
        let date = DataStore.sharedInstance.getRecordByDate(EditSingleton.sharedInstance.dateSelected)
        formatter.dateFormat = "dd/MM/yyyy"
        currentDate = date!.date
        let dataFormatada = formatter.string(from: currentDate)
        btnDate.setTitle(dataFormatada, for: UIControlState())
        formatter.dateFormat = "HH:mm"
        let strHora1 = date!.time1
        let strHora2 = date!.time2
        let strHora3 = date!.time3
        let strHora4 = date!.time4
        btnHora1.setTitle(strHora1, for: UIControlState())
        btnHora2.setTitle(strHora2, for: UIControlState())
        btnHora3.setTitle(strHora3, for: UIControlState())
        btnHora4.setTitle(strHora4, for: UIControlState())
        
        var total = EditSingleton.sharedInstance.calculateDifference(formatter.date(from: strHora1), hora2: formatter.date(from: strHora2), hora3: formatter.date(from: strHora3), hora4: formatter.date(from: strHora4))
        if total == "00:00" {
            total = "--:--"
        }
        lblTotal.text = total
        if date!.comment == "" {
            txtComment.text = "Comentários:"
            txtComment.textColor = UIColor.lightGray
        } else {
            txtComment.text = date!.comment
            txtComment.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtComment.text = ""
        txtComment.textColor = UIColor.black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if txtComment.text.characters.count == 0 {
            txtComment.textColor = UIColor.lightGray
            txtComment.text = "Comentários:"
            txtComment.resignFirstResponder()
        }
    }
    
    // MARK: - DatePicker
    
    @IBAction func btnDate(_ sender: AnyObject) {
        btnSelected = 0
        configPicker()
    }
    
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
    
    func configPicker() {
        activePicker?.hidePicker(true)
        switch (btnSelected){
        case 0:
            pickerAtual = btnDate.titleLabel!.text!
            break
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
        picker.toolbarBackgroundColor = UIColor.gray
        picker.pickerBackgroundColor = UIColor.lightGray
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
            hora1 = formatter.date(from: btnHora1.titleLabel!.text!)
            hora2 = formatter.date(from: btnHora2.titleLabel!.text!)
            hora3 = formatter.date(from: btnHora3.titleLabel!.text!)
            hora4 = formatter.date(from: btnHora4.titleLabel!.text!)
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
                btnHora1.setTitle(dataFormatada, for: UIControlState())
                hora1 = formatter.date(from: dataFormatada)
            break
        case 2:
                btnHora2.setTitle(dataFormatada, for: UIControlState())
                hora2 = formatter.date(from: dataFormatada)
            break
        case 3:
                btnHora3.setTitle(dataFormatada, for: UIControlState())
                hora3 = formatter.date(from: dataFormatada)
            break
        case 4:
                btnHora4.setTitle(dataFormatada, for: UIControlState())
                hora4 = formatter.date(from: dataFormatada)
            break
        default:
            btnDate.setTitle(dataFormatada, for: UIControlState())
            break
        }
        if btnSelected != 0 {
            var total = EditSingleton.sharedInstance.calculateDifference(hora1, hora2: hora2, hora3: hora3, hora4: hora4)
            if total == "00:00" {
               total = "--:--"
            }
            lblTotal.text = total
        }
    }
    
    func datePickerDidCancel(_ picker: SMDatePicker) {
        switch (btnSelected){
        case 0:
            btnDate.setTitle(pickerAtual, for: UIControlState())
            break
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
            btnDate.setTitle(pickerAtual, for: UIControlState())
            break
        }
    }
    
    // MARK: - Done
    
    @IBAction func btnDone(_ sender: AnyObject) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let saveDate = formatter.date(from: btnDate.titleLabel!.text!)
        formatter.dateFormat = "HH:mm"
        let time1 = btnHora1.titleLabel!.text!
        let time2 = btnHora2.titleLabel!.text!
        let time3 = btnHora3.titleLabel!.text!
        let time4 = btnHora4.titleLabel!.text!
        var comment = ""
        if txtComment.text != "Comentários:" {
            comment = txtComment.text
        }

        let total = formatter.date(from: lblTotal.text!)
        formatter.dateFormat = "HH"
        let totalHor = Int(formatter.string(from: total!))!
        formatter.dateFormat = "mm"
        let totalMin = Int(formatter.string(from: total!))!
        
        if DataStore.sharedInstance.updateRecordByDate(CurrentDate: currentDate, SaveDate: saveDate!, Time1: time1, Time2: time2, Time3: time3, Time4: time4, Comment: comment, TotalHor: Int16(totalHor), TotalMin: Int16(totalMin)) {
            let diaSalvo = UIAlertController(title: "Sucesso!", message: "Horários alterados com sucesso.", preferredStyle: UIAlertControllerStyle.alert)
            diaSalvo.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
            self.present(diaSalvo, animated: true, completion: nil )
        } else {
            let diaNaoSalvo = UIAlertController(title: "Erro!", message: "Ocorreu alguma zica.", preferredStyle: UIAlertControllerStyle.alert)
            diaNaoSalvo.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in }))
            self.present(diaNaoSalvo, animated: true, completion: nil)
        }
    }
}

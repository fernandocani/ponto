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
    var currentDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBtnText()
    }
    
    func setBtnText() {
        let formatter = NSDateFormatter()
        let date = DataStore.sharedInstance.getRecordByDate(EditSingleton.sharedInstance.dateSelected)
        formatter.dateFormat = "dd/MM/yyyy"
        currentDate = date.date
        let dataFormatada = formatter.stringFromDate(currentDate)
        btnDate.setTitle(dataFormatada, forState: .Normal)
        formatter.dateFormat = "HH:mm"
        let strHora1 = date.time1
        let strHora2 = date.time2
        let strHora3 = date.time3
        let strHora4 = date.time4
        btnHora1.setTitle(strHora1, forState: .Normal)
        btnHora2.setTitle(strHora2, forState: .Normal)
        btnHora3.setTitle(strHora3, forState: .Normal)
        btnHora4.setTitle(strHora4, forState: .Normal)
        
        var total = EditSingleton.sharedInstance.calculateDifference(formatter.dateFromString(strHora1), hora2: formatter.dateFromString(strHora2), hora3: formatter.dateFromString(strHora3), hora4: formatter.dateFromString(strHora4))
        if total == "00:00" {
            total = "--:--"
        }
        lblTotal.text = total
        if date.comment == "" {
            txtComment.text = "Comentários:"
            txtComment.textColor = UIColor.lightGrayColor()
        } else {
            txtComment.text = date.comment
            txtComment.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        txtComment.text = ""
        txtComment.textColor = UIColor.blackColor()
    }
    
    func textViewDidChange(textView: UITextView) {
        if txtComment.text.characters.count == 0 {
            txtComment.textColor = UIColor.lightGrayColor()
            txtComment.text = "Comentários:"
            txtComment.resignFirstResponder()
        }
    }
    
    // MARK: - DatePicker
    
    @IBAction func btnDate(sender: AnyObject) {
        btnSelected = 0
        configPicker()
    }
    
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
        let formatter = NSDateFormatter()
        if btnSelected == 0 {
            picker.pickerMode = UIDatePickerMode.Date
            formatter.dateFormat = "dd/MM/yyyy"
        } else {
            picker.pickerMode = UIDatePickerMode.Time
            formatter.dateFormat = "HH:mm"
        }
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
        if btnSelected == 0 {
            formatter.dateFormat = "dd/MM/yyyy"
        } else {
            formatter.dateFormat = "HH:mm"
            hora1 = formatter.dateFromString(btnHora1.titleLabel!.text!)
            hora2 = formatter.dateFromString(btnHora2.titleLabel!.text!)
            hora3 = formatter.dateFromString(btnHora3.titleLabel!.text!)
            hora4 = formatter.dateFromString(btnHora4.titleLabel!.text!)
        }
        var dataFormatada = formatter.stringFromDate(date)
        if dataFormatada == "00:00" {
            dataFormatada = "--:--"
        }
        let erroDeHorario = UIAlertController(title: "Erro", message: "Horário inválido, Verifiqe novamente.", preferredStyle: UIAlertControllerStyle.Alert)
        erroDeHorario.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
        switch (btnSelected){
        case 0:
            btnDate.setTitle(dataFormatada, forState: UIControlState.Normal)
            break
        case 1:
                btnHora1.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora1 = formatter.dateFromString(dataFormatada)
            break
        case 2:
                btnHora2.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora2 = formatter.dateFromString(dataFormatada)
            break
        case 3:
                btnHora3.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora3 = formatter.dateFromString(dataFormatada)
            break
        case 4:
                btnHora4.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora4 = formatter.dateFromString(dataFormatada)
            break
        default:
            btnDate.setTitle(dataFormatada, forState: UIControlState.Normal)
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
    
    func datePickerDidCancel(picker: SMDatePicker) {
        switch (btnSelected){
        case 0:
            btnDate.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
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
            btnDate.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        }
    }
    
    // MARK: - Done
    
    @IBAction func btnDone(sender: AnyObject) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let saveDate = formatter.dateFromString(btnDate.titleLabel!.text!)
        formatter.dateFormat = "HH:mm"
        let time1 = btnHora1.titleLabel!.text!
        let time2 = btnHora2.titleLabel!.text!
        let time3 = btnHora3.titleLabel!.text!
        let time4 = btnHora4.titleLabel!.text!
        var comment = ""
        if txtComment.text != "Comentários:" {
            comment = txtComment.text
        }

        let total = formatter.dateFromString(lblTotal.text!)
        formatter.dateFormat = "HH"
        let totalHor = Int(formatter.stringFromDate(total!))!
        formatter.dateFormat = "mm"
        let totalMin = Int(formatter.stringFromDate(total!))!
        
        if DataStore.sharedInstance.updateRecordByDate(CurrentDate: currentDate, SaveDate: saveDate!, Time1: time1, Time2: time2, Time3: time3, Time4: time4, Comment: comment, TotalHor: Int16(totalHor), TotalMin: Int16(totalMin)) {
            let diaSalvo = UIAlertController(title: "Sucesso!", message: "Horários alterados com sucesso.", preferredStyle: UIAlertControllerStyle.Alert)
            diaSalvo.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
            self.presentViewController(diaSalvo, animated: true, completion: nil )
        } else {
            let diaNaoSalvo = UIAlertController(title: "Erro!", message: "Ocorreu alguma zica.", preferredStyle: UIAlertControllerStyle.Alert)
            diaNaoSalvo.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
            self.presentViewController(diaNaoSalvo, animated: true, completion: nil)
        }
    }
}
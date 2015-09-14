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
    
    override func viewWillAppear(animated: Bool) {
        setBtnText()
    }
    
    func setBtnText() {
        let currentDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = "dd/MM/yyyy"
        let dataFormatada = formatter.stringFromDate(currentDate)
        btnDate.setTitle(dataFormatada, forState: .Normal)
        formatter.dateFormat = "HH:mm"
        let defaultTime = DataStore.sharedInstance.getAllDefaultTime()
        let strHora1 = (defaultTime.firstObject as! DefaultTime).time1
        let strHora2 = (defaultTime.firstObject as! DefaultTime).time2
        let strHora3 = (defaultTime.firstObject as! DefaultTime).time3
        let strHora4 = (defaultTime.firstObject as! DefaultTime).time4
        btnHoraEntrada.setTitle(        strHora1, forState: .Normal)
        btnHoraSaidaParaAlmoco.setTitle(strHora2, forState: .Normal)
        btnHoraEntradaDoAlmoco.setTitle(strHora3, forState: .Normal)
        btnHoraSaida.setTitle(          strHora4, forState: .Normal)
        lblTotal.text = EditSingleton.sharedInstance.calculateDifference(formatter.dateFromString(strHora1), hora2: formatter.dateFromString(strHora2), hora3: formatter.dateFromString(strHora3), hora4: formatter.dateFromString(strHora4))
        txtComments.text = "Comentários:"
        txtComments.textColor = UIColor.lightGrayColor()
        txtComments.delegate = self
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        txtComments.text = ""
        txtComments.textColor = UIColor.blackColor()
    }
    
    func textViewDidChange(textView: UITextView) {
        if txtComments.text.characters.count == 0 {
            txtComments.textColor = UIColor.lightGrayColor()
            txtComments.text = "Comentários:"
            txtComments.resignFirstResponder()
        }
    }
    
    // MARK: - DatePicker
    
    @IBAction func btnDate(sender: AnyObject) {
        btnSelected = 0
        configPicker()
    }
    
    @IBAction func btnHoraEntrada(sender: AnyObject) {
        btnSelected = 1
        configPicker()
    }
    
    @IBAction func btnHoraSaidaParaAlmoco(sender: AnyObject) {
        btnSelected = 2
        configPicker()
    }
    
    @IBAction func btnHoraEntradaDoAlmoco(sender: AnyObject) {
        btnSelected = 3
        configPicker()
    }
    
    @IBAction func btnHoraSaida(sender: AnyObject) {
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
            hora1 = formatter.dateFromString(btnHoraEntrada.titleLabel!.text!)
            hora2 = formatter.dateFromString(btnHoraSaidaParaAlmoco.titleLabel!.text!)
            hora3 = formatter.dateFromString(btnHoraEntradaDoAlmoco.titleLabel!.text!)
            hora4 = formatter.dateFromString(btnHoraSaida.titleLabel!.text!)
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
//            if (date.compare(hora2!) == NSComparisonResult.OrderedDescending || date.compare(hora3!) == NSComparisonResult.OrderedDescending || date.compare(hora4!) == NSComparisonResult.OrderedDescending)
                btnHoraEntrada.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora1 = formatter.dateFromString(dataFormatada)
            break
        case 2:
                btnHoraSaidaParaAlmoco.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora2 = formatter.dateFromString(dataFormatada)

            break
        case 3:
                btnHoraEntradaDoAlmoco.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora3 = formatter.dateFromString(dataFormatada)
            break
        case 4:
                btnHoraSaida.setTitle(dataFormatada, forState: UIControlState.Normal)
                hora4 = formatter.dateFromString(dataFormatada)
            break
        default:
            btnDate.setTitle(dataFormatada, forState: UIControlState.Normal)
            break
        }
        if btnSelected != 0 {
            lblTotal.text = EditSingleton.sharedInstance.calculateDifference(hora1, hora2: hora2, hora3: hora3, hora4: hora4)
        }
    }
    
    func datePickerDidCancel(picker: SMDatePicker) {
        switch (btnSelected){
        case 0:
            btnDate.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        case 1:
            btnHoraEntrada.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        case 2:
            btnHoraSaidaParaAlmoco.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        case 3:
            btnHoraEntradaDoAlmoco.setTitle(pickerAtual, forState: UIControlState.Normal)
            break
        case 4:
            btnHoraSaida.setTitle(pickerAtual, forState: UIControlState.Normal)
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
        let date = formatter.dateFromString(btnDate.titleLabel!.text!)
        formatter.dateFormat = "HH:mm"
        let time1 = btnHoraEntrada.titleLabel!.text!
        let time2 = btnHoraSaidaParaAlmoco.titleLabel!.text!
        let time3 = btnHoraEntradaDoAlmoco.titleLabel!.text!
        let time4 = btnHoraSaida.titleLabel!.text!
        var comment = ""
        if txtComments.text != "Comentários:" {
            comment = txtComments.text
        }
        let total = formatter.dateFromString(lblTotal.text!)
        formatter.dateFormat = "HH"
        let totalHor = Int(formatter.stringFromDate(total!))!
        formatter.dateFormat = "mm"
        let totalMin = Int(formatter.stringFromDate(total!))!
        
        if DataStore.sharedInstance.saveData(Date: date!, Time1: time1, Time2: time2, Time3: time3, Time4: time4, Comment: comment, TotalHor: Int16(totalHor), TotalMin: Int16(totalMin)) {
            let diaSalvo = UIAlertController(title: "Sucesso!", message: "Horários salvos com sucesso.", preferredStyle: UIAlertControllerStyle.Alert)
            diaSalvo.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
            self.presentViewController(diaSalvo, animated: true, completion: {( self.setBtnText() )})
        } else {
            let diaNaoSalvo = UIAlertController(title: "Erro!", message: "Já existe um registro com essa data.", preferredStyle: UIAlertControllerStyle.Alert)
            diaNaoSalvo.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in }))
            self.presentViewController(diaNaoSalvo, animated: true, completion: nil)
        }
    }
}
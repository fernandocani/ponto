//
//  RendimentoViewController.swift
//  Ponto
//
//  Created by Fernando Cani on 8/28/16.
//  Copyright © 2016 Fernando Cani. All rights reserved.
//

import UIKit

class RendimentoViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnOk:               UIBarButtonItem!
    @IBOutlet weak var txtSaldoInicial:     UITextField!
    @IBOutlet weak var txtMeses:            UITextField!
    @IBOutlet weak var txtTaxaJurosMensal:  UITextField!
    @IBOutlet weak var txtAplicacaoMensal:  UITextField!
    @IBOutlet weak var lblResultado:        UILabel!
    @IBOutlet weak var tableView:           UITableView!
    
    let cellIdentifier = "rendimentoCell"
    let rendimentoMesArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSaldoInicial.delegate    = self
        txtMeses.delegate           = self
        txtTaxaJurosMensal.delegate = self
        txtAplicacaoMensal.delegate = self
        txtSaldoInicial.text    = "1000"
        txtMeses.text           = "2"
        txtTaxaJurosMensal.text = "1"
        txtAplicacaoMensal.text = "100"
    }
    
    func calcRendimento (meses: Double, saldoInicial: Double, txJurosMensal: Double, aplicacao: Double) -> Int {
        
        if rendimentoMesArray.count > 0 {
            rendimentoMesArray.removeAllObjects()
        }
        var rendimentoParcial = saldoInicial + (saldoInicial * txJurosMensal) + aplicacao
        var rendimento = rendimentoParcial
        rendimentoMesArray.add(rendimento)
        if (Int(meses) > 1) {
            for _ in 1...Int(meses - 1) {
                rendimento = rendimentoParcial + (rendimentoParcial * txJurosMensal) + aplicacao
                rendimentoParcial = rendimento
                rendimentoMesArray.add(Int(rendimento))
            }
        }
        print(Int(rendimento - saldoInicial))
        return Int(rendimento)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtSaldoInicial:
            txtMeses.becomeFirstResponder()
        case txtMeses:
            txtTaxaJurosMensal.becomeFirstResponder()
        case txtTaxaJurosMensal:
            txtAplicacaoMensal.becomeFirstResponder()
        case txtAplicacaoMensal:
            textField.resignFirstResponder()
            btnOk(btnOk)
        default:
            print("oe")
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rendimentoMesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RendimentoTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RendimentoTableViewCell
        cell.lblMes.text   = "\(indexPath.row + 1)"
        cell.lblValor.text = "R$ \(rendimentoMesArray.object(at: indexPath.row))"
        return cell
    }
    
    @IBAction func btnOk(_ sender: UIBarButtonItem) {
        var meses           = Double()
        var saldoInicial    = Double()
        var txJurosMensal   = Double()
        var aplicacao       = Double()
        if (txtMeses.text! == "") {
            meses           = 0
        } else {
            meses           = Double(txtMeses.text!)!
        }
        if (txtSaldoInicial.text! == "") {
            saldoInicial    = 0
        } else {
            saldoInicial    = Double(txtSaldoInicial.text!)!
        }
        if (txtTaxaJurosMensal.text! == "") {
            txJurosMensal   = 0
        } else {
            txJurosMensal   = Double(txtTaxaJurosMensal.text!)! / 100
        }
        if (txtAplicacaoMensal.text! == "") {
            aplicacao       = 0
        } else {
            aplicacao       = Double(txtAplicacaoMensal.text!)!
        }
        let resul = calcRendimento(meses:           meses,
                                   saldoInicial:    saldoInicial,
                                   txJurosMensal:   txJurosMensal,
                                   aplicacao:       aplicacao)
        lblResultado.text = "\(resul)"
        tableView.reloadData()
    }
}

class RendimentoTableViewCell: UITableViewCell {
    
    @IBOutlet var lblMes:  UILabel!
    @IBOutlet var lblValor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//
//  ViewController.swift
//  Bitenge
//
//  Created by Асхат Баймуканов on 18.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var converterManager = ConverterManager()
    var cryptoManager = CryptoManager()
    
    @IBOutlet weak var tengeLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var cryptoPicker: UIPickerView!
    
    var cryptoRate: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cryptoManager.delegate = self
        converterManager.delegate = self
        cryptoPicker.dataSource = self
        cryptoPicker.delegate = self
    }


}

//MARK: - UIPickerDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cryptoManager.cryptoArray.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cryptoManager.cryptoArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCrypto = cryptoManager.cryptoArray[row]
        cryptoManager.getCryptoPrice(for: selectedCrypto)
        converterManager.getConvertCurrency()
        
        
    }
}

//MARK: - CryptoManagerDelegate

extension ViewController: CryptoManagerDelegate {
    
    func didCalculateRate(cryptoManager: CryptoManager, rate: Double) {
        DispatchQueue.main.async {
            let rateToString = String(format: "%.5f", rate)
            self.dollarLabel.text = rateToString
            self.cryptoRate = rate
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - ConverterManagerDelegate

extension ViewController: ConverterManagerDelegate {
    
    func didCalculateCurrency(converterManager: ConverterManager, usdKZT: Double) {
        DispatchQueue.main.async {
            let tengePrice = usdKZT * self.cryptoRate
            let tengePriceToString = String(format: "%.5f", tengePrice)
            self.tengeLabel.text = tengePriceToString
            self.cryptoRate = 0
        }
    }
    
    func didFailWithCurrencyError(error: Error) {
        print(error)
    }
}

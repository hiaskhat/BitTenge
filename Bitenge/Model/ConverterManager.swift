//
//  ConverterManager.swift
//  Bitenge
//
//  Created by Асхат Баймуканов on 20.01.2022.
//

import Foundation

protocol ConverterManagerDelegate {
    func didCalculateCurrency(converterManager: ConverterManager, usdKZT: Double)
    func didFailWithCurrencyError(error: Error)
}

struct ConverterManager {
    
    var delegate: ConverterManagerDelegate?
    
    let baseURL = "https://free.currconv.com/api/v7/convert?q=USD_KZT&compact=ultra&apiKey="
    let apiKey = ""
    
    func getConvertCurrency() {
        let urlString = "\(baseURL)\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, responce, error in
                if error != nil {
                    self.delegate?.didFailWithCurrencyError(error: error!)
                    print("error is here")
                    return
                }
                if let safeData = data {
                    if let usdKZT = parseJSON(safeData) {
                        self.delegate?.didCalculateCurrency(converterManager: self, usdKZT: usdKZT)
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ConverterData.self, from: data)
            let convertedCurrency = decodedData.USD_KZT
            return convertedCurrency
        } catch {
            print("error when parsing")
            self.delegate?.didFailWithCurrencyError(error: error)

            return nil
        }
    }
}

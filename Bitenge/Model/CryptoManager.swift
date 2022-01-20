//
//  CryptoManager.swift
//  Bitenge
//
//  Created by Асхат Баймуканов on 19.01.2022.
//

import Foundation

protocol CryptoManagerDelegate {
    func didCalculateRate(cryptoManager: CryptoManager, rate: Double)
    func didFailWithError(error: Error)
}

struct CryptoManager {
    
    var delegate: CryptoManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "0F37F81A-2EDC-47B3-88BB-43F7EBE80DFF"
    
    let cryptoArray = ["BTC", "XRP", "DOGE", "ETH", "BNB"]
    
    func getCryptoPrice (for crypto: String) {
        let urlString = "\(baseURL)\(crypto)/USD?apikey=\(apiKey)"
        //print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let rate = self.parseJSON(safeData) {
                        self.delegate?.didCalculateRate(cryptoManager: self, rate: rate)
                        print(rate)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CryptoData.self, from: data)
            let lastPrice = decodedData.rate
            
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

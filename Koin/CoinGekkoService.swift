//
//  CoinGekkoService.swift
//  MinaCoin
//
//  Created by Can on 24.07.2024.
//

import Foundation

class CoinGeckoService {
    func fetchCoins(completion: @escaping ([Coin]?) -> Void) {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let coins = try decoder.decode([Coin].self, from: data)
                    completion(coins)
                } catch {
                    print("Error decoding data: \(error)")
                    completion(nil)
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchCoinDetail(id: String, interval: String, completion: @escaping (CoinDetail?) -> Void) {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)")!
        let historyUrl = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)/market_chart?vs_currency=usd&days=\(interval)")!

        let group = DispatchGroup()

        var coinDetail: CoinDetail?
        var priceHistory: [PricePoint]?

        group.enter()
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    coinDetail = try decoder.decode(CoinDetail.self, from: data)
                } catch {
                    print("Error decoding coin detail: \(error)")
                }
            } else {
                print("Error fetching coin detail: \(error?.localizedDescription ?? "Unknown error")")
            }
            group.leave()
        }.resume()

        group.enter()
        URLSession.shared.dataTask(with: historyUrl) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let historyResponse = try decoder.decode([String: [[Double]]].self, from: data)
                    priceHistory = historyResponse["prices"]?.map { PricePoint(time: $0[0], price: $0[1]) }
                } catch {
                    print("Error decoding price history: \(error)")
                }
            } else {
                print("Error fetching price history: \(error?.localizedDescription ?? "Unknown error")")
            }
            group.leave()
        }.resume()

        group.notify(queue: .main) {
            coinDetail?.priceHistory = priceHistory
            completion(coinDetail)
        }
    }
}

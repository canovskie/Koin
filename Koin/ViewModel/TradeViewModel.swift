//
//  DetailViewModel.swift
//  MinaCoin
//
//  Created by Can on 25.07.2024.
//
import SwiftUI

class TradeViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var coinDetail: CoinDetail?
    @Published var isDescriptionExpanded: Bool = false
    @Published var buyAmount: Double = 0
    @Published var sellAmount: Double = 0
    @Published var budget: Double
    @Published var buyPrice: Double = 0
    @Published var sellAmounts: [String: Double] = [:]
    @Published var ownedCoins: [OwnedCoin] = []
    @Published var selectedInterval: String = "7"

    
    @Published var formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()

    private var coinGeckoService = CoinGeckoService()
    private let ownedCoinsKey = "ownedCoins"
    private let budgetKey = "savedBudget"
    
    init() {
        self.budget = UserDefaults.standard.double(forKey: budgetKey)
        if self.budget == 0 {
            self.budget = 100000
        }
        self.ownedCoins = loadOwnedCoins()
    }
    
    func fetchCoins() {
            coinGeckoService.fetchCoins { [weak self] coins in
                DispatchQueue.main.async {
                    self?.coins = coins ?? []
                }
            }
        }
        
        func fetchCoinDetail(id: String) {
            coinGeckoService.fetchCoinDetail(id: id, interval: selectedInterval) { [weak self] coinDetail in
                DispatchQueue.main.async {
                    self?.coinDetail = coinDetail
                }
            }
        }
    func buyCoin() {
        guard let currentPrice = coinDetail?.market_data.current_price["usd"] else { return }
        let totalCost = buyAmount * (currentPrice ?? 0)
        
        if totalCost > budget {
            print("You are not rich enough")
        } else {
            budget -= totalCost
            buyPrice = currentPrice ?? 0
            
            if let index = ownedCoins.firstIndex(where: { $0.id == coinDetail?.id }) {
                ownedCoins[index].amount += buyAmount
                ownedCoins[index].price = currentPrice ?? 0
            } else {
                let newOwnedCoin = OwnedCoin(id: coinDetail?.id ?? "", name: coinDetail?.name ?? "", amount: buyAmount, price: currentPrice ?? 0)
                ownedCoins.append(newOwnedCoin)
            }
            saveBudget()
            saveOwnedCoins()
        }
    }
    
    func sellCoin(ownedCoin: OwnedCoin, amount: Double) {
        guard let currentPrice = coinDetail?.market_data.current_price["usd"] else { return }
        let totalRevenue = amount * (currentPrice ?? 0)
        
        if let index = ownedCoins.firstIndex(where: { $0.id == ownedCoin.id }) {
            if ownedCoins[index].amount < amount {
                print("You don't have enough coins to sell")
            } else {
                ownedCoins[index].amount -= amount
                budget += totalRevenue
                
                if ownedCoins[index].amount == 0 {
                    ownedCoins.remove(at: index)
                }

                saveBudget()
                saveOwnedCoins()
            }
        }
    }
    
    private func saveBudget() {
        UserDefaults.standard.set(budget, forKey: budgetKey)
    }
    
    private func saveOwnedCoins() {
        if let data = try? JSONEncoder().encode(ownedCoins) {
            UserDefaults.standard.set(data, forKey: ownedCoinsKey)
        }
    }
    
    private func loadOwnedCoins() -> [OwnedCoin] {
        if let data = UserDefaults.standard.data(forKey: ownedCoinsKey) {
            let decoder = JSONDecoder()
            return (try? decoder.decode([OwnedCoin].self, from: data)) ?? []
        }
        return []
    }
}

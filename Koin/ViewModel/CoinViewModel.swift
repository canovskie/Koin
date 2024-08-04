//
//  CoinViewModel.swift
//  MinaCoin
//
//  Created by Can on 24.07.2024.
//

import SwiftUI

class CoinViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    private var coinGeckoService = CoinGeckoService()
    
    func fetchCoins() {
        coinGeckoService.fetchCoins { [weak self] coins in
            DispatchQueue.main.async {
                self?.coins = coins ?? []
            }
        }
    }
}

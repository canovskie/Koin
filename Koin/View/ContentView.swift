//
//  ContentView.swift
//  MinaCoin
//
//  Created by Can on 26.07.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tradeViewModel = TradeViewModel()
    
    var body: some View {
        TabView {
            CoinView(viewModel: tradeViewModel)
                .tabItem {
                    Label("Coins", systemImage: "bitcoinsign.circle.fill")
                }
            
            PortfolioView(viewModel: tradeViewModel)
                .tabItem {
                    Label("Portfolio", systemImage: "chart.bar")
                }
        }.onAppear {
            tradeViewModel.fetchCoins()
            if let budget = UserDefaults.standard.value(forKey: "savedBudget") as? Double {
                tradeViewModel.budget = budget
            }
        }
    }
}

#Preview {
    ContentView()
}


#Preview {
    ContentView()
}


//
//  PortfolioView.swift
//  MinaCoin
//
//  Created by Can on 26.07.2024.
//

import SwiftUI

struct PortfolioView: View {
    @ObservedObject var viewModel: TradeViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Portfolio")) {
                    Text("Budget: \(viewModel.budget.formatted())$")
                }
                
                Section(header: Text("Owned Coins")) {
                    ForEach(viewModel.ownedCoins) { ownedCoin in
                        NavigationLink(destination: TradeView(viewModel: viewModel, coin: Coin(id: ownedCoin.id, symbol: "", name: ownedCoin.name, current_price: ownedCoin.price, market_cap: nil, market_cap_rank: nil))) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(ownedCoin.name)
                                        .font(.headline)
                                    Text("Amount: \(ownedCoin.amount.formatted())")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("Price: \(ownedCoin.price.formatted())$")
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Portfolio")
        }
    }
}

#Preview {
    PortfolioView(viewModel: TradeViewModel())
}

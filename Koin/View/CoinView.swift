//
//  ContentView.swift
//  MinaCoin
//
//  Created by Can on 24.07.2024.
//

import SwiftUI

struct CoinView: View {
    @ObservedObject var viewModel: TradeViewModel

    var body: some View {
        NavigationView {
            List(viewModel.coins) { coin in
                NavigationLink(destination: TradeView(viewModel: viewModel, coin: coin)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(coin.name)
                                .font(.headline)
                            Text(coin.symbol.uppercased())
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("$\(coin.current_price?.formatted() ?? "N/A")")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Coins")
        }
    }
}



#Preview {
    CoinView(viewModel: TradeViewModel())
}

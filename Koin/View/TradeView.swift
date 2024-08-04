//
//  SwiftUIView.swift
//  MinaCoin
//
//  Created by Can on 25.07.2024.
//

import SwiftUI

struct TradeView: View {
    @ObservedObject var viewModel: TradeViewModel
    let coin: Coin
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let coinDetail = viewModel.coinDetail {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(coinDetail.symbol)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: coinDetail.image.large ?? "")) { image in
                                image.resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Divider()
                        
                        Text("Current Price: \(coinDetail.market_data.current_price["usd"]??.formatted() ?? "?")$")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Picker("Interval", selection: $viewModel.selectedInterval) {
                            Text("Hourly").tag("1")
                            Text("Daily").tag("7")
                            Text("Weekly").tag("30")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .onChange(of: viewModel.selectedInterval) {
                            viewModel.fetchCoinDetail(id: coin.id)
                        }

                        
                        if let priceHistory = coinDetail.priceHistory {
                            ChartView(pricePoints: priceHistory)
                                .frame(height: 300)
                        } else {
                            ProgressView("Loading chart data...")
                        }
                        
                        
                        HStack {
                            TextField("Amount to buy", value: $viewModel.buyAmount, formatter: viewModel.formatter)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button("Buy") {
                                viewModel.buyCoin()
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        
                        if let ownedCoin = viewModel.ownedCoins.first(where: { $0.id == coinDetail.id }) {
                            HStack {
                                TextField("Amount to sell", value: $viewModel.sellAmounts[ownedCoin.id], formatter: viewModel.formatter)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                
                                Button("Sell") {
                                    if let amountToSell = viewModel.sellAmounts[ownedCoin.id] {
                                        viewModel.sellCoin(ownedCoin: ownedCoin, amount: amountToSell)
                                        viewModel.sellAmounts[ownedCoin.id] = nil
                                    }
                                }
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Button(action: {
                                withAnimation {
                                    viewModel.isDescriptionExpanded.toggle()
                                }
                            }) {
                                HStack {
                                    Text("Description")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: viewModel.isDescriptionExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.black)
                                }
                            }
                            
                            if viewModel.isDescriptionExpanded {
                                ScrollView {
                                    Text(coinDetail.description.en ?? "?")
                                        .font(.body)
                                        .padding()
                                        .transition(.opacity)
                                    
                                    Link(destination: URL(string: (coinDetail.links.homepage.first ?? "") ?? "")!) {
                                        Text("Homepage")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .padding()
        }
        .navigationTitle(coin.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchCoinDetail(id: coin.id)
        }
    }
}


struct TradeView_Previews: PreviewProvider {
    static var previews: some View {
        TradeView(viewModel: TradeViewModel(), coin: Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", current_price: 30000, market_cap: 600000000, market_cap_rank: 1))
    }
}


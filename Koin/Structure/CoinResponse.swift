//
//  Coin.swift
//  MinaCoin
//
//  Created by Can on 24.07.2024.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let current_price: Double?
    let market_cap: Double?
    let market_cap_rank: Int?
}

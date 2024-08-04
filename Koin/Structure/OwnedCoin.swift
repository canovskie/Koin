//
//  OwnedCoin.swift
//  MinaCoin
//
//  Created by Can on 27.07.2024.
//

import Foundation

struct OwnedCoin: Codable, Identifiable {
    let id: String
    let name: String
    var amount: Double
    var price: Double
}

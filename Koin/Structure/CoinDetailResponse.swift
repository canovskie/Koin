//
//  CoinDetail.swift
//  MinaCoin
//
//  Created by Can on 25.07.2024.
//

import Foundation

struct PricePoint: Codable, Identifiable {
    let id = UUID()
    let time: Double
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case time = "0"
        case price = "1"
    }
}

struct CoinDetail: Codable {
    let id: String
    let symbol: String
    let name: String
    let description: Description
    let links: Links
    let image: Image
    let market_data: MarketData
    var priceHistory: [PricePoint]?

    struct Description: Codable {
        let en: String?
    }

    struct Links: Codable {
        let homepage: [String?]
    }

    struct Image: Codable {
        let large: String?
    }

    struct MarketData: Codable {
        let current_price: [String: Double?]
        let market_cap: [String: Double?]
        let market_cap_rank: Int?
    }
}

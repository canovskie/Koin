//
//  File.swift
//  MinaCoin
//
//  Created by Can on 29.07.2024.
//

import SwiftUI
import Charts

struct ChartView: View {
    let pricePoints: [PricePoint]

    var body: some View {
        Chart {
            ForEach(pricePoints) { point in
                LineMark(
                    x: .value("Time", Date(timeIntervalSince1970: point.time / 1000)),
                    y: .value("Price", point.price)
                )
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) {
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.day().hour().minute())
            }
        }
        .chartYAxis {
            AxisMarks {
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .currency(code: "USD"))
            }
        }
    }
}


//
//  PlottableRecord.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import Foundation
import CoreMotion

struct PlottableRecord: Identifiable {
    let id = UUID()
    var label: String
    var timestamp: Date
    var value: Double
    
    init(_ label: String, timestamp: Date, value: Double) {
        self.label = label
        self.timestamp = timestamp
        self.value = value
    }
}

extension Array<AccelerationRecord> {
    var plottable: [PlottableRecord] {
        var records: [PlottableRecord] = []
        for record in self {
            let timestamp = record.timestamp
            let plottableX = PlottableRecord(
                "x", timestamp: timestamp, value: record.value.x
            )
            let plottableY = PlottableRecord(
                "y", timestamp: timestamp, value: record.value.y
            )
            let plottableZ = PlottableRecord(
                "z", timestamp: timestamp, value: record.value.z
            )
            records.append(plottableX)
            records.append(plottableY)
            records.append(plottableZ)
        }
        return records
    }
}

extension Array<RotationRateRecord> {
    var plottable: [PlottableRecord] {
        var records: [PlottableRecord] = []
        for record in self {
            let timestamp = record.timestamp
            let plottableX = PlottableRecord(
                "x", timestamp: timestamp, value: record.value.x
            )
            let plottableY = PlottableRecord(
                "y", timestamp: timestamp, value: record.value.y
            )
            let plottableZ = PlottableRecord(
                "z", timestamp: timestamp, value: record.value.z
            )
            records.append(plottableX)
            records.append(plottableY)
            records.append(plottableZ)
        }
        return records
    }
}


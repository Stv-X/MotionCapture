//
//  TransferableRecord.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import Foundation
import CoreMotion

struct TransferableRecord: Codable {
    var timestamp: Date
    var acceleration: CMAcceleration
    var rotationRate: CMRotationRate
    
}

extension Array<TransferableRecord> {
    init(from motionRecord: MotionRecord) {
        var records: [TransferableRecord] = []
        let acceleration = motionRecord.acceleration
        let rotationRate = motionRecord.rotationRate
        let recordCount = Swift.min(acceleration.count, rotationRate.count)
        
        for i in 0..<recordCount {
            let transferableRecord = TransferableRecord(
                timestamp: acceleration[i].timestamp,
                acceleration: acceleration[i].value,
                rotationRate: rotationRate[i].value)
            records.append(transferableRecord)
        }
        
        self = records
    }
}

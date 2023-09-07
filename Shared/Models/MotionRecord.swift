//
//  MotionRecord.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import Foundation
import SwiftData

@Model
final class MotionRecord {
    var id: UUID
    var creationDate: Date
    var caption: String
    var acceleration: [AccelerationRecord]
    var rotationRate: [RotationRateRecord]
    
    init(caption: String,
         acceleration: [AccelerationRecord],
         rotationRate: [RotationRateRecord]) {
        self.id = UUID()
        self.creationDate = Date()
        self.caption = caption
        self.acceleration = acceleration
        self.rotationRate = rotationRate
    }
}

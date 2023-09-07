//
//  AccelerationRecord.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import Foundation
import CoreMotion

struct AccelerationRecord: Identifiable, Codable {
    var id = UUID()
    var timestamp = Date()
    
    var value: CMAcceleration
    
    init(x: Double, y: Double, z: Double) {
        self.value = CMAcceleration(x: x, y: y, z: z)
    }
}

extension CMAcceleration: Codable {
    enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        x = try container.decode(Double.self, forKey: .x)
        y = try container.decode(Double.self, forKey: .y)
        z = try container.decode(Double.self, forKey: .z)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
    }
}

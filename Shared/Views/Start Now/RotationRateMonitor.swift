//
//  RotationRateMonitor.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI
import CoreMotion
import Charts

struct RotationRateMonitor: View {
    @Binding var data: [RotationRateRecord]
    var body: some View {
        VStack {
            HStack {
                Label("Rotation Rate (rad/s)", systemImage: "gyroscope")
                Spacer()
                Image(systemName: CMMotionManager().isDeviceMotionAvailable ? "checkmark.circle.fill" : "xmark.octagon")
            }
            .bold()
            
            HStack {
                VStack {
                    Text("X")
                        .fontWeight(.bold)
                    Text(String(format: "%.2f", data.last?.value.x ?? 0))
                }
                Divider()
                VStack {
                    Text("Y")
                        .fontWeight(.bold)
                    Text(String(format: "%.2f", data.last?.value.y ?? 0))
                }
                Divider()
                VStack {
                    Text("Z")
                        .fontWeight(.bold)
                    Text(String(format: "%.2f", data.last?.value.z ?? 0))
                }
            }
            .fontDesign(.monospaced)
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: [-30, 0])
        .padding(.vertical)
    }
}

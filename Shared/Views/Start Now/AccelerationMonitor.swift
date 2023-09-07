//
//  AccelerationMonitor.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI
import CoreMotion
import Charts

struct AccelerationMonitor: View {
    @Binding var data: [AccelerationRecord]
    var body: some View {
        VStack {
            HStack {
                Label("Acceleration (g)", systemImage: "barometer")
                Spacer()
                Image(systemName: CMMotionManager().isAccelerometerAvailable ? "checkmark.circle.fill" : "xmark.octagon")
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
        .chartYScale(domain: [-20, 20])
        .padding(.vertical)
    }
}


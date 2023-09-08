//
//  StartView.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI
import SwiftData

struct StartView: View {
    @Environment(\.modelContext) private var context
    
    @State var caption: String
    @State private var isCapturing = false
    @State private var manager = MotionCaptureManager(
        updateInterval: 0.01, maxDataCount: 500
    )
    
    @AppStorage("updateInterval") private var updateInterval: Double?
    @AppStorage("captureInterval") private var captureInterval: Double?
    
    var body: some View {
        List {
            AccelerationMonitor(data: $manager.accelerationRecords)
            RotationRateMonitor(data: $manager.rotationRateRecords)
        }
        .navigationBarBackButtonHidden(isCapturing)
        .navigationTitle(caption.capitalized)
        .onDisappear {
            manager.stopMotionCapturing()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    toggleCapturing()
                }) {
                    Image(systemName: isCapturing ? "ellipsis" : "arrow.clockwise")
                        .symbolEffect(
                            .bounce,
                            options: .repeat(isCapturing ? Int(captureInterval ?? 5) : 0).speed(0.75),
                            value: isCapturing
                        )
                        .contentTransition(.symbolEffect(.replace.downUp))
                }
                .disabled(isCapturing)
            }
        }
        .onChange(of: isCapturing) { oldValue, newValue in
            if newValue == true {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: captureInterval ?? 5)) {
                    withAnimation { toggleCapturing() }
                }
            }
        }
        .task {
            if let updateInterval = updateInterval {
                if let captureInterval = captureInterval {
                    let maxDataCount = Int((1 / updateInterval * captureInterval).rounded(.down))
                    manager = MotionCaptureManager(updateInterval: updateInterval, maxDataCount: maxDataCount)
                }
            }
        }
    }
    
    private func toggleCapturing() {
        if isCapturing {
            manager.stopMotionCapturing()
            let acceleration = manager.accelerationRecords
            let rotationRate = manager.rotationRateRecords
            context.insert(MotionRecord(caption: caption, 
                                        acceleration: acceleration,
                                        rotationRate: rotationRate))
            isCapturing = false
        } else {
            manager.startMotionCapturing()
            isCapturing = true
        }
    }
    
}

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

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
                            options: .repeat(isCapturing ? 5 : 0).speed(0.8),
                            value: isCapturing
                        )
                        .contentTransition(.symbolEffect(.replace.downUp))
                }
                .disabled(isCapturing)
            }
        }
        .onChange(of: isCapturing) { oldValue, newValue in
            if newValue == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation { toggleCapturing() }
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

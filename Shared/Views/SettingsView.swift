//
//  SettingsView.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/8.
//

import SwiftUI
import CoreMotion

struct SettingsView: View {
    @AppStorage("updateInterval") private var updateInterval = 0.01
    @AppStorage("captureInterval") private var captureInterval = 5.0
    @AppStorage("isAdvancedModeEnabled") private var isAdvancedSensorModeEnabled = false
    
    var body: some View {
        Form {
            Section {
                Stepper(value: $updateInterval,
                        in: 0.01...0.1,
                        step: 0.01,
                        format: .number) {
#if os(watchOS)
                    Text("Update Interval (sec)")
                        .multilineTextAlignment(.center)
#else
                    Text("Update Interval: " + Measurement(value: updateInterval, unit: UnitDuration.seconds).formatted())
#endif
                }
                
                Stepper(value: $captureInterval,
                        in: 1...10,
                        step: 1,
                        format: .number) {
#if os(watchOS)
                    Text("Capture Interval (sec)")
                        .multilineTextAlignment(.center)
#else
                    Text("Capture Interval: " + Measurement(value: captureInterval, unit: UnitDuration.seconds).formatted())
#endif
                }
            } header: { Text("Capture") } footer: {
                VStack(alignment: .leading) {
                    Text("Sensor Freq: " + Measurement(value: 1 / updateInterval, unit: UnitFrequency.hertz).formatted())
                    Text("Sample Count: " + "\(Int((1 / updateInterval * captureInterval).rounded(.down)))")
                }
            }
            
            Section {
                NavigationLink(destination: advancedSensorModeSettingPage) {
                    VStack(alignment: .leading) {
                        Text("Advanced Mode")
                        Text(isAdvancedSensorModeEnabled ? "ON" : "OFF")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: { Text("Sensor") }
            
            Button {
                cleanTemporaryDirectory()
            } label: {
                Label("Empty the cache data", systemImage: "trash")
            }
        }
        .navigationTitle("Settings")
    }
    
    private var advancedSensorModeSettingPage: some View {
        Form {
            Section {
                Toggle("Advanced Mode", isOn: $isAdvancedSensorModeEnabled)
                    .disabled(!isAdvancedSensorSupported())
            } header: {
                if !isAdvancedSensorSupported() {
                    Text("Advanced Mode is not available on this device.")
                }
            } footer: {
                Text("Advanced Mode uses high-rate sensors and advanced API (aka CMBatchedSensorManager)to achieve more accurate data collection.")
            }
        }
        .navigationTitle("Advanced Mode")
    }
    
    private func isAdvancedSensorSupported() -> Bool {
        let accelerometer = CMBatchedSensorManager.isAccelerometerSupported
        let diviceMotion = CMBatchedSensorManager.isDeviceMotionSupported
        
        return accelerometer && diviceMotion
    }
}

#Preview {
    SettingsView()
}

//
//  MotionCaptureManager.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import Foundation
import CoreMotion

@Observable
class MotionCaptureManager {
    var motionManager: CMMotionManager = CMMotionManager()
    var accelerationRecords: [AccelerationRecord] = []
    var rotationRateRecords: [RotationRateRecord] = []
    
    var updateInterval: TimeInterval
    var maxDataCount: Int
    
    private func startDeviceMotionUpdates() {
        motionManager.deviceMotionUpdateInterval = self.updateInterval
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { deviceMotionData, error in
            guard let rotationRateData = deviceMotionData?.rotationRate else { return }
            guard let userAccelerationData = deviceMotionData?.userAcceleration else { return }
            
            DispatchQueue.main.async {
                let timestamp = Date()
                self.rotationRateRecords.append(
                    RotationRateRecord(
                        timestamp: timestamp,
                        x: rotationRateData.x,
                        y: rotationRateData.y,
                        z: rotationRateData.z))
                
                if self.rotationRateRecords.count > self.maxDataCount {
                    self.rotationRateRecords.remove(at: 0)
                }
                self.accelerationRecords.append(
                    AccelerationRecord(
                        timestamp: timestamp,
                        x: userAccelerationData.x,
                        y: userAccelerationData.y,
                        z: userAccelerationData.z))
                
                if self.accelerationRecords.count > self.maxDataCount {
                    self.accelerationRecords.remove(at: 0)
                }
            }
        }
    }
    
    private func resetMotionDataSet() {
        self.accelerationRecords = []
        self.rotationRateRecords = []
    }
    
    public func startMotionCapturing() {
        resetMotionDataSet()
        self.startDeviceMotionUpdates()
    }
    
    public func stopMotionCapturing() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    init(updateInterval: TimeInterval, maxDataCount: Int) {
        self.updateInterval = updateInterval
        self.maxDataCount = maxDataCount
    }
    
}

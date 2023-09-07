//
//  MotionCaptureApp.swift
//  MotionCapture Watch App
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI
import SwiftData

@main
struct MotionCapture_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    MotionCaption.self,
                    MotionRecord.self
                ])
        }
    }
}

//
//  MotionCaptureApp.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI

@main
struct MotionCaptureApp: App {
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

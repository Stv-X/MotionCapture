//
//  MotionCaption.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import Foundation
import SwiftData

@Model
final class MotionCaption {
    var id: UUID
    var caption: String
    var isSelected: Bool
    
    init(_ caption: String) {
        self.id = UUID()
        self.caption = caption
        self.isSelected = false
    }
    
    init(_ caption: String, isSelected: Bool) {
        self.id = UUID()
        self.caption = caption
        self.isSelected = isSelected
    }
}

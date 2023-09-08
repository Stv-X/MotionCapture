//
//  AddCaptionModal.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/8.
//

import SwiftUI
import SwiftData

struct AddCaptionModal: View {
    @Environment(\.modelContext) private var context
    @Query var allCaptions: [MotionCaption]
    @Binding var isPresented: Bool
    @State private var caption = ""
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Caption", text: $caption)
                #if os(iOS)
                    .textFieldStyle(.roundedBorder)
                #endif
                Spacer()
                Button("Save") {
                    let motionCaption = MotionCaption(caption)
                    context.insert(motionCaption)
                    caption = ""
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(caption == "" || allCaptions.contains(where: { $0.caption == caption }))
            }
            .navigationTitle("Caption")
            .scenePadding()
        }
    }
}

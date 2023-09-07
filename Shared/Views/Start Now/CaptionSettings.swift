//
//  CaptionSettings.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI
import SwiftData

struct CaptionSettings: View {
    @Environment(\.modelContext) private var context
    @Query var allCaptions: [MotionCaption]
    @Binding var selection: String
    @State private var showAddCaption = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCaptions) { caption in
                    Button {
                        selection = caption.caption
                        for caption in allCaptions {
                            caption.isSelected = false
                        }
                        caption.isSelected = true
                    } label: {
                        HStack {
                            Text(caption.caption.capitalized)
                            Spacer()
                            if selection == caption.caption {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            if selection == caption.caption {
                                selection = "unknown"
                            }
                            context.delete(caption)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .disabled(caption.caption == "unknown")
                    }
                }
            }
            .navigationTitle(selection.capitalized)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddCaption = true
                    } label: {
                        Label("Add Caption", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCaption) {
                AddCaptionModal(isPresented: $showAddCaption)
            }
        }
    }
}

struct AddCaptionModal: View {
    @Environment(\.modelContext) private var context
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
                .disabled(caption == "")
                
            }
            .navigationTitle("Caption")
            .scenePadding()
        }
    }
}

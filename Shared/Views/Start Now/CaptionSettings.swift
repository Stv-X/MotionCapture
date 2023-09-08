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
    @Binding var isPresented: Bool
    @State private var showAddCaption = false
    @State private var showTemplates = false
    
    var body: some View {
        List {
            ForEach(allCaptions) { caption in
                Button {
                    selection = caption.caption
                    for caption in allCaptions {
                        caption.isSelected = false
                    }
                    caption.isSelected = true
                    isPresented = false
                } label: {
                    HStack {
                        Text(caption.caption.capitalized)
                            .foregroundStyle(Color.primary)
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
            Section {
                Button("Import from templates") {
                    showTemplates = true
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
        .sheet(isPresented: $showTemplates) {
            CaptionTemplatesModal(isPresented: $showTemplates, selection: $selection)
        }
    }
}

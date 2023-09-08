//
//  CaptionTemplatesModal.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/8.
//

import SwiftUI
import SwiftData

struct CaptionTemplatesModal: View {
    @Environment(\.modelContext) private var context
    @Query var allCaptions: [MotionCaption]
    @Binding var isPresented: Bool
    @Binding var selection: String
    var body: some View {
        NavigationStack {
            Form {
                Button {
                    importBadmintonTemplates()
                } label: {
                    Label("Badminton", systemImage: "figure.badminton")
                }
                
                Button {
                    importFrisbeeTemplates()
                } label: {
                    Label("Frisbee", systemImage: "figure.disc.sports")
                }
            }
            .navigationTitle("Templates")
        }
    }
    
    private func importBadmintonTemplates() {
        for caption in allCaptions {
            if caption.caption != "unknown" {
                if selection == caption.caption {
                    selection = "unknown"
                    allCaptions.first(where: { $0.caption == "unknown" })?.isSelected = true
                }
                context.delete(caption)
            }
        }
        context.insert(MotionCaption("drive"))
        context.insert(MotionCaption("lob"))
        context.insert(MotionCaption("dropShot"))
        context.insert(MotionCaption("clear"))
        context.insert(MotionCaption("smash"))
        context.insert(MotionCaption("spinShot"))
        
        isPresented = false
    }
    
    private func importFrisbeeTemplates() {
        for caption in allCaptions {
            if caption.caption != "unknown" {
                if selection == caption.caption {
                    selection = "unknown"
                    allCaptions.first(where: { $0.caption == "unknown" })?.isSelected = true
                }
                context.delete(caption)
            }
        }
        context.insert(MotionCaption("hammer"))
        context.insert(MotionCaption("forehand"))
        context.insert(MotionCaption("bowler"))
        context.insert(MotionCaption("chickenWing"))
        context.insert(MotionCaption("backhand"))
        
        isPresented = false
    }
}

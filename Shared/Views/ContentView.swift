//
//  ContentView.swift
//  MotionCapture Watch App
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var allRecords: [MotionRecord]
    @Query var allCaptions: [MotionCaption]
    @State private var selectedCaption = "unknown"
    @State private var showStartNow = false
    @State private var showRecords = false
    @State private var showSettings = false
    @State private var showCaptionSettings = false
    
    var body: some View {
        NavigationStack {
            List {
                startNow
                records
            }
            .navigationTitle("MotionCapture")
            .navigationDestination(isPresented: $showStartNow) { NavigationStack { StartView(caption: selectedCaption) } }
            .navigationDestination(isPresented: $showRecords) { NavigationStack { MotionRecordsView() } }
            .navigationDestination(isPresented: $showSettings) { NavigationStack { SettingsView() } }
            .sheet(isPresented: $showCaptionSettings) { NavigationStack { CaptionSettings(selection: $selectedCaption, isPresented: $showCaptionSettings) } }
            
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showSettings = true
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                
                }
            }
            
            #if os(watchOS)
            .listStyle(.carousel)
            #endif
        }
        .task {
            if allCaptions.isEmpty {
                let unknown = MotionCaption("unknown", isSelected: true)
                context.insert(unknown)
            }
            selectedCaption = allCaptions.first(where: { $0.isSelected })?.caption ?? "unknown"
        }
    }
    
    private var startNow: some View {
        Button {
            showStartNow = true
        } label: {
            VStack {
                HStack(alignment: .top) {
                    Image(systemName: "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.accent)
                    Spacer()
                    Button {
                        showCaptionSettings = true
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .foregroundStyle(.accent)
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Start Now")
                            .font(.headline)
                            .foregroundStyle(.accent)
                        Text(selectedCaption.capitalized)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
            .padding(.vertical)
        }
        .listRowBackground(Color.accentColor.opacity(0.3).clipShape(.containerRelative))
        .frame(height: 108)
    }
    
    private var records: some View {
        Button {
            showRecords = true
        } label: {
            VStack {
                HStack(alignment: .top) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.largeTitle)
                        .foregroundStyle(.accent)
                    Spacer()
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Records")
                            .font(.headline)
                            .foregroundStyle(.accent)
                        Text("\(allRecords.count) records")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
            .padding(.vertical)
        }
        .frame(height: 108)
    }
}



#Preview {
    ContentView()
}

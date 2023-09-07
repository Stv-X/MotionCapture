//
//  MotionRecordDetailView.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI
import Charts

struct MotionRecordDetailView: View {
    @State var record: MotionRecord
    var body: some View {
        TabView {
            accelerationStackedChart
                .tabItem {
                    Label("Acceleration", systemImage: "barometer")
                }
            rotationRateStackedChart
                .tabItem {
                    Label("Rotation Rate", systemImage: "gyroscope")
                }
        }
        #if os(watchOS)
        .tabViewStyle(.verticalPage)
        #endif
        .navigationTitle(record.caption.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: TransferableRecords(record), preview: SharePreview(record.caption.capitalized))
            }
        }
    }
    
    private var accelerationStackedChart: some View {
        VStack {
            Chart(record.acceleration.plottable) { record in
                LineMark(
                    x: .value("Timestamp", record.timestamp),
                    y: .value("Acceleration", record.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Axis", record.label))
            }
            .chartXAxis(.hidden)
            .chartYScale(domain: [-20, 20])
            .chartForegroundStyleScale([
                "x": .red,
                "y": .green,
                "z": .blue
            ])
#if os(watchOS)
            .frame(height: 96)
#endif
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Acceleration (g)")
                }
                Spacer()
            }
            .bold()
            .fontDesign(.rounded)
            
        }
#if os(watchOS)
        .containerBackground(.accent.gradient, for: .tabView)
#endif
        .scenePadding()
    }
    
    private var rotationRateStackedChart: some View {
        VStack {
            Chart(record.rotationRate.plottable) { record in
                LineMark(
                    x: .value("Timestamp", record.timestamp),
                    y: .value("RotationRate", record.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Axis", record.label))
            }
            .chartXAxis(.hidden)
            .chartYScale(domain: [-30, 30])
            .chartForegroundStyleScale([
                "x": .red,
                "y": .green,
                "z": .blue
            ])
#if os(watchOS)
            .frame(height: 96)
#endif
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Rotation Rate (rad/s)")
                }
                Spacer()
            }
            .bold()
            .fontDesign(.rounded)
            
        }
#if os(watchOS)
        .containerBackground(.accent.gradient, for: .tabView)
#endif
        .scenePadding()
    }

}


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
            summary
                .tabItem {
                    Label("Summary", systemImage: "doc.text.image")
                }
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
    
    private var summary: some View {
        ScrollView {
            HStack {
                Text(record.creationDate.formatted(date: .abbreviated, time: .standard))
                    .font(.headline)
                Spacer()
            }
                HStack {
                    VStack {
                        Text("\(record.acceleration.count)")
                            .font(.title)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                        Text("Acceleration")
                    }
                    Divider()
                    VStack {
                        Text("\(record.rotationRate.count)")
                            .font(.title)
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                        Text("Rotation Rate")
                    }
                }
                .frame(height: 100)

            HStack {
                Text("Capture Interval")
                    .font(.headline)
                Spacer()
            }
                VStack {
                    Text(Measurement(value: recordTimeInterval().rounded(), unit: UnitDuration.seconds).formatted())
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    HStack {
                        Text(record.acceleration.first!.timestamp.formatted(date: .omitted, time: .standard))
                        Image(systemName: "arrow.forward")
                        Text(record.acceleration.last!.timestamp.formatted(date: .omitted, time: .standard))
                    }
                }
        }
        .scenePadding()
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

    private func recordTimeInterval() -> TimeInterval {
        record.acceleration.last!.timestamp.timeIntervalSince(record.acceleration.first!.timestamp)
    }
}


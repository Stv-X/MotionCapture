//
//  MotionRecordsView.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import SwiftUI
import SwiftData

struct MotionRecordsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \MotionRecord.creationDate, order: .reverse) var allRecords: [MotionRecord]
    
    @State private var archivedRecords = MotionRecordArchive(records: [])
    
    var body: some View {
        VStack {
            if allRecords.isEmpty {
                ContentUnavailableView("No Records", systemImage: "clipboard")
            } else {
                List(allRecords) { record in
                    NavigationLink(destination: { MotionRecordDetailView(record: record) }) {
                        VStack(alignment: .leading) {
                            Text(record.caption.capitalized)
                            Text(record.creationDate.ISO8601Format())
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        ShareLink(item: TransferableRecords(record), preview: SharePreview(record.caption.capitalized))
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            context.delete(record)
                            try! context.save()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Records")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                ShareLink(item: archivedRecords,
                          preview: SharePreview("Archived_" + archivedRecords.id.uuidString))
            }
        }
        .task {
            for record in allRecords {
                let transferableRecords = TransferableRecords(record)
                archivedRecords.records.append(transferableRecords)
            }
        }
        
        .onChange(of: allRecords) {
            archivedRecords = MotionRecordArchive(records: [])
            for record in allRecords {
                let transferableRecords = TransferableRecords(record)
                archivedRecords.records.append(transferableRecords)
            }
        }
    }
}

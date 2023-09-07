//
//  TransferableRecords.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import Foundation
import CoreTransferable

struct TransferableRecords {
    let date: Date
    var caption: String
    var records: [TransferableRecord]
    
    init(caption: String, records: [TransferableRecord]) {
        self.date = Date()
        self.caption = caption
        self.records = records
    }
    
    init(_ records: [TransferableRecord]) {
        self.date = Date()
        self.caption = ""
        self.records = records
    }
    
    init(_ motionRecord: MotionRecord) {
        self.date = motionRecord.creationDate
        self.caption = motionRecord.caption
        self.records = [TransferableRecord](from: motionRecord)
    }
}

extension TransferableRecords: Codable {
    enum CodingKeys: String, CodingKey {
        case date
        case caption
        case records
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.records = try container.decode([TransferableRecord].self, forKey: .records)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(caption, forKey: .caption)
        try container.encode(records, forKey: .records)
    }
}

extension TransferableRecords {
    init(json: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(TransferableRecords.self, from: json)
    }
    
    init(file: URL) {
        let data = try! Data(contentsOf: file)
        try! self.init(json: data)
    }
}

extension TransferableRecords {
    func exportFile() throws -> URL? {
        let data = self
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(data)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                // 创建一个URL以保存JSON文件
                let manager = FileManager.default
                let tmpDirectoryURL = manager.temporaryDirectory
                let fileURL = tmpDirectoryURL.appendingPathComponent(data.caption + "_" + data.date.ISO8601Format() + ".json")
                
                // 将JSON数据写入文件
                try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
                
                return fileURL
            }
        } catch {
            print("导出JSON文件时出错：\(error.localizedDescription)")
        }
        return nil
    }
}

extension TransferableRecords: Transferable {
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .json) { json in
            SentTransferredFile(try! json.exportFile()!)
        } importing: { received in
            return Self.init([])
        }
    }
    
}

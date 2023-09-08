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
        try container.encode(records, forKey: .records)
    }
}


extension TransferableRecords {
    
    private func jsonForML(_ str: String) throws -> String {
        // 将输入的 JSON 字符串转换为 Data
            guard let data = str.data(using: .utf8) else {
                throw NSError(domain: "Invalid JSON String", code: 0, userInfo: nil)
            }

            // 解析 JSON 数据为数组
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]

            // 定义一个数组用于存储转换后的 JSON 对象
            var transformedJsonArray = [[String: Any]]()

            // 遍历原始 JSON 数组
            for jsonObject in jsonArray {
                var transformedObject = [String: Any]()

                // 提取 "timestamp" 键的值
                if let timestamp = jsonObject["timestamp"] as? Double {
                    transformedObject["timestamp"] = timestamp
                }

                // 提取 "acceleration" 键的值，并将其分解成 X、Y、Z 分量
                if let acceleration = jsonObject["acceleration"] as? [String: Double] {
                    transformedObject["accelerationX"] = acceleration["x"]
                    transformedObject["accelerationY"] = acceleration["y"]
                    transformedObject["accelerationZ"] = acceleration["z"]
                }

                // 提取 "rotationRate" 键的值，并将其分解成 X、Y、Z 分量
                if let rotationRate = jsonObject["rotationRate"] as? [String: Double] {
                    transformedObject["rotationRateX"] = rotationRate["x"]
                    transformedObject["rotationRateY"] = rotationRate["y"]
                    transformedObject["rotationRateZ"] = rotationRate["z"]
                }

                // 将转换后的对象添加到新的数组中
                transformedJsonArray.append(transformedObject)
            }

            // 将新的 JSON 数组转换回 JSON 字符串
            let transformedData = try JSONSerialization.data(withJSONObject: transformedJsonArray, options: [.prettyPrinted])
            let transformedString = String(data: transformedData, encoding: .utf8)!

            return transformedString
    }
    
    func exportFile() throws -> URL? {
        let data = self
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(data)
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                if let recordsArray = jsonObject["records"] as? [Any] {
                    if let recordsJsonData = try? JSONSerialization.data(withJSONObject: recordsArray, options: []) {
                        if let recordsJsonString = String(data: recordsJsonData, encoding: .utf8) {
                            if let jsonString = try? jsonForML(recordsJsonString) {
                                let manager = FileManager.default
                                let tmpDirectoryURL = manager.temporaryDirectory
                                let fileURL = tmpDirectoryURL.appendingPathComponent(data.caption + "_" + data.date.ISO8601Format() + ".json")
                                // 将JSON数据写入文件
                                try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
                                return fileURL
                            }
                        }
                    }
                }
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

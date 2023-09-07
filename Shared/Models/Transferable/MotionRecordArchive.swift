//
//  MotionRecordArchive.swift
//  MotionCapture
//
//  Created by 徐嗣苗 on 2023/9/7.
//

import Foundation
import CoreTransferable

struct MotionRecordArchive {
    let id = UUID()
    var records: [TransferableRecords]
}

extension MotionRecordArchive {
    
    func archivedFiles() throws -> URL? {
        
        cleanTemporaryDirectory()
        
        var files: [URL] = []
        
        for record in records {
            if let file = try record.exportFile() {
                files.append(file)
            }
        }
        
        let manager = FileManager.default
        let tmpDirectoryURL = manager.temporaryDirectory
        let archiveDirectoryURL = tmpDirectoryURL.appendingPathComponent("archive_" + id.uuidString)
        
        do {
            // 尝试创建archive目录
            try manager.createDirectory(at: archiveDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            
            // 移动指定的文件到archive目录中
            for fileURL in files {
                let destinationURL = archiveDirectoryURL.appendingPathComponent(fileURL.lastPathComponent)
                
                // 使用FileManager移动文件
                try FileManager.default.moveItem(at: fileURL, to: destinationURL)
            }
            
            return archiveDirectoryURL
            
        } catch {
            // 处理错误
            print("无法创建或移动文件：\(error)")
            return nil
        }
        
    }
    
    func exportArchive() throws -> URL? {
        var error: NSError?
        var internalError: NSError?
        
        let itemURL = try archivedFiles()!
        let zipName = "archive_" + id.uuidString + ".zip"
        let manager = FileManager.default
        let tmpDirectoryURL = manager.temporaryDirectory
        
        NSFileCoordinator().coordinate(readingItemAt: itemURL, options: [.forUploading], error: &error) { (zipUrl) in
            let finalUrl = tmpDirectoryURL.appendingPathComponent(zipName)
            do {
                try manager.moveItem(at: zipUrl, to: finalUrl)
            } catch let localError {
                internalError = localError as NSError
            }
        }
        
        if let error = error {
            throw error
        }
        if let internalError = internalError {
            throw internalError
        }
        
        return tmpDirectoryURL.appendingPathComponent(zipName)
    }
        
}

extension MotionRecordArchive: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .zip) {
            SentTransferredFile(try! $0.exportArchive()!)
        } importing: { received in
            return Self.init(records: [])
        }
    }
}


func cleanTemporaryDirectory() {
    let manager = FileManager.default
    let tmpDirectoryURL = manager.temporaryDirectory
    
    do {
        // 获取tmp文件夹中的所有内容
        let contents = try manager.contentsOfDirectory(atPath: tmpDirectoryURL.path)
        
        // 循环遍历并删除文件和子目录
        for item in contents {
            let itemURL = tmpDirectoryURL.appendingPathComponent(item)
            
            // 尝试删除文件或子目录
            try manager.removeItem(at: itemURL)
            
            // 如果需要处理子目录，请递归调用此方法
        }
        
        print("tmp文件夹已清理")
    } catch {
        print("清理tmp文件夹时出错：\(error)")
    }
}

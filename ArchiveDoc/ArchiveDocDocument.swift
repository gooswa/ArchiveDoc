//
//  ArchiveDocDocument.swift
//  ArchiveDoc
//
//  Created by gooswa on 5/2/21.
//

import SwiftUI
import UniformTypeIdentifiers
import ZIPFoundation

extension UTType {
    static var archiveDoc: UTType {
        UTType(importedAs: "com.example.archive-doc")
    }
}

struct Doc : Codable {
    var text:String
}

final class ArchiveDocDocument: ReferenceFileDocument {
    @Published var doc:Doc

    private var archive:Archive
    
    init() {
        self.doc = Doc(text: "Hello, World!")
        self.archive = Archive(accessMode: .create)!
    }

    static var readableContentTypes: [UTType] { [.archiveDoc] }
    static var writableContentTypes: [UTType] { [.archiveDoc] }
    
    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let archive = Archive(data: data, accessMode: .update) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.archive = archive
        guard let docEntry = archive["doc.json"] else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.doc = Doc(text: "")
        _ = try archive.extract(docEntry) { data in
            let decoder = JSONDecoder()
            self.doc = try decoder.decode(Doc.self, from: data)
        }
    }
    

    
    func snapshot(contentType: UTType) throws -> Data {
        if archive.accessMode == .update {
            if let entry = archive["doc.json"] {
                do {
                    try archive.remove(entry)
                } catch {
                    print("Error: \(error)\ndescription: \(error.localizedDescription)")
                    throw CocoaError(.fileWriteInvalidFileName)
                }
                
            }
        }
        let encoder = JSONEncoder()
        let docData = try encoder.encode(doc)
        try archive.addEntry(with: "doc.json", type: .file, uncompressedSize: UInt32(docData.count)) { pos, size in
            return docData.subdata(in: pos..<pos+size)
        }
        
        guard let data = archive.data else {
            throw CocoaError(.fileWriteUnknown)
        }
        return data
    }

    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
}

//
//  ArchiveDocApp.swift
//  ArchiveDoc
//
//  Created by gooswa on 5/2/21.
//

import SwiftUI

@main
struct ArchiveDocApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ArchiveDocDocument.init) { file in
            ContentView(document: file.document)
        }
    }
}

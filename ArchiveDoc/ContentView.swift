//
//  ContentView.swift
//  ArchiveDoc
//
//  Created by gooswa on 5/2/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var document: ArchiveDocDocument

    var body: some View {
        TextEditor(text: $document.doc.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: ArchiveDocDocument())
    }
}

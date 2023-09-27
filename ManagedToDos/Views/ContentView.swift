//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import SwiftUI
import ManagedModels

struct ContentView: View {
    @State private var selectedList: ToDoList?
    
    var body: some View {
        NavigationSplitView {
            ToDoListsView(selection: $selectedList)
        } detail: {
            if let selectedList {
                ToDoListView(toDoList: selectedList)
            }
            else {
                Text("Please Select a ToDoList!")
            }
        }
    }
}

#Preview {
    #if false // Creates an empty, in-memory database
    ContentView()
        .modelContainer(for: ToDo.self, inMemory: true)
    #else     // In the ``PreviewData/container`` the DB is filled w/ content.
    ContentView()
        .modelContainer(PreviewData.container)
    #endif
}

//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import SwiftUI
import ManagedModels

/**
 * A View that shows a list of ``ToDoList``'s (groups of ``ToDo``'s).
 *
 * It expects that the selection binding is passed in.
 *
 * Example:
 * ```swift
 * @State private var selectedList : ToDoList?
 *
 * var body: some View {
 *     ToDoListsView(selection: $selectedList)
 * }
 * ```
 */
struct ToDoListsView: View {
    
    @Binding var selection : ToDoList?
    
    @Environment(\.modelContext) private var viewContext
    @FetchRequest(sort: \.title, animation: .default)
    private var toDoLists: FetchedResults<ToDoList>
    
    // MARK: - Actions
    
    private func addItem() {
        withAnimation {
            let newList = ToDoList(title: "")
            viewContext.insert(newList)
            try? viewContext.save()
            selection = newList
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets { viewContext.delete(toDoLists[index]) }
            try? viewContext.save()
            
            if selection?.isDeleted ?? true { // doesn't work?
                selection = toDoLists.first
            }
        }
    }
    
    // MARK: - View
    
    var body: some View {
        List(selection: $selection) {
            ForEach(toDoLists) { toDoList in
                NavigationLink(value: toDoList) {
                    ToDoListCell(toDoList: toDoList)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .onAppear {
            if selection == nil {
                selection = toDoLists.first
            }
        }
        .toolbar {
            #if !os(macOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .disabled(toDoLists.isEmpty)
                }
            #endif
            
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add To-Do List", systemImage: "plus")
                }
            }
        }
        .navigationTitle("To-Do Lists")
    }
}

#Preview {
    ToDoListsView(selection: .constant(nil))
        .modelContainer(PreviewData.container)
}

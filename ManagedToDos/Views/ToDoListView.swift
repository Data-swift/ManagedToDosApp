//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import SwiftUI
import ManagedModels

/**
 * A View that shows a list of ``ToDo``'s that are part of a ``ToDoList``.
 *
 * Example:
 * ```swift
 * @State private var selectedList : ToDoList?
 *
 * var body: some View {
 *     ToDoListView(toDoList: selectedList)
 * }
 * ```
 */
struct ToDoListView: View {
    
    @ObservedObject private var toDoList: ToDoList
    
    @Environment(\.modelContext) 
    private var viewContext
    
    @FetchRequest 
    private var toDos: FetchedResults<ToDo>
    
    @State private var navigationPath = NavigationPath()
    
    init(toDoList: ToDoList) {
        self.toDoList = toDoList
        _toDos = .init(
            filter: NSPredicate(format: "list = %@", toDoList),
            sort: [
                .init(\.isDone,   order: .forward),
                .init(\.priority, order: .reverse),
                .init(\.due,      order: .forward),
                .init(\.created,  order: .reverse)
            ],
            animation: .default
        )
    }
    
    // MARK: - Actions
    
    private func addItem() {
        let toDo = ToDo(list: toDoList, title: "", priority: .medium)
        navigationPath.append(toDo)
        try? viewContext.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewContext.delete(toDos[index])
            }
            try? viewContext.save()
        }
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(toDos) { toDo in
                    NavigationLink(value: toDo) {
                        ToDoCell(toDo: toDo)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationDestination(for: ToDo.self) { toDo in
                ToDoEditor(toDo: toDo)
            }
        }
        .toolbar {
            
            #if !os(macOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .disabled(toDoList.toDos.isEmpty)
                }
            #endif
            
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add To-Do", systemImage: "plus")
                }
            }
        }
        .navigationTitle(toDoList.title.isEmpty ? "To-Do List" : toDoList.title)
    }
}

#Preview {
    ToDoListView(toDoList: PreviewData.firstToDoList!)
        .modelContainer(PreviewData.container)
}

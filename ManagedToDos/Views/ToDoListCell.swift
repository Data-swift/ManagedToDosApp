//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import SwiftUI
import ManagedModels

/**
 * A View that shows information about a single ``ToDoList`` (a group of
 * ``ToDo``'s).
 *
 * Example:
 * ```swift
 * @FetchRequest 
 * private var toDoLists: FetchedResults<ToDoList>
 *
 * var body: some View {
 *     List {
 *         ForEach(toDoLists) { toDoList in
 *             ToDoListCell(toDoList: toDoList)
 *         }
 *     }
 * }
 * ```
 */
struct ToDoListCell: View {
    // Note: The accessors peeking into the ``ToDo``s do not actually work
    //       properly, because this View doesn't observe the ``ToDo``s as they
    //       change!
    //       To make this work, some extra listeners would need to be
    //       setup.
    //       (The new Observation framework fixes this).

    @Environment(\.modelContext) private var viewContext
    @ObservedObject var toDoList : ToDoList
    
    private var displayName : String {
        toDoList.title.isEmpty ? "Untitled" : toDoList.title
    }
    
    var body: some View {
        Label {
            HStack {
                Text(verbatim: displayName)
                Spacer()
                if toDoList.hasOverdueItems {
                    Text("❗️")
                }
            }
        }
        icon: {
            Image(systemName: toDoList.doneness.imageName)
        }
    }
}

extension ToDoList.Doneness {
    var imageName: String {
        switch self {
            case .all  : "checklist.checked"
            case .none : "checklist.unchecked"
            case .some : "checklist"
        }
    }
}

#Preview {
    ToDoListCell(toDoList: PreviewData.firstToDoList!)
        .modelContainer(PreviewData.container)
}

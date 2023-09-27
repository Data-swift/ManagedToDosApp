//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import SwiftUI
import ManagedModels

/**
 * A View that shows information about a single ``ToDo``.
 *
 * Example:
 * ```swift
 * @FetchRequest
 * private var toDos: FetchedResults<ToDo>
 *
 * var body: some View {
 *     List {
 *         ForEach(toDos) { toDo in
 *             ToDoCell(toDo: toDo)
 *         }
 *     }
 * }
 * ```
 */
struct ToDoCell: View {
    
    @Environment(\.modelContext) private var viewContext
    @ObservedObject var toDo : ToDo
    
    // MARK: - Actions
    
    func toggle() {
        withAnimation {
            toDo.isDone.toggle()
            try? viewContext.save()
        }
    }
    
    // MARK: - View
    
    private var displayName : String {
        toDo.title.isEmpty ? "Untitled" : toDo.title
    }

    var body: some View {
        Label {
            VStack(alignment: .leading) {
                HStack {
                    Text(verbatim: displayName)
                    
                    Spacer()
                    
                    if      toDo.priority == 4 { Text("❗️") }
                    else if toDo.priority >  4 { Text("‼️") }
                }
                
                if let due = toDo.due {
                    Text("\(due, format: .dateTime)")
                        .font(.footnote)
                        .foregroundColor(toDo.isOverDue && toDo.priority > 2
                                         ? .red : nil)
                }
            }
        }
        icon: {
            Button(action: toggle) {
                Image(systemName: toDo.isDone ? "checkmark.circle" : "circle")
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ToDoCell(toDo: PreviewData.firstToDoList!.toDos.first!)
        .modelContainer(PreviewData.container)
}

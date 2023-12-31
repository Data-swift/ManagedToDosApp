//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import SwiftUI
import ManagedModels

/**
 * A View that provides a form to edit a single ``ToDo``.
 *
 * Example:
 * ```swift
 * ToDoEditor(toDo: myToDo)
 * ```
 */
struct ToDoEditor: View {
    
    @ObservedObject var toDo: ToDo
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var viewContext
    
    @FocusState private var isTitleFocused: Bool
    
    // MARK: - Actions
    
    private func delete() {
        viewContext.delete(toDo)
        dismiss()
        try? viewContext.save()
    }
    
    // MARK: - View

    var body: some View {
        #if os(macOS)
            VStack {
                form
                Spacer()
            }
            .padding()
        #else
            form
        #endif
    }
    private var form: some View {
        Form {
            TextField("Title", text: $toDo.title)
                .focused($isTitleFocused)
            
            Toggle("Done", isOn: $toDo.isDone)
            
            if !toDo.isDone {
                Picker("Priority", selection: $toDo.priority) {
                    ForEach(ToDo.Priority.allCases, id: \.self) { priority in
                        switch priority {
                            case .veryLow  : Text("Very low")
                            case .low      : Text("Low")
                            case .medium   : Text("Medium")
                            case .high     : Text("High")
                            case .veryHigh : Text("Very High")
                        }
                    }
                }

                Toggle("Has Due Date", isOn: Binding(
                    get: { toDo.due != nil },
                    set: { needsDueDate in
                        if needsDueDate {
                            if toDo.due == nil {
                                toDo.due = Date().addingTimeInterval(3600)
                            }
                        }
                        else {
                            toDo.due = nil
                        }
                    }
                ))
                if toDo.due != nil {
                    DatePicker("Due Date", selection: Binding(
                        get: { toDo.due ?? Date() },
                        set: { toDo.due = $0 }
                    ))
                }
            }
        }
        .onAppear {
            isTitleFocused = true
        }
        .onDisappear {
            if toDo.hasChanges { try? viewContext.save() }
        }
        .toolbar {
            Button("Delete Todo", role: .destructive, action: delete)
        }
        .navigationTitle(toDo.title)
    }
}


#Preview {
    ToDoEditor(toDo: PreviewData.firstToDoList!.toDos.first!)
        .modelContainer(PreviewData.container)
}

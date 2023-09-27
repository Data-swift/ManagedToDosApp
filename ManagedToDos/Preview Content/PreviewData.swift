import ManagedModels

/**
 * Provides a prefilled in-memory database that can be used in Previews.
 *
 * If no default data is necessary, a simpler setup can be used, e.g.:
 * ```swift
 * #Preview {
 *     ContentView()
 *         .modelContainer(for: ToDo.self, inMemory: true)
 * }
 * ```
 */
enum PreviewData {
    
    /**
     * Provides a prefilled in-memory database that can be used in Previews.
     */
    static let container : ModelContainer = {
        let container = try! ModelContainer(
            for: ToDo.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        
        let ctx = container.mainContext
        
        do {
            let list = ToDoList(title: "Groceries 🛒")
            ctx.insert(list)
            
            // The insert is not even necessary, done by init
            ctx.insert(ToDo(list: list, title: "Apples"))
            ctx.insert(ToDo(list: list, title: "Oranges"))
            ctx.insert(ToDo(list: list, title: "Juice", priority: 4))
        }
        do {
            let list = ToDoList(title: "To-Do's")
            ctx.insert(list)
            
            // The insert is not even necessary, done by init
            ctx.insert(ToDo(list: list, title: "Wash 🚗",
                            due: Date().advanced(by: 7200)))
            ctx.insert(ToDo(list: list, title: "Rebuild SwiftData",
                            priority: 2,
                            due: Date().advanced(by: -7200)))
            ctx.insert(ToDo(list: list, title: "Do Groceries"))
        }

        return container
    }()
    
    static let firstToDoList : ToDoList? = {
        try! container.mainContext.fetch(ToDoList.fetchRequest()).first
    }()
}

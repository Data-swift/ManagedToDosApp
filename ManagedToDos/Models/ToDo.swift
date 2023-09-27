//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import ManagedModels

/**
 * A model representing a single To-Do.
 *
 * It has a title, whether the todo is done, an optional due date.
 * And a relationship to the ``ToDoList`` it is contained it.
 */
@Model
final class ToDo: NSManagedObject {
    
    var title     : String
    var isDone    : Bool
    var priority  : Int
    var created   : Date
    var due       : Date?
    var list      : ToDoList
    
    convenience init(list     : ToDoList,
                     title    : String,
                     isDone   : Bool  = false,
                     priority : Int   = 3,
                     created  : Date  = Date(),
                     due      : Date? = nil)
    {
        // This is important so that the objects don't end up in different
        // contexts.
        self.init(context: list.modelContext)
        
        self.list     = list
        self.title    = title
        self.isDone   = isDone
        self.priority = priority
        self.created  = created
        self.due      = due
    }

    var isOverDue : Bool {
        guard let due else { return false }
        return due < .now
    }
}

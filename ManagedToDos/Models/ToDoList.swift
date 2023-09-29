//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import ManagedModels

/**
 * A model representing a set of ``ToDo``'s.
 *
 * It just has a title and a toMany relationship to the ``ToDo``s.
 * In CoreData the "toMany" is expressed using a `Set<Target>`.
 */
@Model
final class ToDoList: NSManagedObject {
    
    var title = ""
    var toDos = [ ToDo ]()

    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    var hasOverdueItems : Bool { toDos.contains { $0.isOverDue && !$0.isDone } }
    
    enum Doneness { case all, none, some }
    
    var doneness : Doneness {
        let hasDone   = toDos.contains {  $0.isDone }
        let hasUndone = toDos.contains { !$0.isDone }
        switch ( hasDone, hasUndone ) {
            case ( true  , true  ) : return .some
            case ( true  , false ) : return .all
            case ( false , true  ) : return .none
            case ( false , false ) : return .all // empty
        }
    }
}

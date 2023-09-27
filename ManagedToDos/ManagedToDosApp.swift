//
//  Created by Helge Heß.
//  Copyright © 2023 ZeeZide GmbH.
//

import SwiftUI

@main
struct ManagedToDosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if false // Enable this for the actual CoreData store.
                .modelContainer(for: ToDo.self)
            #else     // A small in-memory DB for testing purposes.
                .modelContainer(PreviewData.container)
            #endif
        }
    }
}

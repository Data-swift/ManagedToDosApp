<h2>ManagedToDos - A ManagedModels Example
  <img src="https://zeezide.com/img/managedmodels/ManagedModelsApp128.png"
       align="right" width="64" height="64" />
</h2>

> Instead of wrapping CoreData, use it directly :-)

**ManagedToDos** is a small example application demonstrating the use of
[ManagedModels](https://github.com/Data-swift/ManagedModels/),
which adds some SwiftData-like `@Model` support to regular CoreData.


### Models

The example uses two CoreData model classes, `ToDo`:
```swift
@Model class ToDo: NSManagedObject {
    
    var title     : String
    var isDone    : Bool
    var priority  : Int
    var created   : Date
    var due       : Date?
    var list      : ToDoList

    var isOverDue : Bool { ... }
}
```
and `ToDoList`:
```swift
@Model class ToDoList: NSManagedObject {
    
    var title : String
    var toDos : Set<ToDo>
    
    var hasOverdueItems : Bool { ... }
}
```


#### Requirements

The macro implementation requires Xcode 15/Swift 5.9 for compilation.
The generated code itself though should backport way back to 
iOS 10 / macOS 10.12 though (when `NSPersistentContainer` was introduced).

Package URLs:
```
https://github.com/Data-swift/ManagedModels.git
https://github.com/Data-swift/ManagedToDosApp.git
```

ManagedModels has no other dependencies.


#### Links

- [ManagedModels](https://github.com/Data-swift/ManagedModels/)
- Apple:
  - [CoreData](https://developer.apple.com/documentation/coredata)
  - [SwiftData](https://developer.apple.com/documentation/swiftdata)
    - [Meet SwiftData](https://developer.apple.com/videos/play/wwdc2023/10187)
    - [Build an App with SwiftData](https://developer.apple.com/videos/play/wwdc2023/10154)
    - [Model your Schema with SwiftData](https://developer.apple.com/videos/play/wwdc2023/10195)
  - [Enterprise Objects Framework](https://en.wikipedia.org/wiki/Enterprise_Objects_Framework) / aka EOF
    - [Developer Guide](https://developer.apple.com/library/archive/documentation/LegacyTechnologies/WebObjects/WebObjects_4.5/System/Documentation/Developer/EnterpriseObjects/DevGuide/EOFDevGuide.pdf)
- [Lighter.swift](https://github.com/Lighter-swift), typesafe and superfast 
  [SQLite](https://www.sqlite.org) Swift tooling.
- [ZeeQL](http://zeeql.io), prototype of an 
  [EOF](https://en.wikipedia.org/wiki/Enterprise_Objects_Framework) for Swift,
  with many database backends.
  


#### Disclaimer

SwiftData and SwiftUI are trademarks owned by Apple Inc. Software maintained as 
a part of the this project is not affiliated with Apple Inc.


### Who

ManagedModels are brought to you by
[Helge Heß](https://github.com/helje5/) / [ZeeZide](https://zeezide.de).
We like feedback, GitHub stars, cool contract work, 
presumably any form of praise you can think of.

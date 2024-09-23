//
//  Task.swift
//  ToDoList
//
//  Data Model for tasks.
//

import Foundation

struct Task: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date
    var details: String?
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, dueDate: Date = Date(), details: String? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.details = details
    }
    
    static func example() -> Task {
        Task(title: "Welcome to Taskly.", dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
    }
    
    static func examples() -> [Task] {
        [
        Task(title: "Welcome to Taskly."),
        Task(title: "Explore the different functionalities."),
        Task(title: "Add a task, delete a task, edit a task"),
        Task(title: "Add task details, due dates"),
        Task(title: "Check off a complete task!")
        ]
    }
}

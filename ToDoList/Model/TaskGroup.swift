//
//  TaskGroup.swift
//  ToDoList
//
//  Model for task groups
//

import Foundation

struct TaskGroup: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    let creationDate: Date
    var tasks: [Task]
    
    init(id: UUID = UUID(), title: String, tasks: [Task] = []) {
        self.id = id
        self.title = title
        self.creationDate = Date()
        self.tasks = tasks
    }
    
    static func example() -> TaskGroup {
        let task1 = Task(title: "Add a task!")
        let task2 = Task(title: "Check off a task!")
        let task3 = Task(title: "Delete a task!")
        
        var group = TaskGroup(title: "Get Started")
        group.tasks = [task1, task2, task3]
        return group
    }
    
    static func examples() -> [TaskGroup] {
        let group1 = TaskGroup.example()
        let group2 = TaskGroup(title: "This is a list")
        return [group1, group2]
    }
    
}

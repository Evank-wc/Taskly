//
//  ContentView.swift
//  ToDoList
//
//
//

import SwiftUI

struct ContentView: View {
    
    @State private var userCreatedGroups: [TaskGroup] = UserDefaults.standard.loadTaskGroups()
    @State private var selection = TaskSection.all
    @State private var allTasks: [Task] = UserDefaults.standard.loadAllTasks() // Load tasks initially
    @State private var searchTerm: String = ""
    

    var body: some View {
        NavigationSplitView {
            SidebarView(userCreatedGroups: $userCreatedGroups, selection: $selection)
                .onChange(of: userCreatedGroups) { _ in
                    saveUserCreatedGroups()
                }
        } detail: {
            if searchTerm.isEmpty {
                switch selection {
                case .all:
                    TaskListView(title: "All", tasks: $allTasks) // Pass the binding
                        .onAppear {
                            reloadTasks() // Reload tasks whenever the view appears
                        }
                case .done:
                    TaskListView(title: "Done", tasks: Binding(get: {allTasks.filter { $0.isCompleted }}, set: { _ in })) // Filtered binding
                        .onAppear {
                            reloadTasks() // Reload tasks whenever the view appears
                        }
                case .upcoming:
                    TaskListView(title: "Upcoming", tasks: Binding(get: {allTasks.filter { !$0.isCompleted }}, set: { _ in })) // Filtered binding
                        .onAppear {
                            reloadTasks() // Reload tasks whenever the view appears
                        }
                case .list(let taskGroup):
                    TaskListView(title: taskGroup.title, tasks: Binding(get: {
                        taskGroup.tasks // Ensure this returns [Task]
                    }, set: { newTasks in
                        // Update the task group with new tasks here if needed
                    }))
                }
            } else {
                TaskListView(title: "Search Results", tasks: Binding(get: {
                    allTasks.filter { $0.title.localizedCaseInsensitiveContains(searchTerm) }
                }, set: { _ in }))
            }
        }
        .searchable(text: $searchTerm)
    }

    private func saveUserCreatedGroups() {
        UserDefaults.standard.saveTaskGroups(userCreatedGroups)
    }

    private func saveAllTasks() {
        UserDefaults.standard.saveAllTasks(allTasks)
    }
    
    private func reloadTasks() {
        allTasks = UserDefaults.standard.loadAllTasks()
    }

}



extension UserDefaults {
    private enum Keys {
        static let taskGroups = "taskGroups"
        static let allTasks = "allTasks"
    }

    // Save Task Groups
    func saveTaskGroups(_ taskGroups: [TaskGroup]) {
        if let encoded = try? JSONEncoder().encode(taskGroups) {
            print("Loaded tasks: \(encoded)")
            set(encoded, forKey: Keys.taskGroups)
        }
    }

    // Load Task Groups
    func loadTaskGroups() -> [TaskGroup] {
        if let data = data(forKey: Keys.taskGroups),
           let decoded = try? JSONDecoder().decode([TaskGroup].self, from: data) {
            print("Loaded tasks: \(decoded)")
            return decoded
        }
        return []
    }

    // Save All Tasks
    func saveAllTasks(_ tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            print("Loaded tasks: \(encoded)")
            set(encoded, forKey: Keys.allTasks)
        }
    }

    // Load All Tasks
    func loadAllTasks() -> [Task] {
        if let data = data(forKey: Keys.allTasks),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            print("Loaded tasks: \(decoded)")
            return decoded
        }
        return []
    }
}



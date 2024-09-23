//
//  TaskListView.swift
//  ToDoList
//
//
//

import SwiftUI

struct TaskListView: View {
    let title: String
    @State private var showingAddTaskSheet = false
    @State private var newTask = Task(title: "", dueDate: Date())
    @Binding var tasks: [Task]

    var body: some View {
        List {
            ForEach($tasks, id: \.id) { $task in
                TaskView(task: $task, onDelete: {
                    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                        tasks.remove(at: index)
                    }
                    saveTasks()
                }, onToggleCompletion: {
                    saveTasks()
                })
            }
            .onDelete(perform: deleteTasks)
        }
        .navigationTitle(title)
        .toolbar {
            Button {
                showingAddTaskSheet = true
            } label: {
                Label("Add New Task", systemImage: "plus")
            }
            .keyboardShortcut(KeyEquivalent("t"), modifiers: .control)
        }
        .sheet(isPresented: $showingAddTaskSheet) {
            AddTaskView(newTask: $newTask, onSave: {
                tasks.append(newTask)
                newTask = Task(title: "", dueDate: Date())
                showingAddTaskSheet = false
                saveTasks()
            }, onCancel: {
                newTask = Task(title: "", dueDate: Date())
                showingAddTaskSheet = false
            })
        }
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    private func saveTasks() {
        UserDefaults.standard.saveAllTasks(tasks)
    }
}

// New View for Adding a Task
struct AddTaskView: View {
    @Binding var newTask: Task
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add New Task")) {
                    TextField("Title", text: $newTask.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    DatePicker("Due Date", selection: $newTask.dueDate, displayedComponents: .date)
                        .padding(.horizontal)
                    TextField("Details", text: Binding<String>(
                        get: { newTask.details ?? "" },
                        set: { newTask.details = $0.isEmpty ? nil : $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }
                }
            }
        }
        .frame(minWidth: 300, minHeight: 200)
    }
}


// Extension to handle optional binding
extension Binding where Value == String? {
    init(_ source: Binding<String>, replacingNilWith defaultValue: String) {
        self.init(get: {
            source.wrappedValue
        }, set: { newValue in
            source.wrappedValue = (newValue!.isEmpty ? nil : newValue) ?? "None"
        })
    }
}


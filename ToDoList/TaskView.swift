//
//  TaskView.swift
//  ToDoList
//
//
//

import SwiftUI

struct TaskView: View {
    
    @Binding var task: Task
    var onDelete: () -> Void
    var onToggleCompletion: () -> Void
    @State private var showingDeleteConfirmation = false
    @State private var showingDetailsPopover = false
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "largecircle.fill.circle" : "circle")
                .onTapGesture {
                    task.isCompleted.toggle()
                    onToggleCompletion()
                    
                }
            
            if task.isCompleted {
                Text(task.title)
                    .strikethrough()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onHover { hovering in
                        showingDetailsPopover = hovering
                    }
                    .popover(isPresented: $showingDetailsPopover) {
                        VStack(alignment: .leading) {
                            Text(task.details ?? "No Details Provided")
                                .padding(.bottom, 5)
                            
                            Text("Due Date: \(formattedDueDate())") // Call the formatted date function
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        }
                        .padding()
                        .frame(width: 200)
                    }
            } else {
                TextField("New Task", text: $task.title)
                    .textFieldStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onHover { hovering in
                        showingDetailsPopover = hovering
                    }
                    .popover(isPresented: $showingDetailsPopover) {
                        VStack(alignment: .leading) {
                            Text(task.details ?? "No Details Provided")
                                .padding(.bottom, 5)
                            
                            Text("Due Date: \(formattedDueDate())") // Call the formatted date function
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        }
                        .padding()
                        .frame(width: 200)
                    }
            }
            
            Button(action: {showingDeleteConfirmation = true}) {
                Image(systemName: "xmark")
            }
            .buttonStyle(PlainButtonStyle())
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(
                    title: Text("Delete Task"),
                    message: Text("Confirm Delete?"),
                    primaryButton: .destructive(Text("Delete")) {
                        onDelete()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func formattedDueDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // You can change this to .short or .long as needed
        return formatter.string(from: task.dueDate)
    }
}



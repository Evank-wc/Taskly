//
//  SidebarView.swift
//  ToDoList
//
//
//

import SwiftUI

struct SidebarView: View {
    
    @Binding var userCreatedGroups: [TaskGroup]
    @Binding var selection: TaskSection
    
    var body: some View {
        List(selection: $selection){
            Section("Basic"){
                ForEach(TaskSection.allCases){ selection in
                    Label(selection.displayName, systemImage: selection.iconName)
                        .tag(selection)
                }
            }
        }
        
        .safeAreaInset(edge: .bottom){
            Text("Taskly")
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    SidebarView(userCreatedGroups: .constant(TaskGroup.examples()), selection: .constant(.all))
        .listStyle(.sidebar)
}

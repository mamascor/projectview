//
//  ContentView.swift
//  pv
//
//  Created by Marco Mascorro on 7/22/23.
//

import SwiftUI
import Algorithms

struct ContentView: View {
    
    @StateObject private var tvm = TaskViewModel()
    
    @State private var nostarted = false
    @State private var inProgress = false
    @State private var done = false
    
    var body: some View {
        HStack(spacing: 15) {
            TasksView(title: "Not Started", tasks: $tvm.notstarted, iT: nostarted)
                .dropDestination(for: String.self) { droppedTask, location in
                    
                    tvm.removeTask(droppedTask: droppedTask, type: .notstarted)
                
                    return true
                } isTargeted: { target in
                    nostarted = target
                }
            TasksView(title: "In Progress",tasks: $tvm.isProgress, iT: inProgress)
                .dropDestination(for: String.self) { droppedTask, location in
                    
                    tvm.removeTask(droppedTask: droppedTask, type: .inProgress)
                
                    return true
                } isTargeted: { target in
                    inProgress = target
                }

            TasksView(title: "Done", tasks: $tvm.isDone, iT: done)
                .dropDestination(for: String.self) { droppedTask, location in
                    
                    tvm.removeTask(droppedTask: droppedTask, type: .done)
                
                    return true
                } isTargeted: { target in
                    done = target
                }
        }
     
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum tasktype {
    case notstarted, inProgress, done
}


class TaskViewModel: ObservableObject {
    
    @Published var notstarted: [String] = ["Hello World"]
    @Published var isProgress: [String] = []
    @Published var isDone: [String] = []
    
    
    func removeTask(droppedTask: [String], type: tasktype){
        
        for task in droppedTask {
            switch type {
            case .notstarted:
                isProgress.removeAll { $0 == task }
                isDone.removeAll { $0 == task }
                let tt = notstarted + droppedTask
                notstarted = Array(tt.uniqued())
            case .inProgress:
                notstarted.removeAll { $0 == task }
                isDone.removeAll { $0 == task }
                
                let tt = isProgress + droppedTask
                isProgress = Array(tt.uniqued())
            case .done:
                isProgress.removeAll { $0 == task }
                notstarted.removeAll { $0 == task }
                
                let tt = isDone + droppedTask
                isDone = Array(tt.uniqued())
            }
        }
        
        
    }
    
    
    
}

struct TasksView: View {
    let title: String
    
    @Binding var tasks: [String]
    
    var iT: Bool
    var body: some View {
        VStack {
            //Title
            HStack {
                Text(title)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "plus")
                        .foregroundColor(.accentColor)
                }
            }
            // Task foreach
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(iT ? .teal.opacity(0.15) : Color(.secondarySystemFill))
                
                VStack(alignment: .leading) {
                    ForEach(tasks, id: \.self) { task in
                        Text(task)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 1, x: 1, y: 1)
                            .padding()
                            .draggable(task)
                           
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            
            
           
            
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
}

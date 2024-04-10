//
//  UserManager.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/10/24.
//

import Foundation

struct todoItem: Hashable {
    var name:String
    var isCompleted:Bool
}

class UserManager: ObservableObject {
    var user = User(name: "", defaultInstrument: "", defaultTag: "")
    @Published var todoList:[todoItem] = [] {
        didSet {
            user.todoList = userTodoListString(todoList)
        }
    }
    
    func setUser(_ user: User) {
        self.user = user
        todoList = userTodoListTuple(user.todoList ?? [])
    }
    
    func userName() -> String {
        return user.name
    }
    
    // TODO LIST
    func getTodoList() -> [todoItem] {
        return userTodoListTuple(user.todoList ?? [])
    }
    
    func addNewTodo() {
        let newTodoItem = todoItem(name: "", isCompleted: false)
        self.todoList.append(newTodoItem)
    }
    
    /// [String] -> [todoItem]
    private func userTodoListTuple(_ stringArray:[String]) -> [todoItem] {
        var result:[todoItem] = []
        
        for string in stringArray {
            let components = string.components(separatedBy: recordDelimiter)
            let todoName = components[0]
            let todoIsCompleted = components[1] == "true"
            result.append(todoItem(name: todoName, isCompleted: todoIsCompleted))
        }
        
        return result
    }

    /// [todoItem] -> [String]
    private func userTodoListString(_ itemArray:[todoItem]) -> [String] {
        var result:[String] = []
        
        for item in itemArray {
            let string = "\(item.name)\(recordDelimiter)\(item.isCompleted)"
            result.append(string)
        }
        
        return result
    }
}

import Foundation

public struct TodoistTask: Codable, Sendable {
    var id: String
    var projectId: String
    var sectionId: String?
    var parentId: String?
    var labels: [String]
    var priority: Int
    var content: String
    var description: String
    var due: Due?
    var isDeleted: Bool
    
    public struct Due: Codable, Sendable {
        var date: String?
        var string: String?
        var isRecurring: Bool = false
    }
}

extension TodoistSession {
    public struct CreateTaskRequest: Encodable, Sendable {
        public init(content: String, projectId: String, description: String? = nil, due: TodoistTask.Due? = nil, priority: Int? = nil, parentId: String? = nil) {
            self.content = content
            self.projectId = projectId
            self.description = description
            self.due = due
            self.priority = priority
            self.parentId = parentId
        }
        
        let content: String
        let projectId: String
        let description: String?
        let due: TodoistTask.Due?
        let priority: Int?
        let parentId: String?
    }
    
    public struct UpdateTaskRequest: Encodable, Sendable {
        public init(id: String, content: Update<String>? = nil, projectId: Update<String>? = nil, description: Update<String>? = nil, due: Update<TodoistTask.Due>? = nil, priority: Update<Int>? = nil, parentId: Update<String>? = nil) {
            self.id = id
            self.content = content
            self.projectId = projectId
            self.description = description
            self.due = due
            self.priority = priority
            self.parentId = parentId
        }
        
        let id: String
        let content: Update<String>?
        let projectId: Update<String>?
        let description: Update<String>?
        let due: Update<TodoistTask.Due>?
        let priority: Update<Int>?
        let parentId: Update<String>?
    }
    
    public struct ReopenTaskRequest: Encodable, Sendable {
        public init(id: String) {
            self.id = id
        }
        
        let id: String
    }
    public struct DeleteTaskRequest: Encodable, Sendable {
        public init(id: String) {
            self.id = id
        }
        
        let id: String
    }
    public struct CompleteTaskRequest: Encodable, Sendable {
        public init(id: String, dateCompleted: Date = Date()) {
            self.id = id
            self.dateCompleted = dateCompleted
        }
        
        let id: String
        let dateCompleted: Date
    }
}

extension Command {
    public static func createTask(task: TodoistSession.CreateTaskRequest) -> Command {
        return  Command(type: "item_add", args: task)
    }
    public static func closeTask(id: String) -> Command {
        return Command(type: "item_close", args: TodoistSession.CompleteTaskRequest(id: id))
    }
    public static func reopenTask(id: String) -> Command {
        return Command(type: "item_reopen", args: TodoistSession.ReopenTaskRequest(id: id))
    }
    public static func deleteTask(id: String) -> Command {
        return Command(type: "item_delete", args: TodoistSession.DeleteTaskRequest(id: id))
    }
    public static func updateTask(update: TodoistSession.UpdateTaskRequest) -> Command {
        return Command(type: "item_update", args: update)
    }
}

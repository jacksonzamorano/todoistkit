import Foundation
extension Todoist {
    struct SyncReadResponse: Codable, Sendable {
        var projects: [TodoistProject]
        var items: [TodoistTask]
        var sections: [TodoistSection]
        var syncToken: String
    }
    struct SyncWriteResponse: Codable {
        var syncToken: String
        var syncStatus: [String:String]
        var tempIdMapping: [String:String]
    }
}

extension TodoistSession {
}

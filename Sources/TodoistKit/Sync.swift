import Foundation
extension Todoist {
    public struct SyncReadResponse: Codable, Sendable {
        var projects: [TodoistProject]
        var items: [TodoistTask]
        var sections: [TodoistSection]
        var syncToken: String
    }
    public struct SyncWriteResponse: Codable, Sendable {
        var syncToken: String
        var syncStatus: [String:String]
        var tempIdMapping: [String:String]
    }
}


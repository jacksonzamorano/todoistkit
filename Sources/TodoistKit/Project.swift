import Foundation

public struct TodoistProject: Codable, Sendable {
    public var id: String
    public var name: String
    public var description: String?
    public var color: String
    public var inboxProject: Bool?
    public var isDeleted: Bool
    public var isCollapsed: Bool
    public var isFavorite: Bool
    public var isArchived: Bool
    public var folderId: String?
    public var parentId: String?
}

public enum ViewStyle: String, Codable, Sendable {
    case list = "list"
    case board = "board"
}

public struct CreateProjectArguments: Encodable, Sendable {
    public init(name: String, color: String? = nil, parentId: String? = nil, folderId: String? = nil, childOrder: Int? = nil, isFavorite: Bool = false, viewStyle: ViewStyle? = nil, description: String? = nil) {
        self.name = name
        self.color = color
        self.parentId = parentId
        self.folderId = folderId
        self.childOrder = childOrder
        self.isFavorite = isFavorite
        self.viewStyle = viewStyle
        self.description = description
    }
    
    public let name: String
    public let color: String?
    public let parentId: String?
    public let folderId: String?
    public let childOrder: Int?
    public let isFavorite: Bool
    public let viewStyle: ViewStyle?
    public let description: String?
}

public struct UpdateProjectArguments: Encodable, Sendable {
    public init(id: String, name: Update<String>? = nil, color: Update<String>? = nil, parentId: Update<String>? = nil, folderId: Update<String>? = nil, childOrder: Update<Int>? = nil, isFavorite: Update<Bool>? = nil, viewStyle: Update<ViewStyle>? = nil, description: Update<String>? = nil) {
        self.id = id
        self.name = name
        self.color = color
        self.parentId = parentId
        self.folderId = folderId
        self.childOrder = childOrder
        self.isFavorite = isFavorite
        self.viewStyle = viewStyle
        self.description = description
    }
    
    public let id: String
    public let name: Update<String>?
    public let color: Update<String>?
    public let parentId: Update<String>?
    public let folderId: Update<String>?
    public let childOrder: Update<Int>?
    public let isFavorite: Update<Bool>?
    public let viewStyle: Update<ViewStyle>?
    public let description: Update<String>?
}

public struct ProjectIdArguments: Encodable, Sendable {
    public init(id: String) {
        self.id = id
    }
    
    public let id: String
}

extension Command {
    static public func createProject(_ arguments: CreateProjectArguments) -> Command {
        return Command(type: "project_add", args: arguments)
    }
    static public func updateProject(_ arguments: UpdateProjectArguments) -> Command {
        return Command(type: "project_update", args: arguments)
    }
    static public func archiveProject(_ arguments: ProjectIdArguments) -> Command {
        return Command(type: "project_archive", args: arguments)
    }
    static public func unarchiveProject(_ arguments: ProjectIdArguments) -> Command {
        return Command(type: "project_unarchive", args: arguments)
    }
    static public func deleteProject(_ arguments: ProjectIdArguments) -> Command {
        return Command(type: "project_delete", args: arguments)
    }
}

import Foundation

public struct TodoistSection: Codable, Sendable, Identifiable {
    public var id: String
    public var projectId: String
    public var name: String
    public var sectionOrder: Int?
    public var isDeleted: Bool
    public var isArchived: Bool
}

public struct CreateSectionRequest: Encodable, Sendable {
    public var name: String
    public var projectId: String
    public var sectionOrder: Int
}

public struct UpdateSectionRequest: Encodable, Sendable {
    public init(id: String, name: Update<String>? = nil, isCollapsed: Update<Bool>? = nil, sectionOrder: Update<Int>? = nil) {
        self.id = id
        self.name = name
        self.isCollapsed = isCollapsed
        self.sectionOrder = sectionOrder
    }

    public var id: String
    public var name: Update<String>?
    public var isCollapsed: Update<Bool>?
    public var sectionOrder: Update<Int>?
}

public struct DeleteSectionRequest: Encodable, Sendable {
    public var id: String
}

extension Command {
    static func createSection(_ request: CreateSectionRequest) -> Self {
        return Command(type: "section_add", args: request)
    }
    static func deleteSection(_ request: DeleteSectionRequest) -> Self {
        return Command(type: "section_delete", args: request)
    }
    static func updateSection(_ request: UpdateSectionRequest) -> Self {
        return Command(type: "section_update", args: request)
    }
}

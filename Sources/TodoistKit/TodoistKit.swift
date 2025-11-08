import Foundation

public typealias TodoistResponse<DataType: Decodable> = Result<DataType, Todoist.Fault>

public class Todoist {
    public struct Fault: Error {
        var message: String
        var todoistErrorCode: Int?
    }
    
    public struct PaginatedResponse<DataType: Decodable>: Decodable {
        var results: [DataType]
        var nextCursor: String?
        
        var hasMore: Bool { nextCursor != nil }
    }
    
    struct TodoistErrorResponse: Error, Codable {
        var error: String
        var errorCode: Int
    }
    
}

public struct Update<T: Encodable & Sendable>: Encodable, Sendable {
    let wrappedValue: T?
    
    public init(_ wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    public static func set(_ value: T) -> Self {
        return .init(value)
    }
    
    public static func unset() -> Self {
        return .init(nil)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        if let wrappedValue {
            try container.encode(wrappedValue)
        } else {
            try container.encodeNil()
        }
    }
}

@Observable
public class TodoistSession {
    public var state = TodoistState()
    
    private var pendingCommands: [Command] = []
    
    var coordinator: TodoistNetworkCoordinator
    
    public init(token: String) {
        self.coordinator = .init(token: token)
    }
    
    func addCommand(_ command: Command) {
        self.pendingCommands.append(command)
    }
    
    public func read() async throws {
        let decoded = try await self.coordinator.read()
        self.state.update(with: decoded)
    }
    
    public func write(readAfter: Bool = true) async throws -> [String:String] {
        let update = try await self.coordinator.write(commands: pendingCommands)
        pendingCommands.removeAll()
        if readAfter {
            try await self.read()
        }
        return update.tempIdMapping
    }
}

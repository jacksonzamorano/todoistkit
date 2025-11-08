@testable import TodoistKit

actor TestCoordinator {
    
    var state: TodoistState = TodoistState()
    let coordinator = TodoistNetworkCoordinator(token: API_KEY)
    
    init() {}
    
    func use<T: Sendable>(_ read: @Sendable (TodoistState) throws -> T) async throws -> T {
        if state.projects.isEmpty {
            try await self.read()
        }
        return try read(state)
    }
    func run(_ commands: @Sendable (TodoistNetworkCoordinator) -> [Command]) async throws -> [String:String] {
        if state.projects.isEmpty {
            try await self.read()
        }
        let commands = commands(self.coordinator)
        return try await write(commands: commands)
    }
    func test<T: Sendable>(
        _ commands: [Command],
        after: @Sendable ([String:String], TodoistState) throws -> T
    ) async throws -> T {
        if state.projects.isEmpty {
            try await self.read()
        }
        let writeData = try await self.write(commands: commands)
        return try after(writeData, self.state)
    }
    
    func read() async throws {
        let read = try await coordinator.read()
        state.update(with: read)
    }
    
    func write(commands: [Command]) async throws -> [String:String] {
        let write = try await coordinator.write(commands: commands)
        try await self.read()
        return write.tempIdMapping
    }
}

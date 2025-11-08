import Testing
@testable import TodoistKit

@Suite("Tasks")
struct TaskTests {
    @Test("Write + Update Priority")
    func taskWriteUpdatePriority() async throws {
        // Get project
        let projectID = try await tests.use { session in
            session.projects.first!.id
        }
        
        // Create task
        let newIdMap = try await tests.run { session in
            return [
                .createTask(task: .init(content: "Test", projectId: projectID, priority: 2))
            ]
        }
        let newId = newIdMap.values.first!
        
        // Set priority
        _ = try await tests.run { session in
            return [
                .updateTask(update: .init(id: newId, priority: .set(3)))
            ]
        }
        
        // Check priority
        try await tests.use { session in
            let task = session.tasks.first(where: { $0.id == newId })!
            #expect(task.priority == 3)
        }
        
        // Cleanup
        _ = try await tests.run { session in
            return [.deleteTask(id: newId)]
        }
    }

    @Test("Write + Set Date")
    func taskWriteSetDate() async throws {
        // Get project
        let projectID = try await tests.use { session in
            session.projects.first!.id
        }
        
        // Create task
        let newIdMap = try await tests.run { session in
            return [
                .createTask(task: .init(content: "Test", projectId: projectID))
            ]
        }
        let newId = newIdMap.values.first!
        
        // Set priority
        _ = try await tests.run { session in
            return [
                .updateTask(update: .init(id: newId,  due: .set(.init(date: "2025-01-01"))))
            ]
        }
        
        // Check priority
        try await tests.use { session in
            let task = session.tasks.first(where: { $0.id == newId })!
            #expect(task.due?.date == "2025-01-01")
        }
        
        // Cleanup
        _ = try await tests.run { session in
            return [.deleteTask(id: newId)]
        }
    }

    @Test("Write + Unset Date")
    func taskWriteUnsetDate() async throws {
        // Get project
        let projectID = try await tests.use { session in
            session.projects.first!.id
        }
        
        // Create task
        let newIdMap = try await tests.run { session in
            return [
                .createTask(task: .init(content: "Test", projectId: projectID, due: .init(date: "2025-01-01")))
            ]
        }
        let newId = newIdMap.values.first!
        
        // Check date is set
        try await tests.use { session in
            let task = session.tasks.first(where: { $0.id == newId })!
            #expect(task.due?.date == "2025-01-01")
        }
        
        // Unset date
        _ = try await tests.run { session in
            return [
                .updateTask(update: .init(id: newId, due: .unset()))
            ]
        }
        
        // Check date is unset
        try await tests.use { session in
            let task = session.tasks.first(where: { $0.id == newId })!
            #expect(task.due?.date == nil)
        }
        
        // Cleanup
        _ = try await tests.run { session in
            return [.deleteTask(id: newId)]
        }
    }
}

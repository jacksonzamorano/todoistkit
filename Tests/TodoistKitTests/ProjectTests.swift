import Testing
@testable import TodoistKit

@Suite("Projects")
struct ProjectTest {
    @Test("Get Inbox")
    func syncRead() async throws {
        try await tests.use { session in
            #expect(session.projects.first(where: { $0.inboxProject == true }) != nil)
        }
    }
    
    @Test("Create Project")
    func createProject() async throws {
        let newId = try await tests.test([.createProject(.init(name: "TodoistKit Testing"))]) { newIds, session in
            let newId = newIds.values.first!
            #expect(session.projects.contains(where: { $0.id == newId }))
            return newId
        }
        _ = try await tests.test([
            .createTask(task: .init(content: "TodoistKit Test Succeded!", projectId: newId))
        ]) { newIds, session in
            let taskId = newIds.values.first!
            let task = session.tasks.first(where: { $0.id == taskId })
            #expect(task != nil)
            #expect(task?.projectId == newId)
            return taskId
        }
        _ = try await tests.run { _ in
            [
                .deleteProject(.init(id: newId))
            ]
        }
    }
    
    @Test("Add Section to Inbox")
    func addSectionToInbox() async throws {
        let inboxId = try await tests.use { session in
            session.projects.first(where: { $0.inboxProject == true })!.id
        }
        let newId = try await tests.test([
            .createSection(.init(name: "Test Section", projectId: inboxId, sectionOrder: 0))
        ]) { inserts, session in
            let id = inserts.values.first!
            #expect(session.sections.first(where: { $0.id == id }) != nil)
            return id
        }
        _ = try await tests.run({ _ in
            [.deleteSection(.init(id: newId))]
        })
    }
    @Test("Update Section In Inbox")
    func updateSectionInInbox() async throws {
        let inboxId = try await tests.use { session in
            session.projects.first(where: { $0.inboxProject == true })!.id
        }
        let newId = try await tests.test([
            .createSection(.init(name: "Test Section", projectId: inboxId, sectionOrder: 0))
        ]) { inserts, session in
            let id = inserts.values.first!
            #expect(session.sections.first(where: { $0.id == id }) != nil)
            return id
        }
        try await tests.test([
            .updateSection(.init(id: newId, name: .set("Updated Test Section")))
        ]) { _, session in
            #expect(session.sections.first(where: { $0.id == newId })?.name == "Updated Test Section")
        }
        _ = try await tests.run { _ in
            [.deleteSection(.init(id: newId))]
        }
    }
}

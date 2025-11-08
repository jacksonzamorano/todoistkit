import Testing
@testable import TodoistKit

@Suite("Sync")
struct SyncTest {
    @Test("Read")
    func syncRead() async throws {
        try await tests.read()
        try await tests.use { session in
            #expect(!session.projects.isEmpty)
        }
    }
}

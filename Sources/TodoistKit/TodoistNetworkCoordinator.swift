import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public actor TodoistNetworkCoordinator {
    var syncToken: String = "*"
    
    let baseURL: URL = URL(string: "https://api.todoist.com/")!
    var token: String
    
    var log: Bool = false
    
    let urlSession = URLSession.shared
    let jsonDecoder: JSONDecoder = .init()
    
    public init(token: String) {
        self.token = token
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func read() async throws -> Todoist.SyncReadResponse {
        let url = baseURL.appending(path: "api/v1/sync")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = SyncReadRequest(syncToken: self.syncToken, resourceTypes: ["all"]).toData()
        request.httpBody = body
        if log {
            print("[Read] \(String(data: body, encoding: .utf8)!)")
        }
        let (data, _) = try await urlSession.data(for: request)
        if let error = try? jsonDecoder.decode(Todoist.TodoistErrorResponse.self, from: data) {
            throw Todoist.TodoistErrorResponse(error: error.error, errorCode: error.errorCode)
        }
        let decoded = try self.jsonDecoder.decode(Todoist.SyncReadResponse.self, from: data)
        self.syncToken = decoded.syncToken
        return decoded
    }
    public func write(commands: [Command]) async throws -> Todoist.SyncWriteResponse {
        let url = baseURL.appending(path: "api/v1/sync")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = SyncWriteRequest(commands: commands).toData()
        request.httpBody = body
        if log {
            print("[Write] \(String(data: body, encoding: .utf8)!)")
        }
        let (data, _) = try await urlSession.data(for: request)
        if let error = try? jsonDecoder.decode(Todoist.TodoistErrorResponse.self, from: data) {
            throw Todoist.TodoistErrorResponse(error: error.error, errorCode: error.errorCode)
        }
        let update = try jsonDecoder.decode(Todoist.SyncWriteResponse.self, from: data)
        return update
    }
}

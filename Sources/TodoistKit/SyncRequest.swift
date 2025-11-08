import Foundation
struct Command: Encodable, Sendable {
    
    var type: String
    var uuid: UUID = UUID()
    var tempId: UUID = UUID()
    var args: Encodable & Sendable
    
    enum CodingKeys: CodingKey {
        case args, type, uuid, tempId
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(args, forKey: .args)
        try container.encode(tempId, forKey: .tempId)
    }
}

extension JSONEncoder {
    func string(_ d: Encodable) -> String {
        return String(data: try! self.encode(d), encoding: .utf8)!
    }
}

struct SyncReadRequest {
    var syncToken: String
    var resourceTypes: [String]
    
    func toData() -> Data {
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "sync_token", value: syncToken),
            URLQueryItem(name: "resource_types", value: JSONEncoder().string(resourceTypes))
        ]
        return urlComponents.percentEncodedQuery!.data(using: .utf8)!
    }
}

struct SyncWriteRequest {
    var commands: [Command]

    func toData() -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        var urlComponents = URLComponents()
        let data = encoder.string(commands)
        urlComponents.queryItems = [
            URLQueryItem(name: "commands", value: data)
        ]
        return urlComponents.percentEncodedQuery!.data(using: .utf8)!
    }
}

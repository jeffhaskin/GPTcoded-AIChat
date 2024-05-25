import Foundation
import Combine

class Conversation: Identifiable, ObservableObject, Codable, Hashable {
    let id: UUID
    @Published var title: String
    @Published var messages: [ChatMessage]
    
    enum CodingKeys: CodingKey {
        case id, title, messages
    }
    
    required init(id: UUID = UUID(), title: String, messages: [ChatMessage] = []) {
        self.id = id
        self.title = title
        self.messages = messages
    }
    
    // Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        messages = try container.decode([ChatMessage].self, forKey: .messages)
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(messages, forKey: .messages)
    }
    
    // Hashable conformance
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let content: String
    let sender: Sender
    
    init(id: UUID = UUID(), content: String, sender: Sender) {
        self.id = id
        self.content = content
        self.sender = sender
    }
}

enum Sender: String, Codable {
    case user
    case ai
}

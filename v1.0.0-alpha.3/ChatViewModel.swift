import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var selectedConversation: Conversation?
    @Published var apiKey: String = ""
    @Published var showSettings = false
    
    init() {
        // Load API key from storage
        if let storedKey = UserDefaults.standard.string(forKey: "OpenAIAPIKey") {
            apiKey = storedKey
        }
        
        // Load conversations from storage
        if let data = UserDefaults.standard.data(forKey: "Conversations"),
           let savedConversations = try? JSONDecoder().decode([Conversation].self, from: data) {
            conversations = savedConversations
        }
    }
    
    func saveAPIKey(_ key: String) {
        apiKey = key
        UserDefaults.standard.set(key, forKey: "OpenAIAPIKey")
    }
    
    func addConversation() {
        let newConversation = Conversation(title: "New Conversation")
        conversations.append(newConversation)
        selectedConversation = newConversation
        saveConversations()
    }
    
    func deleteConversation(id: UUID) {
        if let index = conversations.firstIndex(where: { $0.id == id }) {
            conversations.remove(at: index)
            saveConversations()
        }
    }
    
    func saveConversations() {
        if let data = try? JSONEncoder().encode(conversations) {
            UserDefaults.standard.set(data, forKey: "Conversations")
        }
    }
    
    func sendMessage(_ message: String, in conversation: Conversation) {
        // Append user message to conversation
        let userMessage = ChatMessage(content: message, sender: .user)
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index].messages.append(userMessage)
            saveConversations()
            // Call API and handle response
            sendToAPI(message: message) { response in
                DispatchQueue.main.async {
                    let aiMessage = ChatMessage(content: response, sender: .ai)
                    self.conversations[index].messages.append(aiMessage)
                    self.saveConversations()
                }
            }
        }
    }
    
    private func sendToAPI(message: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            completion("Error: Unable to fetch response")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "user", "content": message]
            ],
            "max_tokens": 150
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API error: \(error.localizedDescription)")
                completion("Error: Unable to fetch response")
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion("Error: Unable to fetch response")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
                completion(result.choices.first?.message.content ?? "Error: No response")
            } catch {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response String: \(responseString)")
                } else {
                    print("Failed to convert data to string.")
                }
                print("Decoding error: \(error.localizedDescription)")
                completion("Error: Unable to fetch response")
            }
        }.resume()
    }
}

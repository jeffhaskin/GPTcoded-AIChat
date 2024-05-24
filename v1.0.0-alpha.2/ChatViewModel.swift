import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentMessage: String = ""
    @Published var apiKey: String {
        didSet {
            UserDefaults.standard.set(apiKey, forKey: "OpenAIAPIKey")
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.apiKey = UserDefaults.standard.string(forKey: "OpenAIAPIKey") ?? ""
    }
    
    func sendMessage() {
        guard !currentMessage.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let userMessage = Message(content: currentMessage, isUser: true)
        messages.append(userMessage)
        
        DispatchQueue.main.async {
            self.currentMessage = ""
        }
        
        getAIResponse(for: userMessage.content)
    }
    
    private func getAIResponse(for message: String) {
        guard !apiKey.isEmpty else {
            print("API Key is empty")
            return
        }
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
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
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .handleEvents(receiveOutput: { data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON String: \(jsonString)")
                }
            })
            .decode(type: OpenAIChatResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                if let aiResponse = response.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) {
                    DispatchQueue.main.async {
                        let aiMessage = Message(content: aiResponse, isUser: false)
                        self.messages.append(aiMessage)
                    }
                }
            })
            .store(in: &cancellables)
    }
}

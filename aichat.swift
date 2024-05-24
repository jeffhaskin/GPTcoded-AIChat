import SwiftUI
import Foundation
import Combine

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    func sendMessage() {
        guard !currentMessage.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let userMessage = Message(content: currentMessage, isUser: true)
        messages.append(userMessage)
        
        // Clear current message after appending to messages
        DispatchQueue.main.async {
            self.currentMessage = ""
        }
        
        // Call the OpenAI API
        getAIResponse(for: userMessage.content)
    }
    
    private func getAIResponse(for message: String) {
        // Replace with your OpenAI API key
        let apiKey = "YOUR_OPENAI_API_KEY_HERE"
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
                // Debug: Print raw response data
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

struct OpenAIChatResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: MessageContent
    }
    
    struct MessageContent: Codable {
        let content: String
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages, id: \.id) { message in
                    HStack {
                        if message.isUser {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Text(message.content)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
            
            HStack {
                TextField("Enter message", text: $viewModel.currentMessage, onCommit: {
                    viewModel.sendMessage()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minHeight: CGFloat(30))
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Text("Send")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

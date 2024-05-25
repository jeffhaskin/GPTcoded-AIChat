import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    @ObservedObject var conversation: Conversation
    
    @State private var messageText: String = ""
    
    var body: some View {
        VStack {
            List(conversation.messages) { message in
                HStack {
                    if message.sender == .user {
                        Spacer()
                        Text(message.content)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    } else {
                        Text(message.content)
                            .padding()
                            .background(Color.gray.quaternary)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
            }
            
            HStack {
                TextField("Message", text: $messageText, onCommit: handleSendMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: handleSendMessage) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle(conversation.title)
        .onAppear {
            viewModel.selectedConversation = conversation
        }
    }
    
    private func handleSendMessage() {
        if !messageText.isEmpty {
            viewModel.sendMessage(messageText, in: conversation)
            DispatchQueue.main.async {
                self.messageText = ""
            }
        }
    }
}

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ChatViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Conversations")) {
                        // Placeholder for future conversation list
                        Text("Conversation 1")
                        Text("Conversation 2")
                    }
                }
                
                NavigationLink(destination: SettingsView(viewModel: viewModel)) {
                    Text("Settings")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding()
            }
            .navigationTitle("AI Chat")
            
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

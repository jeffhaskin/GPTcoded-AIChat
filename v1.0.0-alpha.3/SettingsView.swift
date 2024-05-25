import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    @State private var apiKey: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("OpenAI API Key")) {
                TextField("Enter your API key", text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.saveAPIKey(apiKey)
                }) {
                    Text("Save")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            apiKey = viewModel.apiKey
        }
    }
}

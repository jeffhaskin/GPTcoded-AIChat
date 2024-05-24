import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        Form {
            Section(header: Text("OpenAI API Key")) {
                TextField("Enter API Key", text: $viewModel.apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .navigationTitle("Settings")
    }
}

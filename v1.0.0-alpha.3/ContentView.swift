import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.conversations) { conversation in
                    NavigationLink(destination: ChatView(conversation: conversation).environmentObject(viewModel)) {
                        Text(conversation.title)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteConversation(id: conversation.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Conversations")
            .navigationBarItems(leading: Button(action: {
                viewModel.showSettings.toggle()
            }) {
                Image(systemName: "gear")
                    .foregroundColor(.gray)
            }, trailing: Button(action: {
                viewModel.addConversation()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.yellow)
            })
            
            Text("Select a conversation")
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView().environmentObject(viewModel)
        }
    }
}

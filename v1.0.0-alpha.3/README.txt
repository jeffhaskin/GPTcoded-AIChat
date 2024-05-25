## GPT AI Chat Application - Release Notes

### Version 1.0.0

Welcome to the GPT AI Chat Application! This document provides an overview of all functionalities and features of the application, along with recent bug fixes and enhancements. This release note is intended to help the new developer get up to speed with the project.

### Features and Functionalities

#### 1. **User Conversations**
- **Create Multiple Conversations**: Users can create multiple conversations and interact with the AI within each conversation.
- **View Conversations**: The application displays a list of all user conversations on the left panel.
- **Select Conversation**: Users can select any conversation from the list to view and interact with it in the main panel.

#### 2. **Message Interaction**
- **Send Messages**: Users can send messages to the AI within a selected conversation.
- **AI Responses**: The AI's responses appear in the conversation thread.
- **Input Field**: Includes a `TextField` for users to type messages.
- **Send Button**: A button to send the typed message.
- **Enter Key**: Pressing the enter key also sends the message.

#### 3. **Settings Management**
- **API Key Management**: Users can enter and save their OpenAI API key through a settings view.
- **Settings Access**: Accessible via a settings button in the navigation panel.

#### 4. **Conversation Management**
- **Add Conversations**: Users can add new conversations using a button.
- **Delete Conversations**: Swipe left on a conversation in the list to reveal a delete option.

### Recent Enhancements

#### 1. **Fixed Send vs. Enter Bug**
- **Consistent Message Sending**: Unified the process of sending messages via the send button and the enter key, ensuring the input box is cleared in both cases.

#### 2. **Swipe-to-Delete Functionality**
- **Delete Conversations**: Added the ability to swipe left on conversations in the list to delete them.

### Code Structure

#### Key Files

1. **`MyApp.swift`**: Main entry point of the application.
2. **`ContentView.swift`**: Displays the list of conversations and the main chat area.
3. **`ChatView.swift`**: Handles the display and interaction of messages within a conversation.
4. **`ChatViewModel.swift`**: Manages the logic and state for conversations and messages.
5. **`Conversation.swift`**: Data model for conversations.
6. **`Message.swift`**: Data model for individual messages.
7. **`SettingsView.swift`**: View for managing API key settings.
8. **`OpenAIChatResponse.swift`**: Structure for handling API responses.

### Additional Notes

- **DoubleColumnNavigationViewStyle**: Utilized to ensure the navigation panel and chat view are visible simultaneously.
- **State Management**: Uses SwiftUI's `@State` and `@EnvironmentObject` for state management across views.
- **Concurrency**: Ensures UI updates on the main thread using `DispatchQueue.main.async`.

This document serves as a comprehensive guide to understanding the functionalities and current state of the GPT AI Chat Application. For any further details or questions, please refer to the project documentation or contact the previous developer.

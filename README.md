# GPTcoded-AIChat

## Versions

I'm using ChatGPT to code an iOS AI Chat app. It is very basic in design and function. Current Features (updated 2024-05-24)

### V1.0.0-alpha.1
1. Chat with GPT-4o.
2. Basic conversation memory (verbatim conversation history).

ChatGPTs responses currently aren't streaming, they just appear when they're completed.

### V1.0.0-alpha.2
1. Chat with GPT-4o.
2. Basic conversation memory (verbatim conversation history).
3. Settings window where you can enter your OpenAI API Key.
4. Navigation panel.
   
The Navigation Panel is currently just there for the settings link. Contains dummy elements in preparation to support multiple conversations in the next version.

### V1.0.0-alpha.3 - First fully functional release!
![IMG_0203](https://github.com/jeffhaskin/GPTcoded-AIChat/assets/60890286/69a99734-84f4-4ba7-95e2-33ed12fb2e77)

1. Now suports multiple conversations, including add and swipe-to-delete!
2. Settings window is now modal and works correctly.
3. Uses multi-file structure according to best practice.

## Installation

Due to the early stage of development, this project isn't packaged in a convenient way yet. If you want to try this app out for yourself, here's how:
1. Use "Swift Playgrounds" on iPad. You can start a new app and replicate the file structure, then paste the code into the files. You can then "run" the app and test it out.
2. Use XCode to load these files and export them as an app. You can use XCode to sideload the app onto your device.

*This is part of a larger project to design an AI-powered pipeline that tests and debugs it's own code.*
*I am not a developer. All functionality is directly from ChatGPT, including formating, factoring, any structural choices, etc.*
*All code is tested in the "Swift Playgrounds" app on my iPad. I could use XCode, but I don't have a mac.*

# TTT TTS Plugin for Garry's Mod

This is a Text-to-Speech (TTS) plugin for the Trouble in Terrorist Town (TTT) game mode in Garry's Mod. It allows players to use TTS commands and quick chat messages that are read aloud using a variety of voices.

## Features

- Enable or disable TTS for the entire server or individual clients.
- Choose from a selection of voices for TTS.
- Use quick chat messages with predefined phrases.
- Super admins can control global TTS settings.

## Installation

1. Download the repository and place the files in your Garry's Mod server's `addons` folder.
2. Ensure the necessary permissions and dependencies are met for the server to access the internet for TTS functionality.

## Usage

### Client Commands

- `voice_1`: Enable TTS on the client.
- `voice_0`: Disable TTS on the client.
- `voice_zahar`, `voice_oksana`, `voice_alyss`, `voice_omazh`, `voice_jane`, `voice_random`: Set the TTS voice.

### Server Commands (Super Admin Only)

- `speech_1`: Enable TTS on the server.
- `speech_0`: Disable TTS on the server.

### Chat Commands

Players can use chat commands to control TTS settings or send quick chat messages. The available commands are:

- `!voice_1`: Enable TTS on the client.
- `!voice_0`: Disable TTS on the client.
- `!voice_<voice>`: Set the TTS voice (e.g., `!voice_zahar`).

### Quick Chat

Players can use predefined quick chat messages by pressing the `B` key followed by a number key (1-9):

1. `Да.`
2. `Нет.`
3. `На помощь!`
4. `Я с никто.`
5. `Я вижу никого.`
6. `Никто ведет себя подозрительно.`
7. `Никто предатель!`
8. `Никто невиновный.`
9. `Есть кто живой?`

## Implementation Details

### Client-Side Code

- Listens for network messages to handle TTS speak and toggle events.
- Provides console commands to control TTS settings and voice selection.
- Uses a URL encoding function to handle TTS requests to Yandex TTS API.

### Server-Side Code

- Defines network messages for TTS functionalities.
- Provides commands for super admins to enable or disable TTS globally.
- Handles chat commands and key presses to trigger TTS messages.
- Manages quick chat messages and ensures they are sent with the selected voice.

## Contributing

Feel free to submit issues or pull requests to improve the plugin. Contributions are welcome!

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

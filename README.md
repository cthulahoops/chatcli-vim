# Neovim ChatCLI Integration

This Neovim plugin provides seamless integration with
[ChatCLI](https://github.com/cthulahoops/chatcli), a command-line AI chat tool.
It allows you to interact with ChatCLI directly from within Neovim, enhancing
your workflow by combining the power of AI assistance with your favorite text
editor.

## Features

- Send selected text to ChatCLI
- Read ChatCLI responses and insert code blocks at cursor position
- Display full ChatCLI output in a new split window
- Custom commands and keybindings for easy access

## Installation

1. Ensure you have [ChatCLI](https://github.com/cthulahoops/chatcli) installed and configured on your system.
2. Install this plugin using your preferred Neovim plugin manager. For example, with [packer.nvim](https://github.com/wbthomason/packer.nvim):
3. Add the plugin to your Neovim configuration:

## Usage

### Commands

1. `:ChatCLISend`: Sends the selected text to ChatCLI.
2. `:ChatCLIRead`: Reads the ChatCLI response and inserts code blocks at the cursor position.
3. `:ChatCLIShow`: Opens the full ChatCLI output in a new split window.

### Workflow

1. Select text in visual mode.
2. Use `<leader>cs` to send the selected text to ChatCLI.
3. Use `<leader>cr` to insert code blocks from the ChatCLI response at your cursor position.
4. Use `<leader>co` to view the full ChatCLI response in a new split window.

## Supported ChatCLI Commands

This plugin interacts with ChatCLI using the following commands:

- `chatcli add --continue --role user`: Used to send text to ChatCLI
- `chatcli show`: Used to retrieve ChatCLI's response

Ensure your ChatCLI installation supports these commands.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

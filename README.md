# ![BashBrunch](https://bashbrunch.attaditya.space/preview.png)

Welcome to BashBrunch! A minimal terminal-based coding harness. In here, the AI assistant can access tools to help you do your work. It will be using bash directly and will be communicating with you through this interface.

## Get BashBrunch

```bash
# install with
curl -fsSL https://bashbrunch.attaditya.space/install | bash

# and to use it, just run
brunch
```

## Why BashBrunch?

### Powered by Bash

BashBrunch runs in any terminal with bash 3.2+ and curl present. That's almost any terminal on any system. It's fully made in bash.

### Minimal Tools

The AI is given the least tools and the most power to do anything they want. AI can talk to the user, and execute shell commands directly. This allows for a very flexible and powerful machine usage environment.

### Extensible to Any Provider

While BashBrunch comes with a limited set of providers, one can easily add their own provider by creating a shell script that takes the model name and chat history as input and outputs the AI's response.

### Negligible Overhead

Just because BashBrunch is a simple bash script, it has negligible overhead. It is fast and responsive, and can be used in any terminal without any issues. It can even run in your plain docker container.

### Remote Session Support

BashBrunch allows connecting to remote servers and communicating with it to provide a allow cross-device usage. This allows you to use BashBrunch on a more powerful machine, or from a different device.

### Optimized for AI

Other harnesses are designed for steering AI to do what you want. BashBrunch is designed for the AI to do what it wants. BashBrunch has a special control system, where control starts with the user but once passed to AI, control stays with the AI until it passes control back to the user.

## Using BashBrunch

### Command the AI

```bash
sh-3.2$ brunch
BashBrunch v1.0.5
Use /? for help

Session ID: 1792340175-3954-11723
Active Provider: ollama
Active Model: nemotron-3-ultra:cloud

>>> create a hello world in python, call this file hello.py

[[ shell: echo 'print("Hello, World!")' > hello.py ]]
[[ shell complete (code 0) ]]

>>> 
```

### Run Shell Commands

```bash
sh-3.2$ brunch
BashBrunch v1.0.5
Use /? for help

Session ID: 1792340175-3954-11723
Active Provider: ollama
Active Model: nemotron-3-ultra:cloud

>>> /! echo "Hello from shell"

[[ shell: echo "Hello from shell" ]]
Hello from shell
[[ shell complete (code 0) ]]

>>> 
```

### Change Provider and Model

```bash
sh-3.2$ brunch
BashBrunch v1.0.5
Use /? for help

Session ID: 1792340175-3954-11723
Active Provider: ollama
Active Model: nemotron-3-ultra:cloud

>>> /p
Active Provider: ollama

>>> /m
Active Model: t35:latest

>>> /p custom
Provider changed to custom.

>>> /m custom
Model changed to custom.

>>> /p
Active Provider: custom

>>> /m
Active Model: custom

>>> 
```

### When You're Done

```bash
sh-3.2$ brunch
BashBrunch v1.0.5
Use /? for help

Session ID: 1792340175-3954-11723
Active Provider: ollama
Active Model: nemotron-3-ultra:cloud

>>> /q
Exiting...
Session saved to ~/.bashbrunch/sessions/1792340175-3954-11723.txt

```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `/?` | Show help |
| `/! <cmd>` | Execute a shell command directly |
| `/v` | Show version |
| `/p [provider]` | Show or change provider (e.g., `/p ollama`) |
| `/m [model]` | Show or change model (e.g., `/m llama3.1`) |
| `/k [api_key]` | Show or change API key (e.g., `/k myapikey`) |
| `/q` | Quit |

### AI Commands (used by the assistant)

| Command | Description |
|---------|-------------|
| `/v` | Show version to AI |
| `/sh <cmd>` | Execute a shell command |
| `/msg <text>` | Send a message to user |
| `/pass` | Return control to user |
| `/exit` | Exit the session |
| `/sh2a <contents>` | Adds the contents (Bash code) to SSF |
| `/sh2r [start=0] [count=20]` | Shows count lines of SSF from start line |
| `/sh2x [persist=0]` | Runs the SSF, also clears SSF if persist is 0 |
| `/sh2c` | Clears the script file |

## Providers

Providers are the scripts that handle the AI's responses. They can be built-in or custom. They take the api key (empty string if not needed), model name and chat history as input and output the AI's response.

Find the provider scripts in `providers/` folder in the installation directory (`~/.bashbrunch/providers/`).

### Built-in Providers

- `unset` - Placeholder when no provider is configured
- `ollama` - Local models via Ollama
- `ollama-curl` - Local models via Ollama using curl
- `ollama-api` - Cloud models via Ollama API using curl

### Custom Providers

1. Create `~/.bashbrunch/providers/myprovider.sh`
2. Make it executable: `chmod +x ~/.bashbrunch/providers/myprovider.sh`
3. The script receives:
  - `$1`: api key
  - `$2`: model name
  - `$3`: chat history
4. Output the AI's response to stdout

### Models

Models are completely dependent on the provider. BashBrunch does not provide any models, but allows you to use any model that your provider supports. Selected model is stored in `~/.bashbrunch/models/<provider>.txt`. Change it with `/m <model>` command.

## Flags

| Flag                          | Description                  | Alias                  |
| ----------------------------- | ---------------------------- | ---------------------- |
| `--version`                   | Show version                 | `-v`                   |
| `--help`                      | Show help                    | `-h`                   |
| `--session <session_id>`      | Resume a previous session    | `--resume`, `-s`, `-r` |
| `--incognito`                 | Do not save session          | `-i`                   |
| `--plain`                     | Disable colors               | `-p`                   |
| `--provider <provider>`       | Select an AI provider        | `-P`                   |
| `--model <model>`             | Specify the AI model         | `-M`                   |
| `--key <api_key>`             | Specify the provider API key | `-K`                   |
| `--remote <url>`              | Start a remote session       | `-R`                   |
| `--remote-password <secret>`  | Password for remote session  | `-S`                   |
| `--remote-max-wait <seconds>` | Pause time between retries   | `-W`                   |

## Remote Sessions

Remote sessions allow you to connect to a remote server and use BashBrunch from there. This is useful for accessing BashBrunch from a different machine or when you want to use a more powerful system.

Remote sessions are started and configured by the flags only. Additionally, to use a remote server, ensure that the server is running beforehand.

### Remote Server Contracts

BashBrunch assumes that the remote server is RESTful and has the following endpoints:

- `[POST] /shell`
  - Purpose: Store outputs and logs of BashBrunch.
  - Request Body: Lines of plain text of latest outputs and logs.
  - Response: `200 OK` on success.
- `[GET] /shell`
  - Purpose: Streams the latest outputs and logs of BashBrunch.
  - Response: `200 OK` streaming plain text of latest outputs and logs.
- `[POST] /message`
  - Purpose: Send a message to the remote server.
  - Request Body: Lines of plain text of the message.
  - Response: `200 OK` on success, `400 Bad Request` if no message is provided.
- `[GET] /message`
  - Purpose: Sends a key along with the first message in the queue.
  - Response: `200 OK` with key in line 1 and content from line 2 onwards, or `404 Not Found` if no message is available.
- `[DELETE] /message`
  - Purpose: Deletes the first message in the queue.
  - Response: `200 OK` on success, `400 Bad Request` in any other case.

## Extensions

### What are Extensions?

Extensions are shell scripts that can be added to BashBrunch to extend its functionality. They are sourced when BashBrunch starts, allowing you to add custom commands, functions, or any other bash code that you want to run in the BashBrunch environment.

An extension can run:
- When BashBrunch starts
- Before every loop iteration
- After every loop iteration
- Via commands

### Security Considerations

**Extensions share all variables and functions with BashBrunch**. _This means that extension can potentially access sensitive data like API keys, chat history, etc. Be careful when adding extensions from untrusted sources._

### Creating an Extension

1. Create a shell script with a `.sh` extension.
2. Define functions and commands in the script.
  - For function that runs when BashBrunch starts, define a function named `load_${extension_name}`. (Note that `${extension_name}` is the name of your extension script without the `.sh` extension, it must match or it won't be called.)
  - For function that runs before every loop iteration, define a function named `pre_loop_${extension_name}`.
  - For function that runs after every loop iteration, define a function named `post_loop_${extension_name}`.
  - For commands, define a function prefixed with `command_` and the command name. (For example, if you want to add a command `/hello`, define a function named `command_hello`.)

### Adding Extensions

Once you have an extension script ready, you can add it to BashBrunch by placing it in the `extensions/` folder in the installation directory (`~/.bashbrunch/extensions/`). The script must have a `.sh` extension.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `BRUNCH_ROOT` | Installation directory | `~/.bashbrunch` |

## Requirements

- `bash` 3.2+
- `curl` 8.7+

> Note: Requirements may vary depending on the provider you use.

---

> _Made with <3 by [AttAditya](https://attaditya.space)_


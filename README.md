# AWS SSO Profile Automation for Oh-My-Zsh

A Zsh plugin that streamlines AWS SSO profile management and authentication.

## Installation

1. Clone this repository into your Oh-My-Zsh custom plugins directory:
```bash
git clone https://github.com/turleynerd/zsh-aws-sso-automation.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-aws-sso-automation
```

2. Add the plugin to your Oh-My-Zsh plugins list in `~/.zshrc`:
```bash
plugins=(... zsh-aws-sso-automation)
```

3. Reload your shell configuration:
```bash
source ~/.zshrc
```

## Usage

Once installed, the plugin provides the following functionality:

1. **Automatic AWS SSO Login**:
   - The plugin will automatically detect when your AWS SSO session has expired
   - It will prompt you to reauthenticate when needed
   - Your browser will open automatically to complete the SSO process
   - Shows the time remaining until your SSO session expires

2. **Profile Management Commands**:
   - `account [profile-name]`: Switch to a specific AWS profile
     - When used without arguments, displays the current AWS profile
     - Automatically checks and refreshes SSO authentication if needed
     - Supports tab completion for available profiles
   - `noaccount`: Clear the current AWS profile
     - Removes all AWS profile-related environment variables
     - Useful when you want to ensure no AWS credentials are active

3. **Environment Variables**:
   The plugin manages these environment variables automatically:
   - `AWS_PROFILE`: Current AWS profile name
   - `ACCOUNT`: Alias for the current profile
   - `SSO_EXPIRES_AT`: Tracks SSO session expiration
   - `AWS_PAGER`: Disabled by default for cleaner CLI output

## Requirements

- Oh-My-Zsh
- AWS CLI v2
- Configured AWS SSO profiles in `~/.aws/config`
- [`jq`](https://jqlang.github.io/jq/) command-line tool for JSON processing 

## License

MIT License

## Support

For issues and feature requests, please open an issue on the [GitHub repository](https://github.com/turleynerd/zsh-aws-sso-automation/issues).

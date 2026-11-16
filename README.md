<p align="left">
<a href="https://github.com/martinschumann/.bash-profile-rc/actions"><img src="https://github.com/martinschumann/.bash-profile-rc/actions/workflows/ci.yaml/badge.svg" alt></a>
</p>

# .bash-profile-rc

Comforting on a machine with Bash as default shell by adding aliases, defining functions and setting shell variables. Loads selected Bash snippets from a local configuration file. Additionally includes a pre-commit hook to syntax check PHP, JSON and YAML files (given that PHP and PyYAML are installed).

## Installation

Run the installer as your own user on Debian, Ubuntu or macOS:

```bash
git clone git@github.com:martinschumann/.bash-profile-rc.git ~/.bash-profile-rc
cd ~/.bash-profile-rc
./install.sh
```

Open a new interactive Bash session. Edit `enabled.conf` to change the selection.

## Snippet selection

List one snippet name per line in `enabled.conf`, without the `.rc` suffix.
Blank lines and lines starting with `#` are ignored. For each name, Bash loads
the matching file from `rc.d` first and then from `rc.d-custom`, if present.

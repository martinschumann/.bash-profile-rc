<p align="center">
<a href="https://github.com/martinschumann/bash-profile-rc/actions"><img src="https://github.com/martinschumann/bash-profile-rc/actions/workflows/ci.yaml/badge.svg" alt></a>
</p>

# bash-profile-rc

Comforting on a machine with Bash as default shell by adding aliases, defining functions and setting shell variables. Provides an enable/disable mechanism by symlinking disassembled rc-files. Additionally includes a pre-commit hook to syntax check PHP, JSON and YAML files (given that PHP and PyYAML are installed).

## Installation

Download repo.

```bash
git clone git@github.com:martinschumann/.bash-profile-rc.git
cd bash-profile-rc
```

Link repo's `.bash_profile` as start up file.

```bash
./link-bash-profile.sh
```

Enable all run command files.

```bash
./enable-rc.sh all
source ~/.bash_profile
```

Enable only a specific command.

```bash
./enable-rc.sh outgoing-ip
source ~/.bash_profile
```

Disable all run command files.

```bash
./disable-rc.sh all
source ~/.bash_profile
```

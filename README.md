<p align="center">
<a href="https://github.com/martinschumann/bash-profile-rc/actions"><img src="https://github.com/martinschumann/bash-profile-rc/actions/workflows/ci.yaml/badge.svg" alt></a>
</p>

# bash-profile-rc

Comforting on a machine with Bash as default shell by adding aliases, defining functions and setting shell variables. Loads selected Bash snippets from a local configuration file. Additionally includes a pre-commit hook to syntax check PHP, JSON and YAML files (given that PHP and PyYAML are installed).

## Installation

Run the installer as your own user on Debian, Ubuntu or macOS:

```bash
git clone git@github.com:martinschumann/.bash-profile-rc.git ~/.bash-profile-rc
cd ~/.bash-profile-rc
./install.sh
```

Open a new interactive Bash session. Edit `enabled.conf` to change the selection.
The installer keeps an existing selection and initializes a missing one from
the example file. It appends a loader block
to the user startup files for interactive Bash. You can run it again without
duplicating the blocks.

If you already use the repository's legacy `.bash_profile` symlink, it loads
the snippet loader directly. The installer leaves symlinked startup files for
manual integration.

## Snippet selection

List one snippet name per line in `enabled.conf`, without the `.rc` suffix.
Blank lines and lines starting with `#` are ignored. For each name, Bash loads
the matching file from `rc.d` first and then from `rc.d-custom`, if present.
Git ignores `rc.d-custom`. An empty or missing `enabled.conf` loads no snippets.
Open a new interactive Bash session to apply selection changes.

### Upgrading from the symlink layout

Before updating your checkout, move your local snippets from `rc.d` to
`rc.d-custom`. Add the names of your enabled symlinks and any local snippets
you want to load to `enabled.conf`. After checking your selection, remove the
old `rc-enabled` directory.

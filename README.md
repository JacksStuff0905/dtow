# DTOW (dotfile stow)

dtow is a symlink manager script, written in bash, that was heavily inspired by (GNU Stow)[https://www.gnu.org/software/stow], with more emphasis on dotfile (config file) managment. dtow was made after I ran into issues using stow to symlink files to root directories, like `/etc`. dtow is designed to be as close to a drop-in replacement for stow, as it was possible, using the same CLI option naming and, most of the time, functionality.

---

## How it works

At the basic level dtow functions similarly to stow - it symlinks the config of a specified package (e.g. neovim), which is stored as a directory inside the main stow/dtow directory, to the target path as defined by the file structure inside the package directory. Where the two programs diverge, is the fact that dtow can support defining target directories.

**For example**, in the package directory (`neovim/`) there is a directory called home (`neovim/home/`). According to the default dtow configuration, the file structure inside the home directory (`neovim/home/`) will be copied over to the user home directory (`~/` or `$HOME/`), so a if the package file structure looks like this:
```
neovim/
└── home/
    └── .config/
        └── nvim/
            └── init.vim
```
Inside the home (`~/` or `$HOME/`) directory of the user, a file structure like this will be created, where the init.vim file will be symlinked:
```
~/
└── .config/
    └── nvim/
        └── init.vim
```
By default there are two predefined target directories - `home/`, which points to `~/` (the user's home directory) and `root/` which points to `/` (the root of the filesystem). All other target directories will be copied to the default target - `~/` (the user's home directory), so the directory tree could be refactored, with no change to the result, to look like this:
```
neovim/
└── .config/
    └── nvim/
        └── init.vim
```
Where `.config/` will be assumed to be copied to `~/.config/`
This is a change in comparison to the behaviour of GNU Stow, which by default targets the parent directory of the stow directory, aka `../`

All the target directories, including the default, can be configured in the dtow configuration file (`.dtow`) placed inside the dtow/stow directory. More over, using the `.dtowignore` file, it is possible to define files and directories for dtow to ignore during any operation.

So a complete dtow file structure would look like this:
```
parent-directory/
├── some-package/
│   ├── home/
│   │   ├── home-file.txt
│   │   └── ignored-home-file
│   └── root/
│       └── root-file.txt
├── another-package/
│   └── another-home-file.txt
├── some-ignored-file
├── .dtow
└── .dtowignore
```
---

## Configuration file syntax

Both of the configuration files (`.dtow`, `.dtowignore`) support comments starting with the character '#'.

***.dtow***
```
# This is the dtow configuration file

# You can define folder aliases with the equal(=) operator, like so:
root=/

# You can utilize environment variables:
home=$HOME


# You can define the default folder with the dot(.) symbol.
# It is the fallback in case there are no alias matches with the above:
.=$HOME
```

***.dtowignore***
```
# This is the ignore file, use it like the .gitignore file in git

some-ignored-file

some-ignored-folder/

some-package/another-ignored-file

some-package/another-ignored-folder/
```

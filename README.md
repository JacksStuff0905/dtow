# DTOW (dotfile stow)

dtow is a symlink manager script for GNU/Linux and Mac, written in bash, that was heavily inspired by [GNU Stow](https://www.gnu.org/software/stow), with more emphasis on dotfile (config file) managment. dtow was made after I ran into issues while using stow to symlink files to root directories, like `/etc`. dtow was designed to be as close to a drop-in replacement for stow, as it was possible, using the same CLI option naming and, most of the time, functionality.

**THIS PROGRAM COMES WITH NO WARRANTY, USE AT YOUR OWN RISK**

---

## Installation
### Manual
1. Clone the git repo: `git clone https://github.com/JacksStuff0905/dtow.git`
2. Enter the repo directory: `cd dtow`
3. Run the install script: `./install.sh`
4. Exit the repo directory: `cd ..`
5. Remove the repo directory: `rm -r dtow`

*Uninstalling*
1. Clone the git repo (if you haven't already): `git clone https://github.com/JacksStuff0905/dtow.git`
2. Enter the repo directory: `cd dtow`
3. Run the uninstall script: `./uninstall.sh`
4. Exit the repo directory: `cd ..`
5. Remove the repo directory: `rm -r dtow`

---

## TL;DR

Syntax:
    `dtow [OPTION ...] [-D|-S|-R] PACKAGE ... [-D|-S|-R] PACKAGE ...`

Use like GNU Stow with the difference being:
- everything inside `package/home` will be symlinked/copied to `~/`
- everything inside `package/root` will be symlinked/copied to `/`
- everything inside `package/` that is not either of the above will be symlinked/copied to the default target - `~/`
- if a file cannot be symlinked due to permission problems, dtow will try running the command as the super user, asking for credentials in the process.
- use `dtow --help` to print the help - **WARNING:** Some of the options listed have not been implemented yet, to check which ones go to the [TODO](#todo) section of this readme.
- configure dtow with the `.dtow` file
- configure ignores with the `.dtowignore` file
- **The project is very much in alpha development, there could and probably will be issues when using it.** It has only been tested in the most basic of situations.

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

**.dtow**
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

**.dtowignore**
```
# This is the ignore file, use it like the .gitignore file in git

some-ignored-file

some-ignored-folder/

some-package/another-ignored-file

some-package/another-ignored-folder/
```

---

## TODO

This project was created out of necessity, so it may not be the fastest and most efficient.

There is a very high chance, that there could be issues while using dtow, as it is in very early development, however, as I plan to use it myself, I will probably be fixing most of the bugs I find.

The help menu of the script includes some options which have not been implemented yet. That includes:
```
--defer=REGEX
--override=REGEX
--adopt
--dotfiles
```

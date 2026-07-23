# Intro
A repo to help get Firestone standalone setup on linux. You need Firestone premium for Firestone Standalone

## TLDR Instructions
1. Download the setup exe as `Firestone Standalone Setup.exe`
2. Install the firestone_linux.yaml in lutris
3. [Login](https://www.firestoneapp.com/login) and copy the link on the success Screen
4. Run the script in this repo (see [below](#script-readme))

### Download setup exe
See the first message in the #app-status channel in the firestone discord for the link. You need premium for this.
Rename it to `Firestone Standalone Setup.exe`, removing the version from the file name

### Install the firestone_linux.yaml
Download the file or clone/download the repo, then in Lutris click the + and select `Install from a local install script`, select the file, and when asked select the renamed executable

#### IMPORTANT 
- When prompted select Anyone who uses this computer (all users)
- Uncheck Run Firestone Standalone before clicking finish

### Login and run script
Go to https://www.firestoneapp.com/login, you can also open this url by running firestone then right clicking in the systray.

When you login it probably won't redirect to Firestone (it didn't for me). Assuming it didn't, then you need to copy the link `click here to open firestone`, it'll start with `firestoneapp://`, then run the script (see [below](#script-readme))

If you're not sure which prefix you installed it to then see `Wine prefix` in Lutris by right clicking Firestone -> Configure -> Game options

## Troubleshooting
### Icon not in main systray in Wayland
If they're opening in another window or just missing try installing/starting the `xembed-sni-proxy`.

# Script README

## ⚡ Firestone Auth Link Parser

Quick script to capture the `firestoneapp://` deep-link auth URL and dump the formatted `user.firestone-standalone.json` right into your Wine/Proton prefix.

Useful if you're running Firestone Standalone on Linux via Wine, Proton, or Bottles and need a painless way to pass login sessions.

---

### 🚀 Quick Start (via Nix)

You don't need to clone or install anything if you have Nix enabled with flakes:

#### Interactive Mode
Just run it and follow the prompts:
```bash
nix run github:borisbabic/firestone-linux

```

#### CLI Mode

Pass everything via flags:

```bash
nix run github:your-username/your-repo -- \
  --url "firestoneapp://auth?token=..." \
  --prefix "~/.wine"

```

---

### 🛠️ Usage Options

```text
Usage: parse-firestone [OPTIONS]

Options:
  -u, --url URL           Firestone auth URL (firestoneapp://auth?...)
  -p, --prefix PATH       Path to your Wine prefix directory
  -f, --file PATH         Relative path inside prefix for JSON
                          (default: drive_c/users/steamuser/AppData/Roaming/Firestone Standalone/data/user.firestone-standalone.json)
  -i, --interactive       Run in interactive mode
  -h, --help              Show help message

```

---

### 📦 Running Without Nix

If you prefer cloning and running it directly:

#### Dependencies

Make sure you have these available in your `$PATH`:

* `bash`
* `jq`
* `python3`
* `grep` (GNU grep)

#### Run

```bash
chmod +x parse-firestone.sh
./parse-firestone.sh -i

```



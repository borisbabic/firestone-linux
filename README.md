# Intro
A repo to help get Firestone standalone setup on linux. You need Firestone premium for Firestone Standalone

## TLDR Instructions
1. Download the setup exe as `Firestone Standalone.exe`
2. Install the firestone_linux.yaml in lutris
3. [Login](https://www.firestoneapp.com/login) and copy the link on the success Screen
4. Run the script in this repo (see [below](#script-readme))

### Download setup exe
See the first message in the #app-status channel in the firestone discord for the link. You need premium for this.
Rename it to `Firestone Standalone.exe`, removing the version from the file name

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
### Can't Update
If you're getting an issue with updating that the installer is detecting that firestone is running when it's not then download the new version manually, rename the exe to `Firestone Standalone.exe` then in Lutris click on the Firestone install and select `Run EXE inside Wine prefix` and install it for all users in the installer

![Screenshot showing the Run EXE option in the menu next to the wine icon](https://forums.lutris.net/uploads/default/original/2X/7/7e40460edeaa0aa3d39c9b7810bd2c763f83d48a.png)

Naming it `Firestone Standalone.exe` makes the installer skip the already running check, since NSIS skips it when the installer exe name is the same as the name of the executable that's being installed

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



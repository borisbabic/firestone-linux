

```markdown
# ⚡ Firestone Auth Link Parser

Quick script to capture the `firestoneapp://` deep-link auth URL and dump the formatted `user.firestone-standalone.json` right into your Wine/Proton prefix.

Useful if you're running Firestone Standalone on Linux via Wine, Proton, or Bottles and need a painless way to pass login sessions.

---

## 🚀 Quick Start (via Nix)

You don't need to clone or install anything if you have Nix enabled with flakes:

### Interactive Mode
Just run it and follow the prompts:
```bash
nix run github:your-username/your-repo

```

### CLI Mode

Pass everything via flags:

```bash
nix run github:your-username/your-repo -- \
  --url "firestoneapp://auth?token=..." \
  --prefix "~/.wine"

```

---

## 🛠️ Usage Options

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

## 📦 Running Without Nix

If you prefer cloning and running it directly:

### Dependencies

Make sure you have these available in your `$PATH`:

* `bash`
* `jq`
* `python3`
* `grep` (GNU grep)

### Run

```bash
chmod +x parse-firestone.sh
./parse-firestone.sh -i

```



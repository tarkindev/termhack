# termhack

Welcome to termhack, a tiny terminal hacking simulator that has no code involed.
You're able to solve simple ciphers in your command line.
The game features a small and more cryptic storyline expressed through each "Node", or puzzle.

The source code was written by TarkinDev, with AI being used to help stylize some of the text elements.

---

# How to set up the project
This assumes you have never used a commandline in the past and do not have git set up.

## Step 1: Get the project onto your computer
1. Click the green **Code** button.
2. Click **Download ZIP**
3. Find the downloaded ZIP file (usually in your Downloads folder) and
   extract/unzip it. On Windows, right-click it and choose **Extract All**.
   On Mac, just double-click it.
4. You should now have a folder called `termhack` (or `termhack-main`)
   somewhere on your computer. Remember where it is — you'll need it in
   Step 3.
5. You can move termhack out of your downloads folder to a more convenient location if you would like.

## Step 2: Install Lua

The game is written in the Lua language, thus a lua interpereter is required to run it.

### Windows

1. Go to https://luabinaries.sourceforge.net/ and install **Lua 5.5.0**.
2. Use Extract All on the downloaded zip, and then right-click on the folder directly, click **Copy As Path**
3. Open the Windows **Start Menu** and search *"Edit the System Environment Variables"*, then open it.
4. Click on **Environment Variables** and locate **PATH**, then click edit
5. Add a new row to your path, and paste the copied path in. (Remove the quotation marks)
6. Click the **OK** button on all the paths you opened earlier.
7. Open Powershell and confirmed it worked with either lua -v or lua55 -v

### Mac

1. Open **Terminal** (press `Cmd + Space`, type `Terminal`, hit Enter).
2. If you don't already have Homebrew installed, install it by pasting this
   in and pressing Enter:
   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   Follow any on-screen instructions it gives you.
3. Install Lua:
   ```
   brew install lua
   ```
4. Confirm it worked:
   ```
   lua -v
   ```
   You should see a version number printed.

### Linux

Open a terminal and run the install command for your distro, e.g. on
Ubuntu/Debian:
```
sudo apt-get install lua5.5
```
Then confirm with `lua -v`.

## Step 3: Run the game

1. Open your terminal (PowerShell on Windows, Terminal on Mac/Linux).
2. Navigate into the folder you unzipped in Step 1. If the folder is on
   your Desktop and called `termhack`, that looks like:
   ```
   cd C:\Desktop\termhack
   ```
   (Tip: you can type `cd ` with a trailing space, then drag the folder
   from your file explorer straight into the terminal window — it'll
   fill in the path for you.)
3. Start the game:
   ```
   lua main.lua (or lua55 main.lua)
   ```
4. Follow the on-screen prompts to play.

---

## Troubleshooting

**"lua: command not found" or "'lua' is not recognized"**
Lua isn't installed, or it is not added to your PATH.
Try lua55 -v, if nothing responds then double check
you confirmed all the download steps.


**"cannot open main.lua: No such file or directory"**
You're not in the right folder. Run `ls` (Mac/Linux) or `dir` (Windows) to
see what's in your current folder — you should see `main.lua` listed. If
not, use `cd` to move into the correct folder first (see Step 3.2).

**Nothing happens when I double-click main.lua**
Don't double-click it — it has to be run from the terminal using the
`lua main.lua` command shown in Step 3.

---

## For developers

If you already have Lua and git set up:
```bash
git clone https://github.com/tarkindev/termhack.git
cd termhack
lua main.lua (or lua55 main.lua)
```

Project structure:
- `main.lua` — entry point and game modes (manual/story)
- `engine.lua` — puzzle state, attempts, win/lose logic
- `puzzles.lua` — puzzle content (titles, prompts, answer checks)
- `ui.lua` - text library used for stylization (text colors, seperators, node map)
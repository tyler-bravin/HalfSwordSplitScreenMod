# Half Sword Split Screen Mod
A split screen mod for Half Sword demo v0.3 ([Steam release](https://store.steampowered.com/app/2397300/Half_Sword/)). 
The mod allows you to play Half Sword with two people on two controllers locally (or over Steam Remote Play).
The split screen is vertical (left half and right half). 
You still need a keyboard/mouse to restart the game.

USE AT YOUR OWN RISK.

Compatibility with newer demo versions not guaranteed, and the older demo from `itch.io` won't work.
The mod requires [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS) (version 2.5.2 as of now) to work.

The mod is written in Lua, so you can understand and modify its functionality.
It is based on UE4SS default `SplitScreenMod` with Half Sword specific changes.

## License
Distributed under the MIT License. See `LICENSE` file for more information.

## Showcase
[![YouTube video of Half Sword Split Screen Mod](https://img.youtube.com/vi/E2FQuDH_NJ4/hqdefault.jpg)](https://www.youtube.com/watch?v=E2FQuDH_NJ4)

## Installation

The installation process is very similar to installing [Half Sword Trainer Mod](https://github.com/massclown/HalfSwordTrainerMod) or any other mod on top of UE4SS.

### Detailed steps:

1) Install [an xInput release of UE4SS 2.5.2 from the official repository (UE4SS_Xinput_v2.5.2.zip)](https://github.com/UE4SS-RE/RE-UE4SS/releases/) into the Half Sword demo installation folders according to the UE4SS installation instructions 
([short guide](https://github.com/UE4SS-RE/RE-UE4SS?tab=readme-ov-file#basic-installation) / [full guide](https://docs.ue4ss.com/dev/installation-guide.html)). Basically you will need to unzip that archive and copy the files into the right place. Read the guides for help.

Most probably you will copy all the files from the UE4SS release into:
`C:\Program Files (x86)\Steam\steamapps\common\Half Sword Demo\HalfSwordUE5\Binaries\Win64`,
so the contents of that folder, aside from the actual game files, will now have the following **new** files and folders of UE4SS:
```
...
\Mods\
...
xinput1_3.dll
UE4SS-settings.ini
UE4SS.dll
...
```

2) Download either a release, or a source package of this `HalfSwordSplitScreenMod` repo and unpack it somewhere to take a look. 
* If you want a more stable build, take a named version [from the releases](https://github.com/massclown/HalfSwordSplitScreenMod/releases)
* If you want a fresh development one, click the green "<>Code" button in the top-right of the page and select "Download ZIP".

In the next steps you will copy some folders from inside the folder where you unpacked it into the game folders.

When you unzip the archive, it is going to look like this:
```
\HalfSwordSplitScreenMod\  --> this needs to be copied into the `Mods` folder of your UE4SS installation
LICENSE
README.md
```

3) Copy the entire `HalfSwordSplitScreenMod` folder of the release into the `Mods` folder of your UE4SS installation
(probably into `C:\Program Files (x86)\Steam\steamapps\common\Half Sword Demo\HalfSwordUE5\Binaries\Win64\Mods`)

4) Enable the `HalfSwordSplitScreenMod` in your UE4SS mod loader configuration (`\Mods\mods.txt`).
The new lines in the middle of the file should look like this:
```
...
HalfSwordSplitScreenMod : 1
...
```
We need HalfSwordSplitScreenMod to be enabled.

5) Enjoy the game and support the developers.

## Updating or installing a new release
* You can copy files from the new release of the mod on top of the old one. I do my best to not have any files left from an older version create any problems in the new one.
* If something weird is still happening:
    * delete the old `HalfSwordSplitScreenMod` folder in the `Mods` folder of your UE4SS installation
    (probably in your `C:\Program Files (x86)\Steam\steamapps\common\Half Sword Demo\HalfSwordUE5\Binaries\Win64\Mods`)
    and then copy the new one from the new release.
    * the configuration in `\Mods\mods.txt` does not need to be changed.

## Uninstalling
Delete the files that you copied as described above, or just reinstall the entire Half Sword game entirely (it will wipe all the folders where the installed mod is located)

## How to use the mod
You need two controllers to play it. Keyboard + one controller will not work, only two controllers!

Control the movement of the player with left stick, aiming and swinging with the right stick.

Triggers activate the corresponding arms, bumpers/shoulders pickup or drop weapons from the corresponding arms.

The left-most button of the 4-button group ('X' on Xbox controller, '□' on PS controller) switches hands.

### Keyboard shortcuts of this mod
| Shortcut    | Description |
| ----------- | ----------- |
| `Ctrl + N`  | Add a new player |
| `Ctrl + U`  | Delete a player |

### Other good things
* UE4SS also enables the Unreal Engine console, which can be shown by pressing `F10` or `@`. It is useful to change video settings that are not exposed in Half Sword original UI. 
    * When you know which settings you like, you can save then in the game's `.ini` files in 
`%LOCALAPPDATA%\HalfSwordUE5\Saved\Config\Windows\Engine.ini` or other config files in that folder (so most probably in `C:\Users\%USERNAME%\AppData\Local\HalfSwordUE5\Saved\Config\Windows\`)
    * Some examples of the settings you might want to change in those files (or in the console, on the fly) are:
    ```
    r.fog=0
    r.atmosphere=0
    r.AntiAliasingMethod=1
    ```
* UE4SS has a lot of useful functionality for game modders, read [their docs](https://docs.ue4ss.com/) and have fun.


## Know issues and TODOs
* The mod is not really compatible with Half Sword Trainer Mod. Expect even more crashes if you use both!
* NPCs will keep auto-spawning.
* Player 2 has no HUD, and HUD of Player 1 fills the entire screen when Player 1 is damaged.
* Death of Player 2 allows Player 1 to keep playing, but not vice versa.
* Only some of the keybindings are available (no crouch, no target lock-on, etc.)
* Inventory is bugged and cannot be shown.
* The second player gets launched in the air on start. Simply restart to fix that.
* You need a keyboard to restart or change settings.
* There will be crashes. You have been warned.

## FAQ
### What to do?
Support the developers of Half Sword (https://halfswordgames.com/). 

They have a Kickstarter campaign, currently at https://www.kickstarter.com/projects/halfsword/half-sword-gauntlet

### Game hangs up or freezes or does not respond?
Press `Win + R` and execute the following command line:
```
taskkill /f /im HalfSwordUE5-Win64-Shipping.exe
```
This will kill the game, even if you cannot close it otherwise. In the worst case, reboot.

### UE4SS does not load?
Make sure you can install UE4SS and make it work (confirm that it operates, check its logs, open its GUI console).
* If UE4SS does not work, this mod cannot run at all. It absolutely needs a correct UE4SS installation before you install this mod.

### UE4SS crashes the game?
TBD. Try disabling mods one by one, until you find out what triggers the crash.

Also, try setting the following values in `UE4SS-settings.ini`, in the folder where you installed UE4SS:

```
[EngineVersionOverride]
MajorVersion = 5
MinorVersion = 1
```

### Mod does not load?
Make sure UE4SS loads and observe its logs. It should mention `HalfSwordSplitScreenMod`. 
* If it does not, check that you have the mod files in the right places as explained above.
* If it does, but the mod does not react to the keyboard shortcuts, check the logs for errors related to `HalfSwordSplitScreenMod`.

### Mod crashes the game?
If you suspect the fault is in the logic of this mod, you can try to disable or comment out the last suspicious thing that you used before the crash.

### Mod works, but does not do what I expect?
File an issue here, at https://github.com/massclown/HalfSwordSplitScreenMod/issues

### Any other problem with this mod, or a feature request?
File an issue here, at https://github.com/massclown/HalfSwordSplitScreenMod/issues

## Acknowledgements
* Half Sword developers, https://halfswordgames.com/
* UE4SS developers, https://github.com/UE4SS-RE/RE-UE4SS
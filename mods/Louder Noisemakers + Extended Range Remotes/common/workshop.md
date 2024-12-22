##version=1.1
#title=Louder Soundmakers and 4X Range Remotes
#description=This mod adds louder versions of Wrist Watches, Digital Watches, Alarm Clocks, and Sound Makers.
Also, this mod adds Remotes that have Quadruple the range.

I play with Insane zombie population so this is a must for being able to move the hordes.

The watches are craftable by default.
Alarm Clocks and Soundmakers require the [i]Make Some Noise~!: Mod Your Stereo[/i] magazine.
4X Range Remotes require the [i]Crank It Up: TV Remote Modding Guide[/i] magazine.

These magazines can be found in any area that has electrical magazines at the same rarity.

Ranges:
[list]
[*]LOUDER Wrist Watch - 25 tiles
[*]LOUDER Digital Watch - 25 tiles
[*]LOUDER Alarm Clocks - 50 tiles
[*]LOUDER Noise Maker - 150 tiles (This includes the Timer, Sensor, and Remote versions)
[*]4X Range V1 Remote Controller - 28 tiles
[*]4X Range V2 Remote Controller - 44 tiles
[*]4X Range V3 Remote Controller - 60 tiles
[list]

###Workshop ID: 2909916834
###Mod ID: LSMRR

# How to decompile the java
## Build 42
A way to decompile B42 java is to use [Vineflower](https://github.com/Vineflower/vineflower).

- Download the [latest release](https://github.com/Vineflower/vineflower/releases/tag/1.10.1) of Vineflower (specifically the `.jar` file, like `vineflower-1.10.1.jar`, by clicking on it). Store the file in a folder of your choice
- Create a folder to contain the decompiled code
- You will have to copy the path to the files to decompile. Go in your game files and find the folder `ProjectZomboid/zombie` (for example: `C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid\zombie`)
- If you ever want to recompile the game, you will need to also decompile together all the dependencies and the `zombie` folder: `astar`, `com`, `de`, `fmod`, `javax`, `N3D`, `org`, `se`
- Open a terminal
- In the terminal, type the following commands (make sure to set the correct paths)
```bash
cd <path/to/your/vineflower.jar/file>
```
```bash
java -jar vineflower-1.10.1.jar <path/to/files/to/decompile> <path/to/folder/for/export>
```
-# Make sure to have the right name for the vineflower.jar file (here it's for version 1.10.1)

Here's an example:
```bash
java -jar vineflower-1.10.1.jar C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid\zombie C:\DecompiledPZ
```

**__Important points to note:__**
- You might need a version of java higher than what you have (Project Zomboid is on Java 17), you can download the last one [here](https://www.oracle.com/fr/java/technologies/downloads/). Make sure to restart your terminal after downloading a new java version
- Beautiful java (previously used for B41) can technically still used by modifying the command line needed to run it (thanks <@464148894482432002>)
```diff
- VERSION="$(grep -o 'new GameVersion(.*' "${TMPDIR}/Core.java" | cut -f2 -d'(' | cut -f1,2 -d',' | sed 's/, /./')"
+ VERSION="$(grep -m 1 -o 'new GameVersion(.*' "${TMPDIR}/Core.java" | cut -f2 -d'(' | cut -f1,2 -d',' | sed 's/, /./')"
```
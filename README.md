<h1 align="center">Hyprland Configuration Script V2</h1>
<h3 align="center">By</h3>
<h2 align="center">Js Bro ( Md. Mahin Islam Mahi )</h2>
<br>

## Screenshots
### theme
<p align="center">
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/theme/1.png?raw=true" />
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/theme/2.png?raw=true" /> <br>

   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/theme/3.png?raw=true" />
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/theme/4.png?raw=true" />
</p> <br>

### menu
<p align="center">
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/menu/1.png?raw=true" />
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/menu/2.png?raw=true" /> <br>

   <img aligh="center" width="99%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/menu/3.png?raw=true" />
</p> <br>

### power menu
<p align="center">
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/power/1.png?raw=true" />
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/power/2.png?raw=true" /> <br>
</p> <br>

### wallpaper
<p align="center">
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/wallpaper/1.png?raw=true" />
   <img aligh="center" width="49%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/wallpaper/2.png?raw=true" /> <br>

   <img aligh="center" width="99%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/wallpaper/3.png?raw=true" />
</p> <br>

#### lock screen
<p align="center">
   <img aligh="center" width="99%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/lock.png?raw=true" />
</p>

<br>

## Whats new?
- <h4>Switched from Wlogout to Rofi power menu</h4>
- <h4>Switched from Kitty terminal to Alacritty</h4>
- <h4>Now main wallpapers are also dynamic, ( different for light and dark mode )</h4>
- <h4>Startup sound</h4>
- <h4>System Update notification with a sound</h4>
- <h4>Change theme for Rofi Wallpaper select menu</h4>
- <h4>Change theme for Rofi App launcher menu</h4>
- <h4>Change theme for Rofi Power Menu</h4>
- <h4>Moved from Swaylock to Hyprlock </h4>
- <h4>A script ( setup.sh ) to set this configuration automaticly</h4>
- <h4>Working on more features...</h4>
<br>

## Features
- <h4>Dynamic Wallpaper changing script</h4>
- <h4>Change colors according to the changed wallpaper (pywal)</h4>
- <h4>Light and Dark Mode</h4>
- <h4>Select and Open apps using Rofi</h4>
- <h4>Gorgeous looking Waybar styles</h4>
- <h4>Rofi app launcher styles</h4>
- <h4>Rofi power menu</h4>
- <h4>Opening some web pages as single tab</h4>
- <h4>Locking with Hyprlock</h4>
- <h4>Set your user image in Hyprlock ( a script to set your user image )</h4>
<br>


## Some Questions
<h4>
If you run the <b>start.sh</b> script, it will automaticly detect your distro ( arch / fedora / openSuse ). And it will ask you some questions. Just check the Screenshot bellow.
<img align="center" width="99%" src="https://github.com/me-js-bro/Screen-Shots/blob/main/hyprconf/prompt.jpg?raw=true" />
</h4> <br>

## Configure for OpenBangla-Keyboard ( to write in bangla )
<h4>
If you choose to install and setup the OpenBangla-Keyboard, then you need to follow some steps to add the keyboard in fcitx5. Just follow the instructions bellow.
</h4>
<h4>1) Right click on this keyboard icon in you waybar.</h4>

<img src="https://github.com/me-js-bro/Screen-Shots/blob/main/openbangla/step-1.jpg?raw=true" /> <br>
<h4>2) Search for "openbangla" and select the keyboard</h4>
<img src="https://github.com/me-js-bro/Screen-Shots/blob/main/openbangla/step-2.jpg?raw=true" /> <br>
<h4>3) Now add the keyboard by clicking the 'right aero' icon and click on apply.</h4>
<img src="https://github.com/me-js-bro/Screen-Shots/blob/main/openbangla/step-3.jpg?raw=true" /> <br>

<h4>Now you can switch keyboard using "CTRL + Space"</h4> <br>

## Installation
<h4>To install and setup this hyprland configuration automaticly, just follow these stpes...</h4>

- Clone this repository:
   ```
   git clone --depth=1 https://github.com/me-js-bro/hyprconf-install.git
   ```

- Now cd into hyprconf-install directory and run this command.:
   ```
   cd ~/hyprconf-install
   chmod +x start.sh
   ./start.sh
   ```
- Hurrah! Now reboot your system, select Hyprland from your login manager, log into your Hyprland and enjoy it.
<hr> <br>

<br>

## Keyboard Shortcuts

### Hyprland Keybinds

| Function                        | Keybind                     | Action                                       |
|---------------------------------|-----------------------------|----------------------------------------------|
| Change Wallpaper                | `SUPER` + `W`               | Change desktop wallpaper                     |
|                                 | `SUPER` + `SHIFT` + `W`     | Select wallpaper, style 1                    |
|                                 | `SUPER` + `ALT` + `SHIFT` + `W` | Select wallpaper, style 2                |
| Screenshot                      | `PRINT`                     | Take a screenshot                            |
| Key Binds Help                  | `SUPER` + `SHIFT` + `h`     | Display keybinds help                        |
| Open Terminal                   | `SUPER` + `Return`          | Open terminal (Alacritty)                    |
| Kill Active Window              | `SUPER` + `Q`               | Close active window                          |
| Exit Window Manager             | `SUPER` + `SHIFT` + `M`     | Exit window manager                          |
| Open File Manager               | `SUPER` + `E`               | Open file manager                            |
| Toggle Floating Window          | `SUPER` + `V`               | Toggle floating state of active window       |
| Fullscreen Toggle               | `SUPER` + `f`               | Toggle fullscreen of active window           |
| Open Application Menu           | `SUPER` + `D`               | Open application menu                        |
|                                 | `SUPER` + `ALT` + `D`       | Open theme selector rofi menu                |
| Clipboard Manager               | `SUPER` + `ALT` + `c`       | Manage clipboard contents (clear or view)    |
| Clipboard Wipe                  | `SUPER` + `ALT` + `w`       | Clear clipboard contents                     |
| Emoji Selector                  | `SUPER` + `SHIFT` + `D`     | Open emoji selector                          |
| Shutdown/Restart Menu           | `SUPER` + `x`               | Open power menu                   |
| Change Power Menu Theme         | `SUPER` + `ALT` + `x`       | Change power menu theme                      |
| Open Code Editor                | `SUPER` + `c`               | Open code editor                             |
| Open Web Browsers               | `SUPER` + `b`               | Open preferred web browsers                  |
| Open Web Browsers               | `SUPER` + `SHIFT` + `b`     | Open secondary web browser                   |
| Switch Window                   | `SUPER` + `Tab`             | Open rofi to switch between windows          |
| Hide/Unhide Waybar              | `CONTROL` + `ESCAPE`        | Hide and unhide status bar (waybar)          |
| Lock Screen                     | `SUPER` + `SHIFT` + `l`     | Lock the screen   (Hyprlock)                 |
| Toggle Dark/Light Theme         | `SUPER` + `CTRL` + `l`      | Toggle between dark and light themes         |
| Adjust Waybar Layout            | `SUPER` + `CTRL` + `w`      | Adjust waybar layout                         |
| Edit Dotfiles                   | `SUPER` + `CTRL` + `e`      | Edit dotfiles                                |
| Open Shell Script               | `SUPER` + `ALT` + `b`       | Open theme selector for  shell script   (bash/zsh)  |
| Open Apps (Custom)              | `SUPER` + `SHIFT` + `f`     | Open Facebook                                |
|                                 | `SUPER` + `SHIFT` + `y`     | Open YouTube                                 |
|                                 | `SUPER` + `SHIFT` + `a`     | Open WhatsApp                                |
|                                 | `SUPER` + `CTRL` + `a`      | Open ChatGPT                                 |
|                                 | `SUPER` + `SHIFT` + `g`     | Open GitHub                                  |
|                                 | `SUPER` + `SHIFT` + `p`     | Open Photopea|
| Audio Control                   | `F9`                        | Toggle audio mute                            |
|                                 | `F10`                       | Decrease volume                              |
|                                 | `F11`                       | Increase volume                              |
| Move Focus (Arrow Keys)         | `SUPER` + `l`               | Move focus right                             |
|                                 | `SUPER` + `j`               | Move focus left                              |
|                                 | `SUPER` + `u`               | Move focus up                                |
|                                 | `SUPER` + `M`               | Move focus down                              |
| Move Window (Arrow Keys)        | `SUPER` + `CONTROL` + `j`   | Move window left                             |
|                                 | `SUPER` + `CONTROL` + `l`   | Move window right                            |
|                                 | `SUPER` + `CONTROL` + `u`   | Move window up                               |
|                                 | `SUPER` + `CONTROL` + `m`   | Move window down                             |
| Switch Workspaces               | `SUPER` + `[0-9]`           | Switch to workspace `[0-9]`                  |
| Move Window to Workspace        | `SUPER` + `SHIFT` + `[0-9]` | Move active window to workspace `[0-9]`      |
| Move Window Silently to Workspace | `SUPER` + `ALT` + `[0-9]` | Move window silently to workspace `[0-9]`    |
| Scroll through Workspaces       | `SUPER` + `mouse_down`      | Scroll to next workspace                     |
|                                 | `SUPER` + `mouse_up`        | Scroll to previous workspace                 |
| Move/Resize Window              | `SUPER` + `LMB/RMB`         | Drag to move or resize window                |

### You can also check Keybinds after you installed the script. Just press `Mod ( windows ) + Shift + H`. It will launch a pop up with all the keybindings.

## Contribute.
<h4>
If you want to add your ideas in this project, just do some steps.
</h4>

1) Fork this repository. Make sure to uncheck the `Copy the main branch only`. This will also copy other branches ( if available ).
2) Now clone the forked repository in you machine. <br> Example command:
```
git clone --depth=1 https://github.com/your_user_name/hyprconf.git
```
3) Create a branch by your user_name. <br> Example command:
```
git checkout -b your_user_name
```
4) Now add your ideas and commit to github. <br> Make sure to commit with a detailed test message. For example:
```
git commit -m "fix: Fixed a but in the "example.sh script"
```

```
git commit -m "add: Added this feature. This will happen if the user do this."
```

```
git commit -m "delete: Deleted this. It was creating this example problem"
```
4) While pushing the new commits, make sure to push it to your branch. <br> For example:
```
git push origin your_branch_name
```
5) Now you can create a pull request in the main repository.<br> But make sure to create the pull request in the `development` branch, no the `main` branch.

### Thats all about contributing.
## Reference
#### I would like to thank [JaKooLit](https://github.com/JaKooLit). I was inspired from his Hyprland installation scripts and prepared my script. I took and modified some of his scripts and used here.
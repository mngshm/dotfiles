# ncmpcpp-ueberzug

![ncmpcpp-ueberzug](img/demo.gif)

`ncmpcpp-ueberzug` displays ncmpcpp album art using [ueberzug](https://github.com/seebye/ueberzug). It works on `alacritty`, `st`, `urxvt`,  `kitty`, `xterm` and `lxterm`. Unlike existing scripts, it dynamically sizes and positions the cover art such that the window can be any size, even resized. It has many settings to customize the position of the album art to suit your ncmpcpp setup.

**ncmpcpp-ueberzug is currently gradually being improved, expect more features in each version but also potential changes in how settings work. I will update this message when this script is feature-complete.**

## Install

Follow the instructions on the [Setup](https://github.com/alnj/ncmpcpp-ueberzug/wiki/Setup) wiki page.

Check out [sacad](https://github.com/desbma/sacad) if you want to automatically download cover art for your music library.

## Compatibility

#### Working:
* `alacritty`, `st`, `urxvt`, `xterm`, `lxterm`
* `kitty` (might use wrong terminal if using `--single-instance` flag)

#### Require manually setting character size in `ncmpcpp_cover_art.sh`:
* `cool-retro-term` 
* `sakura` (resizing can break geometry)
* `gnome-terminal`, `terminator`, `xfce4-terminal`  (Album art displays on the last opened terminal irrespective of which is the ncmpcpp window, resizing can break geometry)

#### Broken:
* `konsole` (stops working randomly, geometry is wrong)
* `guake`, `terminology` (geometry is wrong)


## Similar scripts
* [Fixed-width, left-aligned Mopidy album art Python script using Ueberzug](https://www.reddit.com/r/unixporn/comments/addcrf/oc_mopidy_album_art_using_ueberzug/)

* [Ueberzug script that opens the album art in a tmux pane](https://www.reddit.com/r/unixporn/comments/9bifne/ncmpcpp_with_cover_art_ueberzug_tmux_edition/)

* [Fixed-geometry urxvt-compatible script using urxvt background escape codes](https://gist.github.com/vlevit/4588882)

## TODO

* Refactor alignment settings / Add alignment/scaling options for left-align
* Try out toggle?
* Update columns gif with new geometry behaviour, add more illustrations
* Change cleanup mechanism to allow for several ncmpcpp-ueberzug instances
* Support Spotify album art with mopidy

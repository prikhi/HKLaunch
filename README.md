# HKLaunch

`hklaunch` is a simple CLI application launcher.

Clone this repository & install it using `stack install`. Run it using
`hklaunch`.


## Keybindings

* `Up/Down` - scroll through the list of programs
* `Esc/q` - quit hklaunch
* `Enter` - run the selected program


## Sample `~/.hklaunchrc`

The config file follows an ini format. Each section should be the title of
the Application. The only current option is the `command` option, which
specifies the command to be run when launching the application.


    [Enter the Gungeon]
    command = ~/.gog-games/Enter\ the\ Gungeon/start.sh
    
    [Hyper Light Drifter]
    command = ~/.gog-games/Hyper\ Light\ Drifter/start.sh
    
    [Star Wars: Tie Fighter]
    command = ~/.gog-games/STAR\ WARS\ Tie\ Fighter\ Special\ Edition/start.sh
    
    [Star Wars: X-Wing]
    command = ~/.gog-games/STAR\ WARS\ X\ Wing\ Special\ Edition/start.sh

    [Stardew Valley]
    command = playonlinux --run 'Stardew Valley'
    
    [League of Legends]
    command = playonlinux --run 'League of Legends'
    
    [Crypt of the Necrodancer]
    command = steam -applaunch 247080
    
    [Europa Universalis IV]
    command = steam -applaunch 236850
    
    [Hand of Fate]
    command = steam -applaunch 266510
    
    [Hexcells Infinite]
    command = steam -applaunch 304410
    
    [Squarecells]
    command = steam -applaunch 416770
    
    [XCOM: Enemy Unknown]
    command = steam -applaunch 200510
    
    [Cities: Skylines]
    command = steam -applaunch 255710
    
    [Apotheon]
    command = steam -applaunch 208750
    
    [Elder Scrolls: Morrowind]
    command = openmw-launcher
    
    [FreeSpace 2]
    command = wxlauncher

# LICENSE

GPLv3

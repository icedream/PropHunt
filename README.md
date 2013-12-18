# Icedream's Prop Hunt

This is a partially incomplete fork of Prop Hunt by Icedream which is running on the insane-Heroes Prop Hunt servers!

PropHunt plays much like a Hide and Seek. Players on the RED team, disguised as props, are given a 30 second set up time to hide, and afterwards players on the BLU team attempt to find and kill them in the allotted time period. At the end of each round the teams are swapped; the Hunters (BLU) become the Hunted (RED) and vice versa. Respawns are not permitted until the end of each round. 
Originally made for TF2.

Tested on Windows, Mac and Linux.

## Dedicated server FAQ

- _How do I configure this gamemode for my own server?_ See gamemodes/prop_hunt/sh_config.lua.
- _How do I use the fretta map vote?_ Fretta map/gamemode voting is enabled by default. You can disable it via cvars though. Fretta gamemode will ask all users after the last round to vote for a gamemode and a map automatically. It works just out of the box. :P

## Player FAQ

- _How do I disguise as a prop?_ First you need to be in the prop team. You need also a map with props, an when you are in front of it, press 'E'. 
- _How do I change to another team?_ Just press 'F2'
- _How do I play a taunt?_ Just press 'F3'
- _How do I play the game?_ You need at least one player for team (Props and Hunters). The props (initially with the Dr. Kleiner's skin) need to find a prop in a map and press 'E' to disguise as a prop. The Hunters need to fund props, and kill them. If a hunter shoot at the enemy team, he will gain life, else it will lost life. 

## Credits

Credit goes for the original authors of both gamemodes and who made Prop Hunt compatible with GMOD 13. 
Originally written and released by Darkimmortal (TF2), ported by Andrew Theis, ported by Kow@lski, edited and partially improved by Icedream.

Thanks to these guys who put their sound work under Creative Commons, too!

- `sound/weapons/disguiser/pop*.mp3`: cfork from freesound.org - http://www.freesound.org/people/cfork/
- `sound/weapons/disguiser/shot1.mp3`: ejfortin from freesound.org - http://freesound.org/people/ejfortin/sounds/49678/

Dudes, freesound is a really nice source of sounds.

## License

This work is licensed under the [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported license](http://creativecommons.org/licenses/by-nc-sa/3.0/), the same license as the original.

## Dependencies

This mod requires this to be installed _on both, server and client_:

- Garry's Mod 13 (of course) from Facepunch/Steam
- Counter-Strike:Source(tm) from Valve/Steam
- BF 3 SWEPs (for some reason download is only poorly implemented) from http://steamcommunity.com/sharedfiles/filedetails/?id=144579879
	- I rather encourage you to edit the server files so they add download possibilities.

_Important!_ Read the description of these dependencies so everything will be properly installed.

_Important!_ Also change the player class files as they contain weapons from other addons. You might not want to use them. In the near future those will be configuration variables (see sh_config.lua).

_Important!_ The initial configuration does not have working sounds, they are not delivered with this repository. You might want to change this manually.

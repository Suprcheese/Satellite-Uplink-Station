Satellite Uplink Station 1.0.2
==============================

Version 1.0.2 was released September 21, 2016, was tested using Factorio v0.14.8, and was authored by Supercheese.

This mod features Satellite Uplink Stations: Build and enter an uplink station like any other vehicle (enter key by default), and you'll gain the ability to remotely view any area as an "eye in the sky" thanks to your spy satellite(s) in orbit.
You can move the view around using the same movement keys (WASD by default), and when you're finished, click the "Terminate Uplink" button at top to return to controlling your player-character dude.
Although you cannot craft or remove/drop items while uplinked, nor interact with assembly machines etc., you can still use your blueprints, deconstruction planner, explore any territory, and manage trains.

This mod is also intended as a supplement to the Orbital Ion Cannon mod: While using the Uplink Station, you can remotely target your orbital ion cannon(s) without having to be anywhere near the blast zone!
This should hopefully greatly curtail the number of accidental friendly fire incidents.

In order to unlock the Satellite Uplinking research, you must have at least one satellite (vanilla satellite, not ion cannon) in orbit; this effectively gives you something extra to do after you've "beaten the game".
Since it is an endgame technology, it is pretty expensive.
The uplink station is constructed with a fully independent power supply and can be used anywhere; it does not need to be connected to your power grid.

Further functionality is available if you have any of the following mods:

-Upgrade Planner
-YARM

Should these mods be detected, you can also remotely use their items via the uplink station.

Additionally, this mod is aware of Bob's mods and will update its recipes and technology if Bob's Electronics and/or Tech mods are installed.


Known Issues:
-------------

You're supposed to only have an observer's view while uplinked and have a limited potential for interactions.
However, you can still use the logistics system while uplinked to request items that will go to your quickbar -- but if you do, the items will be immediately deleted when the bots deliver them to you.
Really, you should just refrain from using the logistic system while uplinked and only use the items that are given to you by default.

Because the Uplink Station is coded as a "car"-type entity, it cannot be built or deconstructed by robots, nor included in blueprints; it must be placed and picked up by hand.

This mod has been tested with The Fat Controller, and you should be able to use its remote-train-control feature while uplinked -- although you can achieve essentially the same results simply by flying over the train while uplinked.
This mod has been tested with YARM, but you cannot use YARM's remote viewing feature while uplinked.


Credits:
--------

The graphics for the Uplink Station were rendered from this model provided by NASA: http://nasa3d.arc.nasa.gov/detail/jpl-vtad-dsn70
The webpage at http://nasa3d.arc.nasa.gov/ states that, "All of these resources are free to download and use."

The background of the technology icon was edited from: http://opengameart.org/content/red-planet-2
This art resource is used under the terms of the CC-BY-SA license.

The sound effects are from the video game "Command & Conquer: Red Alert" by Westwood Studios.
This video game was released as freeware in 2008.

This mod makes use of the Factorio Standard Library by Afforess (https://github.com/Afforess/Factorio-Stdlib).

Portions of the control.lua code (et al.) were inspired by code from the following mods:

	-ExoMan by sebgggg
	-YARM by Narc
	-The Fat Controller by Choumiko

My thanks to these talented modders for their great mods.

Thanks to the forum and #factorio IRC denizens for advice & bugtesting.


See also the associated forum thread to give feedback, view screenshots, etc.:

http://www.factorioforums.com/forum/viewtopic.php?f=97&t=19883

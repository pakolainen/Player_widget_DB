---------------------------------------------------------------------------------------------------
--  Bugs ---
---------------------------------------------------------------------------------------------------
-- * With option "remove dead team" some things are not rendered graphically.


---------------------------------------------------------------------------------------------------
--  Todo ---
---------------------------------------------------------------------------------------------------
-- * Write manual :)
-- * More ascii art
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

----------------
--  Changelog---
----------------


-------------------------
-- Newest version is 1.31
-------------------------
-- * Compatible with spring 85.0
-- * fixed bug with incorrect expand button location

-- New in 1.3
-------------
--  * Added possibility to move the statistics table. To move it, click on the move button at top left and drag the window where you want it.
--  * Added option tomove to next and previous team from within the statistics table. Use the arrows beside team number to do that.
--  * Fixed some bugs that appear when widget is on the left side of the screen.
--  * The statistics window is now closed by right-clicking on it (or pressing the close/collapse button on the widget).


-- New in 1.2
----------------
--  * Ctrl+click on arm/core image to zoom in on player's commander (if alive)
--  * Fixed sorting of kill distribution graph
--  * Fixed some bugs relating to more start positions than players in game
--  * Fixed speeded up blink rate when increasing game speed.


-- New in 1.1.1
---------------
-- Fixed load/save bug
-- Player kill distribution graph added.


-- New in 1.1
------------------------
-- * Added many options to tweak screen, press ctrl+F11 to customise widget
-- * Saves settings now
-- * Click on arm/core image to go to player start position
-- * Changed kills/losses bar to display killed hp/lost hp instead of kills/losses
-- * Added active player mode, can be disabled/customised in options
-- * Made calls more efficient by moving stuff out of drawscreen function
---------------------------------------------------------------------------------------------------

	name = "Ecostats",
	desc = "Display team eco",
	author = "Jools",
	date = "8 jan 2012",
	license = "GNU GPL, v2 or later",
	layer = 99,
	enabled = true



Installation:

* Unzip widget to <Springdir>/LuaUI/Widgets
* Unzip sounds to <Springdir>/LuaUI/Sounds
* Unzip fonts to <Springdir>/LuaUI/Fonts
* Unzip images to <Springdir>/LuaUI/Images/ecostats

Feedback welcome to springjools at gmail.com

Jools
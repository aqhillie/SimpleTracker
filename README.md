# SimpleTracker

Simple Tracker is a simple item tracker for Super Metroid Map Rando.

It is based on an unknown pack for EmoTracker that a lot of SM speed runners and rando players use.

I couldn't find it anywhere so I pieced it together from screenshots and other random trackers I found in various places.

Update: I was finally able to find the pack. It was written by **chicdead26** and I have since implemented all the features (I believe) of the pack.

## Features

Currently you can cycle through Objectives, Difficulty, Item Progression, Quality of Life, Map Layout, Doors and Start Location seed options to match the current seed you're playing. There is a broadcast mode which will autoscroll through the settings and prevent accidental changes of the settings.

For non-boss objective modes you will see Phantoon appear in the items grid. This can be toggled on and off via View menu as well as a button which is on the titlebar.

Speaking of the titlebar, the titlebar has icons with the ability to turn broadcast mode on and off, reset the tracker, start/stop/reset the timer, turn on/off planet awake status, turn on/off optional phantoon as said before, and toggle through collectible wall jump icons.

When you set the wall jump to collectible in the seed settings, this button will be enabled. This lets you toggle between showing nothing, an icon of wall jump boots, an icon showing whether or not Samus can wall jump, or both. The icons are linked together so tapping one will toggle both of them. 

The last icon turns the network on and off. The network will show a green icon when the apps are connected.

Press Command-R to reset the tracker (reset all bosses to alive - all items to not found/0)

I also have added an optional timer so that if anyone can have a timer ready to go baked into the tracker, in case they don't have a normal timer or don't want to set one up in OBS.

Eventually I would like to learn the features of Emo Tracker and possibly implement them, not necessarily in this project but in a future project.

I think it's best this tracker remain simple, thus the name SimpleTracker :)

## iOS Version

When compiled for iOS SimpleTracker offers a robust network connection to its macOS counterpart that allows you to remote control the tracker from the iPHone. This allows you to easily update the tracker without reaching for your computer.

The desktop app is fully controllable from iPhone, including starting, stopping and resetting the timer.

All the icons that are available on the titlebar of the desktop app show up to the right of seed settings on the iPhone app in portrait mode, and above them in landscape mode.

Unlike the dekstop app, the timer button is unavailable in local mode (networking turned off) since there is no actual timer on the iPhone app. There's simply no room for it on the UI, and it's mostly just for recording or streaming from OBS anyway.

## JSON Seeds

SimpleTracker has the infrastructure for multiple seed support. Right now there's only one seed that is the main one that gets stored, but in the future you will be able to save and load and keep track of multiple different seeds.

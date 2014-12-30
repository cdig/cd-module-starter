## On the bottom, we got 'um

As we begin developing heavily for the web, we will also begin forming scar tissue around the pain points of web tech, in the form of little systems or helpers or wrappers. These band-aid solutions need a home, where they can be nurtured and may grow into a hodge-podge framework of best-practices and common-practices and if-we-keep-practicing-we'll-get-it-eventually's. It's probably also a good idea that this boarding house of orphaned glue code gets included in everything we make, for the sake of the mission.

This repo exists to fill these shoes, mismatched and ill-fitting as they may be.

*It occurs to me that these should each be their own repo, and cd-framework should just express a bower dependency on them and provide manifests that reach up and grab the main files for each system? We should look at how angularfire does it (eg: it depends on angular and firebase.. but.. how?? Do you have to explicitly add Firebase to your HTML, too??)*

## What have I gotten myself into?

**Take & Make** are a nice dependency resolution / service discovery system. It ensures that services exist before dependent code executes.

**Editor** gives us drag-and-drop positioning of elements using `left` and `margin-top`.


### Take & Make

*Just the right amount of dependency resolution service.™*

Somewhere in the dense thicket between module systems, dependency trees and injectors and resolvers, service discovery (whatever the heck that is), and grossly abusing events for load-time notification, you'll find this duo of tools. They're wonderful, with only the slightest whiff of glue.

`Make(name:String[, value:*])` registers a named value, *obviously*. The value can be of any type, and is optional. If you don't give a value, you're registering *the fact that something happened*. You may only register a name once — duplicates will error.

`Take(names:Array, callback:Function)` requests the values that were (or will be) registered with Make, and calls your function with those values, in order, once they're all registered. Pro tip: if there's only one name, you can just pass a string instead of an array. Oh, and if the name you're requesting didn't come with a value (because values are optional when calling Make, remember), then the value will just be the same as the name.

Here's an example:

```coffee
Take ["MusicLibrary", "AudioEngine"], (MusicLibrary, AudioEngine)->
	# Private state
	currentSong = 0
	
	# Private functions
	playSong = (skip)->
		currentSong += skip
		song = MusicLibrary.getSong(currentSong)
		AudioEngine.playSong(song)
	
	# Public API
	Make "MusicPlayer",
		next: ()-> playSong(+1)
		prev: ()-> playSong(-1)
```

Now, don't you dare create any circular dependencies. I haven't read those papers, so sod off.

Lastly, out-of-the-box, we listen for a bunch of standard events, and call Make() when they fire.
That way, you can use Take() to wait for common events like the page being loaded, or the very
first mouse click (possibly useful for WebAudioAPI, or debugging). The current events we wrap are `beforeunload`, `click`, `load`, `unload`.


### Editor

Description forthcoming. Of course, given how these things tend to go, a description may not arrive before the gambit has elapsed and we're firmly into "throw everything away and start over" territory, rendering this all moot. Whether you pray it to happen, or not to happen, is a choice you must make for yourself.

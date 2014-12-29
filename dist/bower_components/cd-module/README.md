# cdModule

## HOW TO UPDATE TO VERSION 1.0

1. Open Terminal.
2. cd to the module folder.
3. Run `bower update`.
4. Refresh CodeKit.
5. Re-compile styles.scss. Fix any errors.
6. Re-compile scripts.coffee and index.kit. Fix any errors.
7. Open libs.js, delete everything, and add the following two lines:

```
// Bower Libs
// @codekit-append '../bower_components/cd-module/dist/libs.js'
```

8. Find all instances of _global and replace with _project (use command-shift-f to do a project-wide find and replace)

## Documentation

### Z-indexes
10: call-out[open] (Call Outs)
1000: cd-modal (Modal Popup)
1001:	page-switcher (Switcher Container)
1002: cd-hud (HUD)
2000: score-area (Score Animation)
9999: .browser-support (Browser Support)
10000: editor-container textarea (Editor)

## Motivation

A standard library for CDIG modules.

In the olden days, we used Dropbox to store and sync our standard library code. It was nice because I could write some code on my computer, and save the changes, and all other computers would automatically receive the updated code. But this was fragile. If I wanted to experimentally make some changes without shipping them out to the company at large, I'd need to make sure to work on a copy of the code, not the main files in Dropbox. And if I introduced a bug, everyone caught it. And if the changes I made broke existing projects, I had no way of knowing other than to wait until someone noticed. There was no opt-in/opt-out of changes.

So, now we have git and github. It's the new Dropbox "source" folder.

This project contains a whole bunch of common HTML, CSS, and JS files (well, Kit, SCSS, and Coffee files). You can use any or all of them in your modules. If I change these libraries, you can update your project with a simple `bower update`. But you don't have to. It's opt-in. And I get to work on changes safely, and only push them live once they're ready.

So, here's hoping this works as well as could be expected.

### Wait wait wait.. so what does this repo actually contain?

Common stuff to be used in all modules. Anything that is specific to a particular project or client is not to be included here. So.. we're punting on that stuff.

Now, there's a lot of common styles. So, in a sense, this is like an anti-reset. It's an opinionated set of default styles and behaviours that should help standardize our modules. It's not a framework, per se. You don't use this to design your own modules. This should force your modules to look and act a certain way.

## Dependencies
Assumes that cdReset is also included. Includes modernizr and jquery. Requires an _project folder.

## License
Copyright (c) 2014 CD Industrial Group Inc., released under MIT license.

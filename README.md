# cdModule Template

## Updating to the latest version

1. Open Terminal.
2. cd to the module folder.
3. Run `bower update`.
4. Refresh CodeKit.
5. Re-compile styles.scss. Fix any errors.
6. Re-compile scripts.coffee and index.kit. Fix any errors.
7. Find all instances of _global and replace with _project (use command-shift-f to do a project-wide find and replace)
8. Update index.kit, libs.js, scripts.coffee, and styles.scss to conform to the pattern laid out in the template.

## What's in the box?

This repo contains two modules:

* `dist` is a bare-bones skeleton of a module, ready for you to flesh out with content.
* `example` is fleshed out and dressed up, to serve as an example of all the available features and how they should be used.

## License
Copyright (c) 2014 CD Industrial Group Inc.

# cd-module-starter v2

What's in the box? This repo contains a bare-bones skeleton of a module, ready for you to flesh out with content. Go here for directions: https://github.com/cdig/lunchboxsessions/wiki/How-To-Make-a-Module

## For System Developers
Make a folder named `dev` in the root of the module. Clone the repo of a lib or app into that folder. Run `gulp` as normal for the module, and in a separate terminal tab, run the compilation pipeline for your lib/app. When the cd-module gulp process detects changes to files in `dev/*/dist/`, it'll copy `dev/*/dist` to `bower_components/*/dist`, and copy `dev/*/bower.json` to `bower_components/*/bower.json`, and then recompile the module accordingly.

## License
Copyright (c) 2014-2015 CD Industrial Group Inc. http://www.cdiginc.com

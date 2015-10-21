# cd-module-starter

What's in the box? This repo contains a bare-bones skeleton of a module, ready for you to flesh out with content.

## Getting Started
Click [Download Zip](https://github.com/cdig/cd-module-starter/archive/v2.zip), take the `dist` folder, name it whatever your module name is, and put it somewhere else. Delete the `cd-module-starter-2` folder.

`cd` into your new module folder, and then run the following:

```bash
npm update --save
bower update
```


## Getting Down To Work
After you have a module set up and ready to be worked on, here's how you fire it up.

`cd` into the module folder, and then run the following:

```bash
gulp
```

That'll compile all your files, and open up a browser window with a running instance of browser-sync. Any changes you make to the files in `source` will be immediately compiled, and the browser will be updated accordingly.


## For System Developers
Make a folder named `dev` in the root of the module. Clone the repo of a lib or app into that folder. Run `gulp` as normal for the module, and in a separate terminal tab, run the compilation pipeline for your lib/app. When the cd-module gulp process detects changes to files in `dev/*/dist/`, it'll copy `dev/*/dist` to `bower_components/*/dist`, and copy `dev/*/bower.json` to `bower_components/*/bower.json`, and then recompile the module accordingly.

## License
Copyright (c) 2014-2015 CD Industrial Group Inc. http://www.cdiginc.com

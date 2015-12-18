# cd-module-starter v2

What's in the box? This repo contains a bare-bones skeleton of a module, ready for you to flesh out with content.

## Getting Started
1. Click [Download Zip](https://github.com/cdig/cd-module-starter/archive/v2.zip). Unzip.
2. Take the `dist` folder, name it whatever your module name is. This folder is now your "module project folder". Put it wherever you keep your working files (or [in Dropbox](https://github.com/cdig/cd-module/blob/v2/README.md#project-folders) if you just work out of there).
3. Delete the `cd-module-starter-2` folder.
4. `cd` into your new module project folder. Triple-click the following line to select it all. Copy, and then paste it into the terminal.

  ```bash
  curl https://lunchboxsessions.s3.amazonaws.com/static/cd-module/node_modules.zip > node_modules.zip && unzip -nq node_modules.zip && rm   node_modules.zip && npm update && bower update && clear && echo "Success"
  ```

5. Stuff will start running. After about 30 seconds, the setup process will finish.
  - If it is successful, your terminal will be empty, save for the word "Success".
  - If it failed, the terminal will be full of info. Grab a copy of all the text in your terminal, and paste it into #bikeshed as an attachment. You're welcome to kick things around and see if you can get it to work, but you may need some Ivan-help (patent pending) before you can continue drilling profitably.

## Getting Down To Work
After you have a module set up and ready to be worked on, here's how you fire it up.

`cd` into the module folder, and then run `gulp`.

That'll compile all your files, and open up a browser window with a running instance of browser-sync. Any changes you make to the files in `source` will be immediately compiled, and the browser will be updated accordingly.


## For System Developers
Make a folder named `dev` in the root of the module. Clone the repo of a lib or app into that folder. Run `gulp` as normal for the module, and in a separate terminal tab, run the compilation pipeline for your lib/app. When the cd-module gulp process detects changes to files in `dev/*/dist/`, it'll copy `dev/*/dist` to `bower_components/*/dist`, and copy `dev/*/bower.json` to `bower_components/*/bower.json`, and then recompile the module accordingly.

## License
Copyright (c) 2014-2015 CD Industrial Group Inc. http://www.cdiginc.com

# cdModule Template

## Updating to the latest version

1. Open Terminal.
2. cd to the module folder.
3. Run `bower update`.
4. Refresh CodeKit.
5. Re-compile styles.scss. Fix any errors.
6. Re-compile scripts.coffee and index.kit. Fix any errors.
7. Open libs.js, delete everything, and add the following two lines:

		```
		// 1. Bower
		// @codekit-append '../bower_components/cd-module/dist/libs.js'

		// 2. Module
		// None yet
		```

8. Find all instances of _global and replace with _project (use command-shift-f to do a project-wide find and replace)

## There Will Be Bugs
This is still an alpha! The format for modules is rapidly evolving, and as such, this template project might lag a bit behind the current state of the art. I will try really hard to keep it updated. But if something seems fishy, it probably is.

### Dependencies
Includes cdReset, cdModule in `bower_components`. So, you need Bower? Also, includes a ready-to-use `config.codekit`. So you should use CodeKit.

## License
Copyright (c) 2014 CD Industrial Group Inc.

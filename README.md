## Updating an existing module to the latest version

1. Open Terminal.
2. cd to the module folder.
3. Run `bower update`.
4. Refresh CodeKit.
5. Recompile index.kit, libs.js, scripts.coffee, and styles.scss

## Setting up the _project folder

Each module has a '_project' folder that is specific to where it is being distributed, like, for example, the Acid-Unit or for Lunch Box Sessions. In order to change this in `bower.json` you need to set which github location to use for `_project`
```json
{
  "name": "cdig-module",
  "description": "A CDIG Module",
  "dependencies": {
    "cd-module": "cdig/cd-module",
    "_project": "cdig/project-you-wish-to-use"
  },
  "private": true
}
```
For example, the default project is `"_project": "cdig/lbs-project"`
## What's in the box?

This repo contains a bare-bones skeleton of a module, ready for you to flesh out with content.

It used to also contain an "example" project, but that was languishing, so it was removed to avoid
spreading misinformation.

## License
Copyright (c) 2014-2015 CD Industrial Group Inc., released under MIT license.

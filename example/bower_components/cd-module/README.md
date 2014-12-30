# cdModule

A solid foundation for CDIG modules.


#### What's included?
cdModule gives you a carefully chosen set of styles, scripts, and HTML components, to make all our modules look and act consistently.


#### What's not included?
Anything specific to an individual project or client belongs in an _project, to be shared by all modules in the project.


#### How do I use it?
Consult the [module template](https://github.com/cdig/cd-module-template) and seek the wisdom of its way.


## Included Features


### Libs

**[modernizr](https://modernizr.com)** works with browser-support to warn users when they're using an unsupported browser.

**[jQuery](https://jquery.com)** is used by the matching game. We're gonna remove this PDQ.

Note: At some point in the future, we need to figure out how to (automatically?) use CDN-hosted libs in production, for the sake of caching.


### Components

**browser-support**
TODO: Add description.


**call-outs**
TODO: Add description.


**hud**
TODO: Add description.


**modal-popup**
TODO: Add description.


**page-locking**
TODO: Add description.


**page-switcher**
TODO: Add description.


**score-animation**
TODO: Add description.


**scroll-hint**
TODO: Add description.



### Scripts

**Backend: LocalStorage**
TODO: Add description.

**Backend: SCORM 2004**
TODO: Add description.

**Easing**
TODO: Add description.

**Flash Interface**
TODO: Add description.

**KV Store**
TODO: Add description.

**Matches Selector**
TODO: Add description.

**Page Audio**
TODO: Add description.

**Page Manager**
TODO: Add description.

**Page Scroll Watcher**
TODO: Add description.

**Page Title**
TODO: Add description.

**Pages**
TODO: Add description.

**Params Service**
TODO: Add description.

**Save Before Unload**
TODO: Add description.

**Save With Popup**
TODO: Add description.

**Scoring**
TODO: Add description.

**Scroll Regions**
TODO: Add description.

**Scroll To**
TODO: Add description.

**Welcome Popup**
TODO: Add description.


### Styles: Custom
TODO: These are an awful lot like components... but they're different from the (above/real) components. They're to be used in the content; they're not part of the foundational system. We may have a crisis of naming here.

**cd-flow-arrow**
**cd-map**
**cd-page**
**cd-row**
**cd-text-bubble**


### Styles: Elements
**body**
**figure**
**headings**
**img**
**lists**
**main**
**object**
**p**


### Styles: Mixins
**magic-underlines**


## Documentation of Decisions

### Z-indexes

* 10: `call-out[open]` (Call Outs)
* 1000: `cd-modal` (Modal Popup)
* 1001:	`page-switcher` (Switcher Container)
* 1002: `cd-hud` (HUD)
* 2000: `score-area` (Score Animation)
* 9999: `.browser-support` (Browser Support)
* 10000: `editor-container` textarea (Editor)


## License
Copyright (c) 2014 CD Industrial Group Inc., released under MIT license.

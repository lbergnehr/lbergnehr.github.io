---
layout: post
title: "Change vim search highlight appearance"
date: 2013-08-06 21:56
categories: [vim, tech, english]
---

So I wanted to change my search highlighting in vim. Didn't find too much info online, so I went through the, in this case helpful, vim documentation. I might add that I'm using the beautiful [Solarized] [1] theme, where its default search highlighting has a bit too much contrast for my taste. If you're using a different theme, this might not be any issue at all.

<!-- more -->

The golden command?

    :hi Search cterm=underline

Let's break this down a bit:

### hi
Check out `:help :hi` to get some comprehensive info on how the highlighting can be configured. You can see all—there are quite a few—of your highlighting settings by just issuing `:hi`.

### Search
The *Search* part is a group which filters down the list you get back to just show the currently set highlighting for when searching—what I'm interested in here. It makes it possible to change the settings for that particular group.

### cterm=underline
The last part is a key, `cterm`, followed by one or more attributes. In my case, I'm running vim in a color terminal, so `cterm` will do fine. If you're running in a more old-school terminal, `term` is likely what you want. If you're using gVim or MacVim, you might use `gui` as the key instead. The attribute I would like to set is `underline`, but you can provide more as a comma separated list (excluding spaces).

## Persist it
In order to make the command persist when restarting you will, of course, put it in your *.vimrc*. Nothing strange here, but you might want to think about putting the line, in my case `hi Search cterm=underline`, after any syntax definitions or configurations, which will likely also include these kind of settings, in order to prevent your new settings from being overwritten.

[1]: http://ethanschoonover.com/solarized

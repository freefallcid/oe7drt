+++
title = "Optimizing PNG Images"
summary = "A quick notice about three very handy tools to optimize PNG images on the command line. They work on linux and macOS."
date = 2020-01-20T20:34:20+01:00
tags = ["notes"]

+++

I found these commands here coincidentally on a
[pull request](https://github.com/xianmin/hugo-theme-jane/pull/266) at Github.
I found them quite handy ;-)

```
find . -type f -name "*.png"  -print0 | xargs -0 -I {} optipng -nb -nc "{}"
find . -type f -name "*.png"  -print0 | xargs -0 -I {} advpng -z4 "{}"
find . -type f -name "*.png"  -print0 | xargs -0 -I {} pngcrush -rem gAMA -rem alla -rem cHRM -rem iCCP -rem sRGB -rem time -ow "{}"
```

You may need to install these tools first.

On debian or ubuntu

```
sudo apt-get install optipng pngcrush advancecomp
```

On macOS

```
sudo port install optipng pngcrush advancecomp
```

You may know other package managers commands, but I only use those two at the
moment.

#!/usr/bin/env sh
rm -rf public
hugo -v --gc --minify
npm run algolia

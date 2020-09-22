#!/bin/bash
wget https://unpkg.com/wasm-git@latest/lg2.js
wget https://unpkg.com/wasm-git@latest/lg2.wasm
wget https://raw.githubusercontent.com/petersalomonsen/wasm-git/master/examples/webserverwithgithubproxy.js
mv lg2.js ./libgit2-wasm/lg2.js
mv lg2.wasm ./libgit2-wasm/lg2.wasm
mv webserverwithgithubproxy.js ./libgit2-wasm/webserverwithgithubproxy.js
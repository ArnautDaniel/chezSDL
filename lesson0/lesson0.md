lesson0-

To begin with all we need is to setup our development enviroment.

We will be using Chez Scheme as our implementation, which is a very fast (possibly the fastest) scheme compiler that is based on the R6RS standard.

These tutorials will aim to be as terse as possible in an effort to help you develop the skills to read the reference manual yourself and figure things out.

The first step is installing Chez Scheme which can be found at:
https://github.com/cisco/ChezScheme

The installation basically boils down to cloning the repo,
and using configure and make to install.  After this you'll need to download thunderchez at:

https://github.com/ovenpasta/thunderchez/

Clone this to your home directory or any easily accessible location.

This is where we get our SDL bindings from.

The next lesson we'll start by getting a window up and trying to put some squares on it.  But before you do that, here are a few tips for development enviroment.

If you're on Linux, one of the best setups is emacs + geiser.

Geiser can be found at:
https://github.com/jaor/geiser

This tutorial will be using a geiser setup, but the code will work for anything.


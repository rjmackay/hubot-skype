# Hubot Skype (Skypekit) Adapter

## Description

This is the [Skype](http://skype.com) adapter for hubot that allows you 
to communicate with hubot through Skype.

## Installation

1. Acquire the SkypeKit SDK (as of this writing, the current version of the SDK is 4.2)
2. Acquire the Skype Runtime application (also from the Skype Developer site)
3. Acquire a keypair from Skype for development (also from the Skype Developer site)
4. SkypeKit SDK 
    * Compiling requires CMake. If you are on OS X, you can use [Homebrew](http://mxcl.github.com/homebrew/) to install it.
    * Run `BuildWithCmake.sh` in `$SDK_DIR/interfaces/skype/cpp_embedded`
    * Consult the [Skype SDK documentation](http://developer.skype.com/) for further details if you are having issues.
5. Add `hubot-skypekit` as a dependency in your hubot's `package.json`
6. Install dependencies with `npm install`
7. Configuration
    * Update `src/keypair.py` with the correct paths
    * Setting up Skype username and password (this step will be improved in the future)
        * In the `src/skype.py` file, find this line: `$skype.login(skype_username, skype_password)`
        * Set the `skype_username` variable to the desired value
        * Set the `skype_password` variable to the desired value
8. Run hubot with `bin/hubot -a skypekit`

## Usage

The Skype adapter works by communicating through a locally running skype
client. You need to create a Skype account for your bot, and log into it
on a Skype client running on the same machine as hubot. When you first
launch hubot with the Skype adapter, Skype will prompt you to allow for
API permission. You must allow this before the bot will work.

## Contribute

Here's the most direct way to get your work merged into the project.

1. Fork the project
2. Clone down your fork
3. Create a feature branch
4. Hack away and add tests, not necessarily in that order
5. Make sure everything still passes by running tests
6. If necessary, rebase your commits into logical chunks without errors
7. Push the branch up to your fork
8. Send a pull request for your branch

## Copyright

Copyright &copy; Dominick D'Aniello. See LICENSE for details.

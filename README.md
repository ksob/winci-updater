winci-updater
======

[WinCI-updater] File updater capable of downloading files over Git (supports SSH).
	
Introduction
=======

WinCI-updater is ingredient of WinCI project.
The purpose of WinCI project is to simplify implementation of the full continuous deployment pipeline the Agile way with Jenkins/Hudson continuous integration server under Windows.

It introduces Agile technologies into provisioning process by keeping it integrated with Continuous Integration Server. To do so it incorporates Git DVCS into the process.

WinCI-updater is written in Ruby and uses 'ruby-git' project to automate interaction with Git executable.

WinCI-updater is intended to be used in conjunction with WinCI-server, which is another gem containing functionality necessary 
to setup Jenkins CI and enabling to create installation bundle used in provisioning process.

Why This Project
=======

I needed an automatic update process that would keep changes made by end-users on client and at the same time would keep everything up to date with the Continuous Integration Server, 
even if the updates would come so frequent as a few times a day as in Agile development. Using standard update process where a whole application is being downloaded 
from the server, extracted locally and replaced with the old one, each time a new update appear, seem to be inappropriate for corporate environments because:

  * application bundle often weights more than a few megabytes, but corporate computers have usually limited internet connection and so downloading this bundle a few times a day from the server located outside LAN is not efficient
  * extracted app bundle's size can exceed a few hundred of megabytes and so moving/deleting this whole bunch a few times a day only to get small update, slows down corporate computers and also defragments the disks to slow it even more

The solution is to incorporate into provisioning a VCS or DVCS such like Git and this project is realization of this solution.

Compatibility
=============

Successfully tested on the following mingw versions from RubyInstaller.org :

	ruby 1.8.7 (2011-02-18 patchlevel 334) [i386-mingw32]
	
Install
=======

    gem install winci-updater
	
Usage
=====

	require "rubygems"
	require "bundler/setup"

	require "winci-updater"

	@git = WinCI::Updater::Git.new "_config.yaml"
	@git.setup_ssh_key "key"

	@updater_res = @git.provide File.expand_path('..'), 'files', true

Also take a look at test suite (Cucumber stories and RSpec examples in features and spec directories) for examples of usage.

For real world example look at its usage in WinCI-server ( WinCI-server/fixtures/updater ).

Developer Instructions
======================

The dependencies for the gem and for developing the gem are managed by Bundler.

    gem install bundler
    git clone http://github.com/ksob/winci-updater.git
    cd ./winci-updater
	bundle install

The test suite is run with:

    bundle exec rake

TODO list
=========

* Integrate with Gerrit Jenkins plugin
* Integrate with build-publisher Jenkins plugin
* Incorporate Grit gem for possible enhancements

License
=======

(The MIT License)

Copyright (c) 2011 Kamil Sobieraj, ksobej@gmail.com

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
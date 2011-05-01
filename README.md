winci-updater
======

[WinCI-updater] File updater capable of downloading files over Git (supports SSH).

Install
=======

    gem install winci-updater
	
Introduction
=======

WinCI-updater is ingredient of WinCI project.
The purpose of WinCI project is to simplify implementation of the full continuous deployment pipeline the Agile way with Jenkins/Hudson continuous integration server under Windows.

It introduces Agile technologies into provisioning process by keeping it integrated with Continuous Integration Server. To do so it incorporates Git DVCS into the process.

WinCI-updater is written in Ruby and uses 'ruby-git' project to automate interaction with Git executable.

WinCI-updater is intended to be be used in conjunction with WinCI-server, which is another gem containing functionality necessary 
to setup Jenkins CI and enabling to create installation bundle used in provisioning process.

Why This Project
=======

I needed an automatic update process that would keep changes made by end-users on client and at the same time would keep everything up to date with the Continuous Integration Server, 
even if the updates would come so frequent as a few times a day as in Agile developement. Using standard update process where a whole application is beeing downloaded 
from the server, extracted locally and replaced with the old one, each time a new update appear, seem to be inaproppriate for corporate environments because:

  * application bundle ofen weights more than a few megabytes, but corporate computers have usually limited internet connection and so downloading this bundle a few times a day from the server located outside LAN is not efficient
  * extracted app bundle can weight a few hundred of megabytes and so moving/deleting this whole bunch a few times a day only to get small update, slows down corporate computers and also defragments the disks to slow it even more

The solution is to incorporate into provisioning a VCS or DVCS such like Git and this project is realization of this solution.

Usage
=====

First download and run WinCI-server.
Then take a look at test suite (Cucumber stories and RSpec examples in features and spec directories) for examples of usage.

Developer Instructions
======================

The dependencies for the gem and for developing the gem are managed by Bundler.

    gem install bundler
    git clone http://github.com/ksob/winci-updater.git
    bundle install

The test suite is run with:

    bundle exec rake

TODO list
=========

* Integration with Gerrit Jenkins plugin
* Integration with build-publisher Jenkins plugin
* Incorporating Grit gem for possible enhancements

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
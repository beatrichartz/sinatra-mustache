sinatra-mustache
================

To simplify setting up [Sinatra][1] to use [Mustache][2] for it's templates

[Sinatra][1] is a pretty amazing little web framework, if you don't know much
about it you should take some time to [get to know it][4].

[Mustache][2] is also another favorite of mine; a really great and simple
templating system. I have been slowly converting all my old views in various
projects over to it.

Why?
====

There is already an [official][3] way to get Mustache to work with Sinatra, which
involves some work and requires separate view classes to accompany your
mustache templates. While I see the power in that it seems a bit complex..

Usage
=====

Try this on:

    require 'sinatra/mustache'

    class App < Sinatra::Base
      set :views, 'templates' # totally optional
    end

And then put your .mustache files in your app's views folder

Instance variables and locals are available to the template as well as yaml
front matter.

Caveat
======

If you need the extra support of the ruby views used in the official Mustache
for Sinatra example this gem probably isn't for you.

[1]: http://www.sinatrarb.com/
[2]: http://mustache.github.com/
[3]: https://github.com/defunkt/mustache-sinatra-example
[4]: http://sinatra-book.gittr.com/

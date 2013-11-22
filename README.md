sinatra-mustache [![Build Status](https://travis-ci.org/beatrichartz/sinatra-mustache.png?branch=master)](https://travis-ci.org/beatrichartz/sinatra-mustache) [![Code Climate](https://codeclimate.com/github/beatrichartz/sinatra-mustache.png)](https://codeclimate.com/github/beatrichartz/sinatra-mustache) [![Dependency Status](https://gemnasium.com/beatrichartz/sinatra-mustache.png)](https://gemnasium.com/beatrichartz/sinatra-mustache)
================

To simplify setting up [Sinatra][1] to use [Mustache][2] for it's templates

[Sinatra][1] is a amazing little web framework, if you don't know much
about it you should take some time to [get to know it][4].

[Mustache][2] is a really great and simple templating system.

Without extra view classes
----

There is already an [official][3] way to get Mustache to work with Sinatra, which involves some work and requires separate view classes to accompany your mustache templates. There's power in that for sure, but for some implementations it is a bit complex.

Usage
----

Try this on:

    require 'sinatra/mustache'

    class App < Sinatra::Base
      set :views, 'templates' # totally optional
    end

And then put your .mustache files in your app's views folder.

Instance variables and locals are available to the template as well as YAML front matter.

Helpers
----

Use the helpers you defined in your app by passing their names to mustache_helper:

    require 'sinatra/mustache'
    
    class App < Sinatra::Base
      register Sinatra::MustacheHelper #makes mustache_helper available
      
      helpers do
        def some_helper *args
          args.join('/')
        end
      end
      
      mustache_helper :some_helper
    end
    
Now you can use some_helper in your mustache template. There is also support for mustache's dot-notation:

    " {{ some_helper.awesome.nice.spectacular }}" #=> "awesome/nice/spectacular"
    
Also, There is support for registering helper modules

    module SomeHelpers
      def hello what
        "Hello #{what}"
      end
    end

    class App < Sinatra::Base
      register Sinatra::MustacheHelper
      helpers SomeHelpers
      mustache_helpers SomeHelpers
    end
    
Now, this is possible:

    " {{ hello.Mars }}" #=> "Hello Mars"
    
Passing arguments to helper methods via dot notation is limited to Strings only.

Caveat
----

If you need the extra support of the ruby views used in the official Mustache for Sinatra example this gem probably isn't for you.

[1]: http://www.sinatrarb.com/
[2]: http://mustache.github.com/
[3]: https://github.com/defunkt/mustache-sinatra-example
[4]: http://sinatra-book.gittr.com/

Contributing to sinatra-mustache
----

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Make sure to add documentation for it. This is important so everyone else can see what your code can do.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
----

Copyright (c) 2013 Beat Richartz. See LICENSE.txt for
further details.

# enchant

## README

As far as today (20120912) enchant project it will be stopped and all the
features will be covered by [links](https://github.com/thesp0nge/links) project
I wrote to automate robots.txt scan.


## Introdution

enchant is is tool aimed to discover web application directory and pages by
fuzzing the requests using a dictionary approach.

The purpose is for security guys to discover a web application exposed paths without knowing anything about
the app they have to test.

## Some disclaimer

enchant makes a lot of HTTP GET requests so it can cause the following to the target server:

* slow down
* denial of services

Please be **ethical** and use this tool only against website you're allowed to stress test.

## Installing enchant

enchant is deployed as standard gem served by [rubygems](http://rubygems.org).

To install latest enchant stable release, just issue this command:

```
gem install enchant
``` 

If you want to install a _pre_ release, such as a _release candidate_ you can do it this way:
```
gem install enchant --pre
```

## Using enchant

You can use enchant to discover web application folders just specifying the URL
and using a default wordlist file stored internally (is the one deployed with
Owasp DirBuster).

``` 
bin/enchant www.some.org
``` 

Or you can also use the wordlist you love most

``` 
bin/enchant -w mylist.txt www.some.org
``` 

## Contributing to enchant
 
* Check out the latest master to make sure the feature hasn't been implemented
  or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it
  and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to
  have your own version, or is otherwise necessary, that is fine, but please
  isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2010-2012 Paolo Perego, <thesp0nge@gmail.com>. See LICENSE for
further details.



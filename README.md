[![Gem Version](https://badge.fury.io/rb/crtu.svg)](https://badge.fury.io/rb/crtu)
[![Build Status](https://travis-ci.org/Th33x1l3/CRTU.svg?branch=master)](https://travis-ci.org/Th33x1l3/CRTU)

CRTU

Cucumber Ruby Test Utilities

Some assorted test utilities for those who do cucumber testing with ruby. 

For now it has:

    Some rake tasks
    Singleton logger utilitie defined with log4r
    
# Usage

## Rake Tasks
To use the rake tasks insert the following lines on your Rakefile:

```
spec = Gem::Specification.find_by_name('crtu')
load "#{spec.gem_dir}/lib/tasks/cucumber_tasks.rake"

```

## Loggers
Add the Utils module to the world, then you can call

if in a class add `include Utils::LocalLogger`
then you can call
```
console_logger.<level> "MESSAGE TO LOG"
file_logger.<level> "MESSAGE TO LOG"
all_logger.<level> "MESSAGE TO LOG"
```

- `console_logger` logs message only to stdout
- `file_logger` logs to a file
- `all_logger` logs to both console and file

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Th33x1l3/crtu. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. 

Aside from that feel free to send pull requests with useful code that you want to share.


# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


Welcome to the repo of see me speak!

# Setup

* Install JRuby 1.7.4 (avoid 1.7.5 for now, torquebox seems to have problems)
* `bundle install`

In a seperate terminal, run:
* `torquebox run`

In your project directory, run once:
* `torquebox deploy`

This survives server restarts.

Find you development logs in log/*.

Autoreloading should work, reconfigurations need a restart which takes a bit longer than normal.

See `torquebox.yml` for specific settings like queues.

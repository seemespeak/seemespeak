Welcome to the repo of see me speak!

# What?

see me speak is an application to easily record and view sign language words.

# Setup

## App

* Install JRuby 1.7.4 (avoid 1.7.5 for now, torquebox seems to have problems)
* `bundle install`

In a seperate terminal, run:
* `torquebox run`

In your project directory, run once:
* `torquebox deploy`

This survives server restarts.

Find you development logs in log/\*.

Autoreloading should work, reconfigurations need a restart which takes a bit longer than normal.

See `torquebox.yml` for specific settings like queues.

Admin credential file:
rename 
*config/admin_settings_example.yml 
to 
*admin_settings.yml

## Seed
get some seed data by running 
* `rake seed:entries`

## elasticsearch

Get and unzip elasticsearch 0.90.5: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.zip

Start:

`bin/elasticsearch -f`

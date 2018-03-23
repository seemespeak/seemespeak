# See Me Speak

[![Build Status](https://travis-ci.org/seemespeak/seemespeak.png?branch=master)](https://travis-ci.org/seemespeak/seemespeak)

[SeeMeSpeak](http://seemespeak.org) is an application to easily record and view sign language words.
This was done as a small prototype for [RailsRumble](http://railsrumble.com). A full live version of this idea can be found under [SignDict.org](https://signdict.org).

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
rename `config/admin_settings_example.yml` to `config/admin_settings.yml`

## Admin section
located under `/reviews`. 

## Seed
get some seed data by running 
* `rake seed:entries`

## elasticsearch

Get and unzip elasticsearch 0.90.5: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.zip

Start:

`bin/elasticsearch -f`

Drop index (all):

`curl -XDELETE 'http://localhost:9200'`

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
rename `config/admin_settings_example.yml` to `config/admin_settings.yml`

## Admin section
located under `/reviews`. 

## Seed
get some seed data by running 
* `rake seed:entries`

Alternatively, use the DGS crawler to import content from
http://dgs.wikisign.org.

```shell
md dgs_import
jrbuy lib/importer/dgs/crawler.rb dgs_import # Crawl the site for meta data, stored in JSON files
jruby lib/importer/dgs/downloader.rb dgs_import # Download video files
jruby lib/dgs_importer.rb # Import(&convert) entries (TorqueBox must be running)

```

## elasticsearch

Get and unzip elasticsearch 0.90.5: https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.zip

Start:

`bin/elasticsearch -f`

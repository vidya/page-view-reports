# page-view-reports

This repository contains an implementation of the specifications laid out
in the 'eng.exercise.2015.md' file.

In implementing the specification, I have used:

  - ruby 2.1.3p242 (2014-09-19 revision 47630) [x86_64-darwin14.0]

  - Rails 4.1.6

Please use 'rake db:reset' to create the data needed to test the
implementation. Be aware that

    rake db:reset      # Drops and recreates the database from db/schema.rb ...

The implementation was tested using the curl commands:

    curl http://localhost:3000/page_views/top_urls
    curl http://localhost:3000/page_views/top_referrers

and by visiting 'http://localhost:3000' after starting the rails app server.

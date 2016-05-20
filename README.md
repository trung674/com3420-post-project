# Village Memories Group
---

### Description
Website for the archiving and management of oral history & files for the South Yorkshire villages of Micklebring, Clifton and Braithwell.

### Significant Features/Technology
The system has the following:

*
* Another one...


### Deployment
Unzip the zip file in the server's public folder (usually it is “public_html”), or if using a remote service, unzip the file on your computer and upload the individual files and folders to the public folder
In config/, copy either database_sample_sqlite.yml (if you’re using a sqlite database) or database_sample_pg.yml (if you’re using a postgres database) and rename it to database.yml
SQLite will be automatically set up for you, but if you wish to use postgres for a more powerful database (important if you think you will have a lot of traffic) you can download it here: http://www.postgresql.org/ and follow their setup guide
If you decide to use a different server you will need to create your own config file

You will need to open this database.yml in a text editor and enter your database configuration information e.g. adapter, database, username, password, host, port, etc.
http://guides.rubyonrails.org/configuring.html#configuring-a-database

If you need to create the application database on another system, you should be using db:schema:load, not running all the migrations from scratch’ - from ActiveRecord

THE FOLLOWING STEPS MAY BE AUTOMATIC DEPENDING ON WHICH SERVICE YOU ARE USING (eg deploying to Heroku will do all of these)

Next, navigate to the root folder using the command line. If you don’t have physical access to the server, or a nice online portal, you will have to SSH onto the server via the command line. This will be the case if you use a server such as those provided by Amazon Web Services.
Help for windows - http://www.digitalcitizen.life/command-prompt-how-use-basic-commands
Help for Apple Mac (go down to ‘Directories’) - http://mally.stanford.edu/~sr/computing/basic-unix.html
Help for Linux -
	http://linuxcommand.org/lc3_lts0020.php
Run the command ‘bundle install’ to install all the necessary gems, this may take a while, and check to see that were no errors during the installation. The copy of Gemfile below shows list of gems which will be installed on your server.
Run the command ‘bundle exec rake db:setup’ to create the database from the schema.
Run the command ‘bundle exec rake db:seed’ to populate the database with all the necessary data
db/seeds.rb contains seed data (editable contents, default administrator account) to be used when the system is set-up for the first time. This data can be changed in the db/seeds.rb file or using any tool for managing the database (e.g. phpMyAdmin).
Run the command ‘bundle exec rails s’ to run the server
You can now visit the website at the public URL you have set up for this server


### Customer Contact
The Village Memories Group email
villagememoriesbcm2015@gmail.com

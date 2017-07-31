# MicroBlog

This is the a microbog application guided by the 4th edition of [*Ruby on Rails Tutorial: Learn Web Development with Rails*](http://www.railstutorial.org/) by [Michael Hartl](http://www.michaelhartl.com/).

## License

All source code  is available jointly under the MIT License and the Beerware License. See [LICENSE.md](LICENSE.md) for details.

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ cd ~/tmp
$ git clone https://github.com/Kur0x/microblog.git microblog
$ cd microblog
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```
##TrobleShooting
1. An error occurred while installing mysql2 (0.4.6), and Bundler cannot continue.
   Make sure that `gem install mysql2 -v '0.4.6'` succeeds before bundling.

   You can run `sudo apt-get install libmysqlclient-dev`

2. An error occurred while installing sqlite3 (1.3.13), and Bundler cannot
   continue.
   Make sure that `gem install sqlite3 -v '1.3.13'` succeeds before bundling.

    You can run `sudo apt-get install libsqlite3-dev`

For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).

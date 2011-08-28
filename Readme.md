# domodoro

Distributed pomodoro architecture running on EventMachine.

_ACHTUNG_: This gem is under active development, **not** released yet!

Domodoro uses a pub/sub approach to send scheduled pomodoro events (such as
'start working' or 'pomodoro break') to a number of subscribers simultaneously.

The subscriber (i.e. the domodoro client) receives those events and triggers
an appropriate alarm/notification (via Growl for example).

The idea behind this is that synchronized pomodoros between coworkers are a
win, but difficult to implement with traditional software, because of the
following reasons:

* Using local pomodoro timers/software makes pomodoro cycles unsynced between
  different coworkers, so that one may have a pomodoro break while others are
  still working and that may put at risk their ability to focus.

* Using a global pomodoro (for example, alarms for the entire office) **does**
  annoy the hell out of whoever does'nt want/can't benefit from pomodoro
  cycles at a particular moment.

* Plus, the "alarms for the entire office" does not work with coworkers that
  may not be in the office (telecommuting workers for example).

Solution: a pub/sub architecture where a centralized publisher (the domodoro
server) broadcasts pomodoro events to whoever wants to subscribe to them, so
whoever wants to stay synced, can, and who doesn't, can stay out of it.

## Install

    $ gem install domodoro

In the server machine:

    $ domodoro serve [port]

Each of the clients that want to connect must do this:

    $ domodoro join [ip of the server machine] [port]

The clients will receive notifications via sound/growl (configurable in a
`~/.domodororc` file).

## Configuration

By default, both sound and visual notifications are displayed on each event.
If you want to configure this, create a file in your home directory named
`.domodororc` with some YAML configuration:

    $ touch ~/.domodororc
    $ echo "visual: true" >> ~/.domodororc
    $ echo "sound: false" >> ~/.domodororc

## Copyright

Copyright (c) 2011 Josep M. Bach. Released under the MIT license.


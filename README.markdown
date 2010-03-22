MongoWatchable
==============

A simple many-to-many assocation between watchers and watchables for mongodb.

Requirements
------------

- MongoDB
- MongoMapper

Installation
------------

    sudo gem install mongo_watchable

Simple Example
--------------

    class User
      include MongoMapper::Document
      include MongoWatchable::Watcher
    end
    
    class Widget
      include MongoMapper::Document
      include MongoWatchable::Watchable
    end
    
To watch it:

    user.watch(widget)

Check if user is watching a widget:

    user.watching?(widget)

Return count of all widgets a user is watching:

    user.widget_watchings.count

Return all widgets a user is watching:

    user.widget_watchings

Return all users watching widget:

    widget.user_watchers

Return count of all users watching widget:

    widget.user_watchers.count

Unwatch a widget

    user.unwatch(widget)

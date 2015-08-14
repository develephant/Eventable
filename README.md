# Eventable

_A series of tubes for Lua tables._

__Eventable__ lightly extends your tables to create a "network" of tables that can listen for, and send events. Works across modules too. It's basically a chat room for your tables and mods.

## Install

Put the `Eventable.lua` somewhere in your project, and require it where ever you need it

```lua
--== main.lua ==--
local Eventable = require('Eventable')
```

## Usage

For a table to be part of the __Eventable__ messaging loop, it must be _evented_ like so:

```lua
local et = require('Eventable')

--== evented table
local tbl = et:new()
```

You now have a table that is also part of the __Eventable__ messaging network.

As long as you don't use any of the __Eventable__ method names (see below), you can pass in any starting data table.

```lua
local starter_tbl = { username = "Fred", age = 55 }
local etbl = Eventable:new( starter_tbl )
```

__Listening for events in the network.__

```lua

--== Listening for 'tweet' event
local etbl = et:new()
etbl:on('tweet', function( evt, message )
  print( 'The '..evt.name..' was '..message )
end)

--== Sending
local starter_tbl = { greeting = "Hello!" }
local etbl2 = et:new( starter_tbl ) --wrap it

etbl2:emit('tweet', self.greeting )
```

> `--> The tweet was Hello!`

__Listening for events once.__

```lua
etbl:once( 'tweet', function( evt, message )
  print( 'tweet: ' .. message )
  print( 'bye tweety!')
end)
```
> `--> tweet Goodbye!`

> `--> bye tweety!`

The event callback will trigger one time, and never again, unless you re-register the `on` handler.

__Sending events through the network.__

```lua
etbl:emit('my-event', someval, otherval, alotofvals )
```
After specifying an event name, you can pass as many arguments as you need, comma separated.

> __Any _evented_ table can opt-in to listening to any event from any other _evented_ table.__

```lua
local et = require('Eventable')

--Create some new evented tables
local cook = et:new()
local waiter = et:new()

--Cook waits for order
cook:on('order', function( evt, food )
  print('Now cooking'..food)
  -- ...
  self:emit( 'order-up', food )
end)

--Waiter listens for order
waiter:on('order-up', function( evt, food )
  print( 'Your ' .. food .. ' are served.')
end)

--Waiter places order
waiter:emit('order', 'Pancakes')
```
> `--> Now cooking Pancakes`

> `--> Your Panackes are served`

### Communication through modules.

In this example, the first two modules are listening for a _greeting_ event. The third module `emits` the event. You might also notice the use of the `once` method, instead of the more common `on`. Usually once your greeted, you don't need to be re-greeted. So here `once` makes sense.

```lua
--== mod_one.lua ==--
local et = require('Eventable')
local mod = et:new()

mod:once('greeting', function( evt, message )
  print( message )
end)

return mod
```

```lua
--== mod_two.lua ==--
local et = require('Eventable')
local mod = et:new()

mod:once('greeting', function( evt, message )
  print( 'this is my greeting: ' .. message )
end)

return mod
```


```lua
--== mod_three.lua ==--
local et = require('Eventable')
local mod = et:new()

mod:emit( 'greeting', 'Hello!' )

return mod
```
> `--> Hello!`

> `--> this is my greeting: Hello!`

### Managing your listening options.

__Stop listening for a certain event. Other events are unaffected.__

```lua
etbl:off( 'tweet' )
```

__Stop listening for any and all events.__

```lua
etbl:allOff()
```
> __Once you release events using `off` or `allOff`, you will need to re-register your `on` handler again. You can also use `mute`, which does not remove your events, as shown below.__

__Temporary silencing of all events. Events are not released.__

```lua
-- Mute all events
etbl:mute( true )

-- Listen to all events again
etbl:mute( false )
```

__Check if table listening is muted.__

```lua
local trueOrFalse = etbl:isMuted()
```

# Eventable API

The following methods are available on any _evented_ table. Please do not overwrite them.

You can call methods directly on the _evented_ table object, or through using `self` internally.

```lua
local etbl = et:new()
etbl:emit('party', 'tonight')
```
```lua
local etbl = et:new()
etbl:goParty = function(when)
  self:emit('party', when)
end
etbl:goParty('tonight')
```

## Methods

### :new([starting_table])

Creates a fresh _evented_ table. This table can message with other  _evented_ tables and mods. Can optionally take a `starting_table` that will become 'wrapped' into an _evented_ table.

```lua
local et = require('Eventable')

local etbl = et:new()
-- or
local etbl = et:new( { username = "Bob" } )
```

---

### :emit( event_name, ... )

Broadcast data parameters to any other _evented_ tables listening for this `event_name`.

```lua
local et = require('Eventable')

local etbl = et:new()
etbl:emit( 'greeting', 'Good Day!')
```

---

### :on( event_name, callback )

Listens for a specific event name to be emitted, and take action with the callback. The callback will return an `event` object and any other arguments available.

In the `event` object you can find the event `name` and `target` key, which points to the table that triggered this event.

```lua
local et = require('Eventable')

local etbl = et:new()
etbl:on('greeting', function( evt, message )
  print( message )
end)
```

---

### :once( event_name, callback )

Listens for a specific `event_name` to be emitted, and take action with the callback _only one time_, and no more.

```lua
local et = require('Eventable')

local etbl = et:new()
etbl:once('greeting', function( event, message )
  print( message )
  print( 'Bye bye!')
end)
```

> Something like a "greeting" is a good candidate for using `once`, since you only greet someone one time each session.

---

### :off( event_name )

Stop listening for the specified `event_name`. Once a event is turned off, it can only be added as a new `on` instance. See the `mute` method for an alternative.

```lua
etbl:off( 'greeting' )
```
> Will no longer listen for the _greeting_ event.

---

### :allOff()

Removes all events from the table / mod. This table will only get the 'global' event.

```lua
etbl:allOff()
```
> Will no longer listen for the _any_ events.

### :mute( trueOrFalse )

Mutes all event input while enabled. Event listeners are left active unlike `off` or `allOff`.

```lua
etbl:mute( true ) --no events read

-- or

etbl:mute( false ) --read events again
```
> Toggle mute for all events. But listeners will remain.

### :isMuted()

Checks whether the _evented_ table is `muted`. Will return true or false.

```lua
local is_muted = etbl:isMuted()
```

## Eventable static methods

Print a table into human readable form.

```lua
Eventable.p( tbl )
```

To get a count of all the _evented_ tables.

```lua
local count = Eventable.count()
```

Print all event names active to the terminal. (needs work)

```lua
Eventable.list()
```

Release a table from __Eventable__ messaging loop. You cannot reattach after this action. You must create a new instance. Generally, you shouldn't need to use this action.

```lua
Eventable.release( etbl )
```

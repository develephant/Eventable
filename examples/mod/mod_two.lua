local Eventable = require('Eventable')

local mod = Eventable:new()

mod:emit('juices', "cool", "tasty")

return mod

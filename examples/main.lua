local Eventable = require('Eventable')

--== Modules
local mod_one = require('mod.mod_one')
local mod_three = require('mod.mod_three')
local mod_two = require('mod.mod_two')

--== Local Table
local tbl = Eventable:new()
tbl:on('food', function( evt, food )
  print( 'eat more '..food )
end)

tbl:emit('food', 'Tacos')
tbl:emit('food', 'Burgers')

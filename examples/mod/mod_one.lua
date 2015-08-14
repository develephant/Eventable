local Eventable = require('Eventable')

local mod = Eventable:new()

mod:on('juices', function( evt, res )
  print(evt.name..' are '..res)
end)

return mod

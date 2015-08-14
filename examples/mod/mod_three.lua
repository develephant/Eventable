local Eventable = require('Eventable')

local mod = Eventable:new()

mod:on('juices', function( evt, res, res2 )
  print(evt.name..' are ' .. res .. ' and ' .. res2 )
end)

return mod

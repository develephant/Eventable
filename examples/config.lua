
application =
{

  content =
  {
    width = 640,
    height = 960, 
    scale = letterbox,
    fps = 30,
    
    --[[
    imageSuffix =
    {
          ["@2x"] = 2,
    },
    --]]
  },

  --[[
  -- Push notifications
  notification =
  {
    iphone =
    {
      types =
      {
        "badge", "sound", "alert", "newsstand"
      }
    }
  },
  --]]    
}

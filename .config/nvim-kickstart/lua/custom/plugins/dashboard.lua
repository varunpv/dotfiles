return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  opts = function()
    local logo = [[
    
                                                                                   
`8.`888b           ,8' .8.          8 888888888o.  8 8888      88 b.             8 
 `8.`888b         ,8' .888.         8 8888    `88. 8 8888      88 888o.          8 
  `8.`888b       ,8' :88888.        8 8888     `88 8 8888      88 Y88888o.       8 
   `8.`888b     ,8' . `88888.       8 8888     ,88 8 8888      88 .`Y888888o.    8 
    `8.`888b   ,8' .8. `88888.      8 8888.   ,88' 8 8888      88 8o. `Y888888o. 8 
     `8.`888b ,8' .8`8. `88888.     8 888888888P'  8 8888      88 8`Y8o. `Y88888o8 
      `8.`888b8' .8' `8. `88888.    8 8888`8b      8 8888      88 8   `Y8o. `Y8888 
       `8.`888' .8'   `8. `88888.   8 8888 `8b.    ` 8888     ,8P 8      `Y8o. `Y8 
        `8.`8' .888888888. `88888.  8 8888   `8b.    8888   ,d8P  8         `Y8o.` 
         `8.` .8'       `8. `88888. 8 8888     `88.   `Y88888P'   8            `Yo 

      ]]

    logo = string.rep('\n', 8) .. logo .. '\n\n'

    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, '\n'),
          -- stylua: ignore
          center = {
            { action = "ene | startinsert",                                        desc = " New File",        icon = " ", key = "n" },
            { action = "Telescope oldfiles",                                       desc = " Recent Files",    icon = " ", key = "r" },
            { action = "Telescope live_grep",                                      desc = " Find Text",       icon = " ", key = "g" },
            { action = [[lua LazyVim.telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras",                                               desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
          },
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
      button.key_format = '  %s'
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'DashboardLoaded',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    return opts
  end,
}

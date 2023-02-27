local K = {}
local defaults = {
  title = "Kitty.nvim",
  open_cmds = {
    [""] = "",
    IPy = "ipython",
    Bash = "bash",
    Zsh = "zsh",
    Fish = "fish",
    Live = {
      cmd = function(self)
        return "nvim scatch." .. self:repl().file_ending .. ' -c "SnipLive"'
      end,
    },
  },
  send_cmds = {
    [""] = {
      fun = function(self, args)
        self:send(args.args .. "\r")
      end,
    },
    ["Cell"] = "send_cell",
    ["CLine"] = { desc = "Current Line", fun = "send_current_line" },
    ["Word"] = { desc = "Current Word", fun = "send_current_word" },
    ["Lines"] = { fun = "send_range" },
    ["Sel"] = { desc = "Selection", fun = "send_selection" },
    ["File"] = { fun = "send_file" },
  },
}
K.setup = function(cfg)
  vim.tbl_extend("keep", cfg, defaults)
  vim.tbl_extend("force", cfg.open_cmds, cfg.user_open_cmds)
  vim.tbl_extend("force", cfg.send_cmds, cfg.user_send_cmds)
  K = require("kitty.term").new(cfg)
  K:setup()
  return K
end
return K
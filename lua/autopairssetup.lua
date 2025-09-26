local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")
local cond = require("nvim-autopairs.conds")

npairs.add_rule(Rule("$", "$", "typst"):with_move(cond.after_regex("$")))

local utils = require("aws-sdk.utils")
local themes = require('telescope.themes')

local M = {}

M.find_command = function()
    utils.packages(themes.get_dropdown({}))
end

return M

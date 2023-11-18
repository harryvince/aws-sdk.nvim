local utils = require("aws-sdk.utils")
local packages = require('aws-sdk.packages')

local M = {}

M.find_command = function(opts)
    utils.initial_search(opts, packages, utils.operations)
end

return M

local utils = require("aws-sdk.utils")

local M = {}

M.find_command = function(opts)
    utils.packages(opts)
end

return M

-- ensure bundled modules resolve relative to this folder
local base = fs.getDir(shell.getRunningProgram())
package.path = package.path .. string.format(";%s/?.lua;%s/?/?.lua;%s/?/?/?.lua", base, base, base)
-- Entry point for the standalone SCADA-style UI kit
-- Launches the demo UI for both terminal and attached monitors

require("demo.ui_demo")

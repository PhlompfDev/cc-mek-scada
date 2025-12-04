-- ensure bundled modules resolve relative to this folder
local base = fs.getDir(shell.getRunningProgram())
package.path = package.path .. string.format(";%s/?.lua;%s/?/?.lua;%s/?/?/?.lua", base, base, base)

require("demo.ui_demo")

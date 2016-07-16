-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local SicherungNEU = require("shell").parse(...)[1]
local SicherungALT = loadfile("/stargate/Sicherungsdatei.lua")()
local sprachen

if fs.exists("/stargate/sprache/" .. SicherungNEU.Sprache .. ".lua") then
  sprachen = loadfile("/stargate/sprache/" .. SicherungNEU.Sprache .. ".lua")()
elseif fs.exists("/stargate/sprache/" .. SicherungALT.Sprache .. ".lua") then
  sprachen = loadfile("/stargate/sprache/" .. SicherungALT.Sprache .. ".lua")()
else
  sprachen = loadfile("/stargate/sprache/deutsch.lua")()
end

if type(SicherungNEU) == "table" then
  local f = io.open ("/stargate/Sicherungsdatei.lua", "w")
  f:write('-- pastebin run -f Dkt9dn4S\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n--\n')
  f:write('-- ' .. sprachen.speichern .. '\n')
  f:write('-- ' .. sprachen.schliessen .. '\n--\n\n')
  f:write('return {\n')
  if type(SicherungNEU.IDC) == "string" then
    f:write('  IDC           = "' .. tostring(SicherungNEU.IDC) .. '", -- ' .. sprachen.iriscode .. '\n')
  else
    f:write('  IDC           = "' .. tostring(SicherungALT.IDC) .. '", -- ' .. sprachen.iriscode .. '\n')
  end
  if type(SicherungNEU.autoclosetime) == "number" or SicherungNEU.autoclosetime == false then
    f:write('  autoclosetime = '  .. tostring(SicherungNEU.autoclosetime) .. ', -- ' .. sprachen.autoclosetime .. '\n')
  else
    f:write('  autoclosetime = '  .. tostring(SicherungALT.autoclosetime) .. ', -- ' .. sprachen.autoclosetime .. '\n')
  end
  if type(SicherungNEU.RF) == "boolean" then
    f:write('  RF            = '  .. tostring(SicherungNEU.RF) .. ', -- ' .. sprachen.RF .. '\n')
  else
    f:write('  RF            = '  .. tostring(SicherungALT.RF) .. ', -- ' .. sprachen.RF .. '\n')
  end
  if type(SicherungNEU.Sprache) == "string" then
    f:write('  Sprache       = "' .. tostring(SicherungNEU.Sprache) .. '", -- ' .. sprachen.Sprache .. '\n')
  else
    f:write('  Sprache       = "' .. tostring(SicherungALT.Sprache) .. '", -- ' .. sprachen.Sprache .. '\n')
  end
  if type(SicherungNEU.side) == "string" then
    f:write('  side          = "' .. tostring(SicherungNEU.side) .. '", -- ' ... sprachen.side .. '\n')
  else
    f:write('  side          = "' .. tostring(SicherungALT.side) .. '", -- ' ... sprachen.side .. '\n')
  end
  if type(SicherungNEU.autoUpdate) == "boolean" then
    f:write('  autoUpdate    = '  .. tostring(SicherungNEU.autoUpdate) .. ', -- ' .. sprachen.autoUpdate .. '\n')
  else
    f:write('  autoUpdate    = '  .. tostring(SicherungALT.autoUpdate) .. ', -- ' .. sprachen.autoUpdate .. '\n')
  end
  if type(SicherungNEU.control) == "string" then
    f:write('  control       = "' .. tostring(SicherungNEU.control) .. '",\n\n')
  else
    f:write('  control       = "' .. tostring(SicherungALT.control) .. '",\n\n')
  end
  f:write(string.rep("-", 10) .. "don't change anything below" .. string.rep("-", 33) .. '\n\n')
  if type(SicherungNEU.installieren) == "boolean" then
    f:write('  installieren  = '  .. tostring(SicherungNEU.installieren) .. ',\n')
  else
    f:write('  installieren  = '  .. tostring(SicherungALT.installieren) .. ',\n')
  end
  f:write('}')
  f:close()
  return true
else
  return false
end

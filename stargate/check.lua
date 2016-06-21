-- pastebin run -f fa9gu1GJ
-- von Nex4rius

local component = require("component")
local sides = require("sides")
local term = require("term")
local event = require("event")
local fs = require("filesystem")
local c = require("computer")
local shell = require("shell")
local wget = loadfile("/bin/wget.lua")
local gpu = component.getPrimary("gpu")
local args = shell.parse(...)
local serverAddresse = "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/"
local versionTyp = "master"
local Sprache = ""
local control = "On"
local firstrun = -2
local Sprache = ""
local installieren = false
local betaVersionName = ""

if fs.exists("/stargate/version.txt") then
  f = io.open ("/stargate/version.txt", "r")
  local version = f:read()
  f:close()
else
  local version = fehlerName
end

dofile("/stargate/sicherNachNeustart.lua")

os.execute("label -a " .. c.getBootAddress() .. " StargateOS")

term.clear()

function schreibSicherungsdatei()
  f = io.open ("/stargate/sicherNachNeustart.lua", "w")
  f:write('control = "' .. control .. '"\n')
  f:write('firstrun = ' .. firstrun .. '\n')
  f:write('Sprache = "' .. Sprache .. '" -- deutsch / english\n')
  f:write('installieren = ' .. tostring(installieren) .. '\n')
  f:close()
end

function checkSprache()
  print("Sprache? / Language? deutsch / english\n")
  antwortFrageSprache = io.read()
  if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" then
    Sprache = string.lower(antwortFrageSprache)
  else
    print("\nUnbekannte Eingabe\nStandardeinstellung = deutsch")
    Sprache = "deutsch"
  end
  schreibSicherungsdatei()
  print("")
end

function checkKomponenten()
  print(pruefeKomponenten)
  if component.isAvailable("redstone") then
    print(redstoneOK)
    local r = component.getPrimary("redstone")
    local redst = true
  else
    print(redstoneFehlt)
    local r = nil
    local redst = false
  end
  if gpu.maxResolution() == 80 then
    print(gpuOK2T)
  elseif gpu.maxResolution() == 160 then
    local graphicT3 = true
    print(gpuOK3T)
  else
    print(gpuFehlt)
  end
  if component.isAvailable("internet") then
    print(InternetOK)
    local internet = true
  else
    print(InternetFehlt)
    local internet = false
  end
  if component.isAvailable("stargate") then
    print(StargateOK)
    local sg = component.getPrimary("stargate")
    return true
  else
    print(StargateFehlt)
    return false
  end
end

function Pfad()
  return serverAddresse .. versionTyp
end

function update(versionTyp)
  wget("-f", Pfad() .. "/installieren.lua", "/installieren.lua")
  installieren = true
  schreibSicherungsdatei()
  f = io.open ("autorun.lua", "w")
  f:write('versionTyp = "' .. versionTyp .. '"\n')
  f:write('dofile("installieren.lua")')
  f:close()
  os.execute("reboot")
end

function checkServerVersion()
  versionTyp = "master"
  wget("-fQ", Pfad() .. "/stargate/version.txt", "/serverVersion.txt")
  if fs.exists("/serverVersion.txt") then
    f = io.open ("/serverVersion.txt", "r")
    serverVersion = f:read()
    f:close()
    os.execute("del serverVersion.txt")
  else
    serverVersion = fehlerName
  end
  return serverVersion
end

function checkBetaServerVersion()
  versionTyp = "beta"
  wget("-fQ", Pfad() .. "/stargate/version.txt", "/betaVersion.txt")
  if fs.exists("/betaVersion.txt") then
    f = io.open ("/betaVersion.txt", "r")
    betaServerVersion = f:read()
    f:close()
    os.execute("del /betaVersion.txt")
  else
    betaServerVersion = fehlerName
  end
  return betaServerVersion
end

function mainCheck()
  if internet == true then
    local serverVersion = checkServerVersion()
    local betaServerVersion = checkBetaServerVersion()
    print(derzeitigeVersion .. version .. verfuegbareVersion .. serverVersion)
    if serverVersion == betaServerVersion then else
      print(betaVersion .. betaServerVersion .. " BETA")
      if betaServerVersion == fehlerName then else
        betaVersionName = "/beta"
      end
    end
    if args[1] == ja then
      print(aktualisierenJa)
      update("master")
    elseif args[1] == nein then
      -- nichts
    elseif args[1] == "beta" then
      print(aktualisierenBeta)
      update("beta")
    elseif version == serverVersion and version == betaServerVersion then else
      if installieren == false then
        print(aktualisierenFrage .. betaVersionName .. "\n")
        antwortFrage = io.read()
        if string.lower(antwortFrage) == ja then
          print(aktualisierenJa)
          update("master")
          return
        elseif antwortFrage == "beta" then
          print(aktualisierenBeta)
          update("beta")
          return
        else
          print(aktualisierenNein .. antwortFrage)
        end
      end
    end
  end
  print(laden)
  installieren = false
  schreibSicherungsdatei()
  dofile("/stargate/adressen.lua")
  dofile("/stargate/config.lua")
end

if Sprache == "" then
  checkSprache()
end

dofile("/stargate/sprache/" .. Sprache .. ".lua")

if args[1] == hilfe then
  print(Hilfetext)
else
  if checkKomponenten() == true then
    mainCheck()
  end
end

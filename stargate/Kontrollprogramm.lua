-- pastebin run -f fa9gu1GJ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

dofile("/stargate/adressen.lua")
dofile("/stargate/config.lua")

local function try(func, ...)
  local ok, result = pcall(func, ...)
  if not ok then
    print("Error: " .. result)
  end
end

local function check(...)
  local values = {...}
  if values[1] == nil then
    error(values[2], 0)
  end
  return ...
end

local function setCursor(col, row)
  term.setCursor(col, row)
end

local function write(s)
  term.write(s)
end

local function pull_event()
  if state == "Idle" and checkEnergy == energy then
    local checkEnergy = energy
    return event.pull(300)
  else
    local checkEnergy = energy
    return event.pull(1)
  end
end

local screen_width, screen_height = gpu.getResolution()
local max_Bildschirmbreite, max_Bildschirmhoehe = gpu.maxResolution()
local key_event_name = "key_down"

local function key_event_char(e)
  return string.char(e[3])
end

dofile("/stargate/sicherNachNeustart.lua")
dofile("/stargate/sprache/" .. Sprache .. ".lua")
dofile("/stargate/sprache/ersetzen.lua")

local function pad(s, n)
  return s .. string.rep(" ", n - string.len(s))
end

local function zeichenErsetzen(eingabeErsetzung)
  return string.gsub(eingabeErsetzung, "%a+", function (str) return ersetzen [str] end)
end

local function checkReset()
  if time == "-" then else
    if time > 500 then
      messageshow = true
      IDCyes = false
      send = true
      incode = "-"
      AddNewAddress = true
      entercode = false
      showidc = ""
      wormhole = "in"
      codeaccepted = "-"
      k = "open"
      iriscontrol = "on"
      remoteName = ""
      activationtime = 0
      LampenGruen = false
      zielAdresse = ""
    end
  end
end

local function zeigeMenu()
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  for P = 1, screen_height - 3 do
    zeigeHier(1, P, "", xVerschiebung - 3)
  end
  setCursor(1, 1)
  if seite == -1 then
    Infoseite()
  else
    if (os.time() / sectime) - letzterAdressCheck > 21600 then
      letzterAdressCheck = os.time() / sectime
      AdressenSpeichern()
    end
    print(Adressseite .. seite + 1)
    AdressenLesen()
    iris = sg.irisState()
  end
end

local function AdressenLesen()
  for i, na in pairs(gespeicherteAdressen) do
    if i >= 1 + seite * 10 and i <= 10 + seite * 10 then
      AdressAnzeige = i - seite * 10
      if AdressAnzeige == 10 then
        AdressAnzeige = 0
      end
      print(AdressAnzeige .. " " .. string.sub(na[1], 1, xVerschiebung - 7))
      if string.sub(na[4], 1, 1) == "<" then
        gpu.setForeground(FehlerFarbe)
        print("   " .. na[4])
        gpu.setForeground(Adresstextfarbe)
      else
        print("   " .. na[4])
      end
    end
  end
end

local function Infoseite()
  print(Steuerung)
  if iris == "Offline" then else
    print("I " .. IrisSteuerung .. an_aus)
  end
  print("Z " .. AdressenBearbeiten)
  print("Q " .. beenden)
  print("L " .. spracheAendern .. "\n" .. verfuegbareSprachen)
  print(RedstoneSignale)
  gpu.setBackground(weisseFarbe)
  gpu.setForeground(schwarzeFarbe)
  print(RedstoneWeiss)
  gpu.setBackground(roteFarbe)
  print(RedstoneRot)
  gpu.setBackground(gelbeFarbe)
  print(RedstoneGelb)
  gpu.setBackground(schwarzeFarbe)
  gpu.setForeground(weisseFarbe)
  print(RedstoneSchwarz)
  gpu.setBackground(grueneFarbe)
  print(RedstoneGruen)
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  print(versionName .. version)
end

local function AdressenSpeichern()
  dofile("/stargate/adressen.lua")
  gespeicherteAdressen = {}
  local k = 0
  for i, na in pairs(adressen) do
    gespeicherteAdressen[i + k] = {}
    if na[2] == getAddress(sg.localAddress()) then
      k = -1
    else
      gespeicherteAdressen[i + k][1] = na[1]
      gespeicherteAdressen[i + k][2] = na[2]
      gespeicherteAdressen[i + k][3] = na[3]
      local anwahlEnergie = sg.energyToDial(na[2])
      if not anwahlEnergie then
        gespeicherteAdressen[i + k][4] = fehlerName
      else
        if     anwahlEnergie > 10000000000 then
          gespeicherteAdressen[i + k][4] = string.format("%.1f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000000) .. " G"
        elseif anwahlEnergie > 10000000 then
          gespeicherteAdressen[i + k][4] = string.format("%.1f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000) .. " M"
        elseif anwahlEnergie > 10000 then
          gespeicherteAdressen[i + k][4] = string.format("%.1f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000) .. " k"
        else
          gespeicherteAdressen[i + k][4] = string.format("%.f" , (sg.energyToDial(na[2]) * energymultiplicator))
        end
      end
    end
    zeigeNachricht(verarbeiteAdressen .. "<" .. na[2] .. "> <" .. na[1] .. ">")
    maxseiten = (i + k) / 10
  end
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  for P = 1, screen_height - 3 do
    zeigeHier(1, P, "", xVerschiebung - 3)
  end
  zeigeMenu()
  zeigeNachricht("")
end

local function zeigeFarben()
  gpu.setBackground(Trennlinienfarbe)
  for P = 1, screen_height - 2 do
    zeigeHier(xVerschiebung - 2, P, "  ", 1)
  end
  zeigeHier(1, screen_height - 2, "", 80)
  zeigeHier(xVerschiebung - 2, Trennlinienhoehe, "")
  neueZeile(1)
end

local function getIrisState()
  ok, result = pcall(sg.irisState)
  return result
end

local function irisClose()
  sg.closeIris()
  RedstoneAenderung(yellow, 255)
  --IrisZustandName = irisNameSchliessend
  Colorful_Lamp_Steuerung()
end

local function irisOpen()
  sg.openIris()
  RedstoneAenderung(yellow, 0)
  --IrisZustandName = irisNameOeffnend
  --iris = "Opening"
  Colorful_Lamp_Steuerung()
end

local function sides()
  if side == "oben" or side == "top" then
    sideNum = 1
  elseif side == "hinten" or side == "back" then
    sideNum = 2
  elseif side == "vorne" or side == "front" then
    sideNum = 3
  elseif side == "rechts" or side == "right" then
    sideNum = 4
  elseif side == "links" or side == "left" then
    sideNum = 5
  else
    sideNum = 0
  end
end

local function iriscontroller()
  if state == "Dialing" then
    messageshow = true
  end
  if direction == "Incoming" and incode == IDC and control == "Off" then
    IDCyes = true
    RedstoneAenderung(black, 255)
    if iris == "Closed" or iris == "Closing" or LampenRot == true then else
      Colorful_Lamp_Farben(992)
    end
  end
  if direction == "Incoming" and incode == IDC and iriscontrol == "on" and control == "On" then
    if iris == "Offline" then
      sg.sendMessage("IDC Accepted Iris: Offline")
    else
      irisOpen()
      os.sleep(2)
      sg.sendMessage("IDC Accepted Iris: Open")
    end
    iriscontrol = "off"
    IDCyes = true
  elseif direction == "Incoming" and send == true then
    sg.sendMessage("Iris Control: "..control.." Iris: "..iris)
    send = false
  end
  if wormhole == "in" and state == "Dialling" and iriscontrol == "on" and control == "On" then
    if iris == "Offline" then else
      irisClose()
      RedstoneAenderung(red, 255)
      redstoneIncoming = false
    end
    k = "close"
  end
  if iris == "Closing" and control == "On" then
    k = "open"
  end
  if state == "Idle" and k == "close" and control == "On" then
    outcode = nil
    if iris == "Offline" then else
      irisOpen()
    end
    iriscontrol = "on"
    wormhole = "in"
    codeaccepted = "-"
    activationtime = 0
    entercode = false
    showidc = ""
    zielAdresse = ""
  end
  if state == "Idle" and control == "On" then
    iriscontrol = "on"
  end
  if state == "Closing" then
    send = true
    incode = "-"
    IDCyes = false
    AddNewAddress = true
    LampenGruen = false
    LampenRot = false
    zielAdresse = ""
  end
  if state == "Idle" then
    incode = "-"
    wormhole = "in"
    LampenGruen = false
    LampenRot = false
    zielAdresse = ""
  end
  if state == "Closing" and control == "On" then
    k = "close"
  end
  if state == "Connected" and direction == "Outgoing" and send == true then
    if outcode == "-" or outcode == nil then else
      sg.sendMessage(outcode)
      send = false
    end
  end
  if codeaccepted == "-" or codeaccepted == nil then
  elseif messageshow == true then
    zeigeNachricht(nachrichtAngekommen .. codeaccepted .. "                   ")
    if codeaccepted == "Request: Disconnect Stargate" then
      sg.disconnect()
    elseif string.match(codeaccepted, "Iris: Open") or string.match(codeaccepted, "Iris: Offline") then
      LampenGruen = true
      LampenRot = false
    elseif string.match(codeaccepted, "Iris: Closed") then
      LampenGruen = false
      LampenRot = true
    end
    messageshow = false
    incode = "-"
    codeaccepted = "-"
  end
  if state == "Idle" then
    activationtime = 0
    entercode = false
    remoteName = ""
  end
end

local function neueZeile(b)
  zeile = zeile + b
end

local function newAddress(g)
  if AddNewAddress == true then
    f = io.open ("stargate/adressen.lua", "a")
    f:seek ("end", firstrun)
    f:write('  {"' .. g .. '", "' .. g .. '", ""},\n}')
    f:close ()
    AddNewAddress = false
    firstrun = -1
    schreibSicherungsdatei()
    dofile("/stargate/adressen.lua")
    sides()
    zeigeMenu()
  end
end

local function destinationName()
  if state == "Dialling" or state == "Connected" then
    if remoteName == "" and state == "Dialling" and wormhole == "in" then
      for j, na in pairs(adressen) do
        if remAddr == na[2] then
          if na[1] == na[2] then
            remoteName = Unbekannt
          else
            remoteName = na[1]
            break
          end
        end
      end
      if remoteName == "" then
        newAddress(remAddr)
      end
    end
  end
end

local function getAddress(A)
  if A == "" or A == nil then
    return ""
  else
    return string.sub(A, 1, 4) .. "-" .. string.sub(A, 5, 7) .. "-" .. string.sub(A, 8, 9)
  end
end

local function wormholeDirection()
  if direction == "Outgoing" then
    wormhole = "out"
  end
  if wormhole == "out" and state == "Closing" then
    direction = "Outgoing"
  end
end

local function aktualisiereStatus()
  gpu.setResolution(70, 25)
  sg = component.getPrimary("stargate")
  locAddr = getAddress(sg.localAddress())
  remAddr = getAddress(sg.remoteAddress())
  destinationName()
  state, chevrons, direction = sg.stargateState()
  wormholeDirection()
  iris = sg.irisState()
  iriscontroller()
  if state == "Idle" then
    RichtungName = ""
  else
    if wormhole == "out" then
      RichtungName = RichtungNameAus
    else
      RichtungName = RichtungNameEin
    end
  end
  if state == "Idle" then
    StatusName = StatusNameUntaetig
  elseif state == "Dialling" then
    StatusName = StatusNameWaehlend
  elseif state == "Connected" then
    StatusName = StatusNameVerbunden
  elseif state == "Closing" then
    StatusName = StatusNameSchliessend
  else
    StatusName = StatusNameVerbunden
  end
  energy = sg.energyAvailable() * energymultiplicator
  zeile = 1
  if (letzteNachricht - os.time()) / sectime > 45 then
    zeigeNachricht("")
  end
end

local function zeigeStatus()
  gpu.setBackground(Statusfarbe)
  gpu.setForeground(Statustextfarbe)
  aktualisiereStatus()
  zeigeHier(xVerschiebung, zeile, "  " .. lokaleAdresse .. locAddr) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. zielAdresseName .. zielAdresse) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. zielName .. remoteName) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. statusName .. StatusName) neueZeile(1)
  zeigeEnergie() neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. IrisName .. zeichenErsetzen(iris)) neueZeile(1)
  if iris == "Offline" then else
    zeigeHier(xVerschiebung, zeile, "  " .. IrisSteuerung .. zeichenErsetzen(control)) neueZeile(1)
  end
  if IDCyes == true then
    zeigeHier(xVerschiebung, zeile, "  " .. IDCakzeptiert) neueZeile(1)
  else
    zeigeHier(xVerschiebung, zeile, "  " .. IDCname .. incode) neueZeile(1)
  end
  zeigeHier(xVerschiebung, zeile, "  " .. chevronName .. chevrons) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. richtung .. RichtungName) neueZeile(1)
  activetime() neueZeile(1)
  autoclose()
  zeigeHier(xVerschiebung, zeile + 1, "")
  Trennlinienhoehe = zeile + 2
  zeigeSteuerung()
  RedstoneKontrolle()
  Colorful_Lamp_Steuerung()
end

local function RedstoneAenderung(a, b)
  if sideNum == nil then
    sides()
  end
  if component.isAvailable("redstone") then
    r.setBundledOutput(sideNum, a, b)
  end
end

local function RedstoneKontrolle()
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
  end
  if direction == "Incoming" then
    if redstoneIncoming == true then
      RedstoneAenderung(red, 255)
      redstoneIncoming = false
    end
  elseif redstoneIncoming == false and state == "Idle" then
    RedstoneAenderung(red, 0)
    redstoneIncoming = true
  end
  if state == "Idle" then
    if redstoneState == true then
      RedstoneAenderung(white, 0)
      redstoneState = false
    end
  elseif redstoneState == false then
    RedstoneAenderung(white, 255)
    redstoneState = true
  end
  if IDCyes == true then
    if redstoneIDC == true then
      RedstoneAenderung(black, 255)
      redstoneIDC = false
    end
  elseif redstoneIDC == false then
    RedstoneAenderung(black, 0)
    redstoneIDC = true
  end
  if state == "Connected" then
    if redstoneConnected == true then
      RedstoneAenderung(green, 255)
      redstoneConnected = false
    end
  elseif redstoneConnected == false then
    RedstoneAenderung(green, 0)
    redstoneConnected = true
  end
end

local function zeigeSteuerung()
  zeigeFarben()
  gpu.setBackground(Steuerungsfarbe)
  gpu.setForeground(Steuerungstextfarbe)
  neueZeile(3)
  zeigeHier(xVerschiebung, zeile - 1, "")
  zeigeHier(xVerschiebung, zeile, "  " .. Steuerung) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "") neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  D " .. abschalten)
  zeigeHier(xVerschiebung + 20, zeile, "E " .. IDCeingabe) neueZeile(1)
  if iris == "Offline" then
    control = "Off"
  else
    zeigeHier(xVerschiebung, zeile, "  O " .. oeffneIris)
    zeigeHier(xVerschiebung + 20, zeile, "C " .. schliesseIris) neueZeile(1)
  end
  if seite >= 0 then
    if seite >= 1 then
      zeigeHier(xVerschiebung, zeile, "  ← " .. vorherigeSeite)
    else
      zeigeHier(xVerschiebung, zeile, "  ← " .. SteuerungName)
    end
  else
    zeigeHier(xVerschiebung, zeile, "")
  end
  if seite == -1 then
    zeigeHier(xVerschiebung + 20, zeile, "→ " .. zeigeAdressen)
  elseif maxseiten > seite + 1 then
    zeigeHier(xVerschiebung + 20, zeile, "→ " .. naechsteSeite)
  end
  neueZeile(1)
  for i = zeile, screen_height - 3 do
    zeigeHier(xVerschiebung, i, "")
  end
end

local function autoclose()
  if autoclosetime == false then
    zeigeHier(xVerschiebung, zeile, "  " .. autoSchliessungAus)
  else
    zeigeHier(xVerschiebung, zeile, "  " .. autoSchliessungAn .. autoclosetime .. "s")
    if (activationtime - os.time()) / sectime > autoclosetime and state == "Connected" then
      sg.disconnect()
    end
  end
end

local function zeigeEnergie()
  if     energy > 10000000000 then
    energieMenge = string.format("%.2f", energy / 1000000000) .. " G"
  elseif energy > 10000000 then
    energieMenge = string.format("%.2f", energy / 1000000) .. " M"
  elseif energy > 10000 then
    energieMenge = string.format("%.2f", energy / 1000) .. " k"
  else
    energieMenge = string.format("%.f", energy)
  end
  zeigeHier(xVerschiebung, zeile, "  " .. energie1 .. energytype .. energie2 .. energieMenge)
end

local function activetime()
  if state == "Connected" then
    if activationtime == 0 then
      activationtime = os.time()
    end
    time = (activationtime - os.time()) / sectime
    if time > 0 then
      zeigeHier(xVerschiebung, zeile, "  " .. zeit1 .. string.format("%.1f", time) .. "s")
    end
  else
    zeigeHier(xVerschiebung, zeile, "  " .. zeit2)
  end
end

local function zeigeHier(x, y, s, h)
  setCursor(x, y)
  if h == nil then
    h = screen_width
  end
  write(pad(s, h))
end

local function zeigeNachricht(mess)
  letzteNachricht = os.time()
  gpu.setBackground(Nachrichtfarbe)
  gpu.setForeground(Nachrichttextfarbe)
  zeigeHier(1, screen_height - 1, "", screen_width)
  zeigeHier(1, screen_height, zeichenErsetzen(mess), screen_width)
  gpu.setBackground(Statusfarbe)
end

local function zeigeFehler(mess)
  if mess == "" then else
    schreibFehlerLog(mess)
    mess = string.format("%s %s", fehlerName, mess)
    zeigeNachricht(mess)
  end
end

local function schreibFehlerLog(mess)
  if mess_old == mess then else
    if fs.exists("/log") then
      f = io.open("log", "a")
    else
      f = io.open("log", "w")
    end
    f:write(mess)
    f:write("\n\n" .. os.time() .. string.rep("-", max_Bildschirmbreite - string.len(os.time())) .. "\n\n")
    f:close()
  end
  mess_old = mess
end

handlers = {}

local function dial(name, adresse)
  if state == "Idle" then
    remoteName = name
    zeigeNachricht(waehlen .. "<" .. string.sub(remoteName, 1, xVerschiebung + 12) .. "> <" .. adresse .. ">")
  end
  state = "Dialling"
  ok, ergebnis = sg.dial(adresse)
  if ok == nil then
    zeigeNachricht(ergebnis)
  end
end

handlers[key_event_name] = function(e)
  c = key_event_char(e)
  if e[3] == 13 then
    entercode = false
    sg.sendMessage(enteridc)
  elseif entercode == true then
    enteridc = enteridc .. c
    showidc = showidc .. "*"
    zeigeNachricht(IDCeingabe .. ": " .. showidc)
  elseif c == "e" then
    if state == "Connected" and direction == "Outgoing" then
      enteridc = ""
      showidc = ""
      entercode = true
      zeigeNachricht(IDCeingabe .. ":")
    else
      zeigeNachricht(keineVerbindung)
    end
  elseif c == "d" then
    if state == "Connected" and direction == "Incoming" then
      sg.disconnect()
      sg.sendMessage("Request: Disconnect Stargate")
      zeigeNachricht(senden .. aufforderung .. ": " .. stargateAbschalten .. " " .. stargateName)
    else
      sg.disconnect()
      if state == "Idle" then else
        zeigeNachricht(stargateAbschalten .. " " .. stargateName)
      end
    end
  elseif c == "o" then
    if iris == "Offline" then else
      irisOpen()
      if wormhole == "in" then
        if iris == "Offline" then else
          os.sleep(2)
          sg.sendMessage("Manual Override: Iris: Open")
        end
      end
      if state == "Idle" then
        iriscontrol = "on"
      else
        iriscontrol = "off"
      end
    end
  elseif c == "c" then
    if iris == "Offline" then else
      irisClose()
      iriscontrol = "off"
      if wormhole == "in" then
        sg.sendMessage("Manual Override: Iris: Closed")
      end
    end
  elseif c >= "0" and c <= "9" then
    if c == "0" then
      c = 10
    end
    c = c + seite * 10
    na = gespeicherteAdressen[tonumber(c)]
    iriscontrol = "off"
    wormhole = "out"
    if na then
      dial(na[1], na[2])
      if na[3] == "-" then
        else outcode = na[3]
      end
    end
  elseif e[3] == 0 and e[4] == 203 then
    if seite <= -1 then else
      seite = seite - 1
      gpu.setBackground(Adressfarbe)
      gpu.setForeground(Adresstextfarbe)
      for P = 1, screen_height - 3 do
        zeigeHier(1, P, "", xVerschiebung - 3)
      end
      zeigeAnzeige()
    end
  elseif e[3] == 0 and e[4] == 205 then
    if seite + 1 < maxseiten then
      seite = seite + 1
      gpu.setBackground(Adressfarbe)
      gpu.setForeground(Adresstextfarbe)
      for P = 1, screen_height - 3 do
        zeigeHier(1, P, "", xVerschiebung - 3)
      end
      zeigeAnzeige()
    end
  elseif seite == -1 then
    if c == "q" then
      running = false
    elseif c == "i" then
      if iris == "Offline" then else
        send = true
        if control == "On" then
          control = "Off"
          schreibSicherungsdatei()
        else
          control = "On"
          schreibSicherungsdatei()
        end
      end
    elseif c == "z" then
      gpu.setBackground(0x333333)
      gpu.setForeground(Textfarbe)
      os.execute("edit stargate/adressen.lua")
      dofile("/stargate/adressen.lua")
      sides()
      seite = 0
      zeigeAnzeige()
      AdressenSpeichern()
    elseif c == "l" then
      gpu.setBackground(0x333333)
      gpu.setForeground(Textfarbe)
      term.clear()
      print(spracheAendern .. "\n" .. verfuegbareSprachen .. "\n")
      antwortFrageSprache = io.read()
      if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" then
        Sprache = string.lower(antwortFrageSprache)
        dofile("/stargate/sprache/" .. Sprache .. ".lua")
        dofile("/stargate/sprache/ersetzen.lua")
        schreibSicherungsdatei()
      else
        print(fehlerName)
      end
      seite = 0
      zeigeAnzeige()
    end
  end
end

local function handlers.sgChevronEngaged(e)
  chevron = e[3]
  if chevron == 1 then
    zielAdresse = e[4]
  elseif chevron == 5 or chevron == 8 then
    zielAdresse = zielAdresse .. "-" .. e[4]
  else
    zielAdresse = zielAdresse .. e[4]
  end
  zeigeNachricht(string.format("Chevron %s %s! <%s>", chevron, aktiviert, zielAdresse))
end

local function eventLoop()
  while running do
    checken(zeigeStatus)
    checken(checkReset)
    e = {pull_event()}
    if e[1] == nil then else
      name = e[1]
      f = handlers[name]
      if f then
        checken(f, e)
      end
      if string.sub(e[1],1,3) == "sgM" and direction == "Incoming" and wormhole == "in" then
        if e[3] == "" then else
          incode = e[3]
          messageshow = true
        end
      end
      if string.sub(e[1],1,3) == "sgM" and direction == "Outgoing" then
        codeaccepted = e[3]
        messageshow = true
      end
    end
  end
end

local function checken(...)
  ok, result = pcall(...)
  if not ok then
    zeigeFehler(result)
  end
end

local function Colorful_Lamp_Steuerung()
  if iris == "Closed" or iris == "Closing" or LampenRot == true then
    Colorful_Lamp_Farben(31744) -- rot
  elseif redstoneIDC == false then
    Colorful_Lamp_Farben(992)   -- grün
  elseif redstoneIncoming == false then
    Colorful_Lamp_Farben(32256) -- orange
  elseif LampenGruen == true then
    Colorful_Lamp_Farben(992)   -- grün
  elseif redstoneState == true then
    Colorful_Lamp_Farben(32736) -- gelb
  else
    Colorful_Lamp_Farben(32767) -- weiß
  end
  -- 32767  weiß
  -- 32736  gelb
  -- 32256  orange
  -- 31744  rot
  -- 992    grün
  -- 0      schwarz
end

local function Colorful_Lamp_Farben(eingabe, ausgabe)
  if alte_eingabe == eingabe then else
    for k in component.list("colorful_lamp") do
      component.proxy(k).setLampColor(eingabe)
      if ausgabe then
        print(colorfulLampAusschalten .. k)
      end
    end
    alte_eingabe = eingabe
  end
end

local function zeigeAnzeige()
  zeigeFarben()
  zeigeStatus()
  zeigeMenu()
end

local function beendeAlles()
  gpu.setResolution(max_Bildschirmbreite, max_Bildschirmhoehe)
  gpu.setBackground(schwarzeFarbe)
  gpu.setForeground(weisseFarbe)
  term.clear()
  print(ausschaltenName .. "\n")
  Colorful_Lamp_Farben(0, true)
  RedstoneAenderung(white, 0) print(redstoneAusschalten .. "white")
--  RedstoneAenderung(orange, 0) print(redstoneAusschalten .. "orange")
--  RedstoneAenderung(magenta, 0) print(redstoneAusschalten .. "magenta")
--  RedstoneAenderung(lightblue, 0) print(redstoneAusschalten .. "lightblue")
  RedstoneAenderung(yellow, 0) print(redstoneAusschalten .. "yellow")
--  RedstoneAenderung(lime, 0) print(redstoneAusschalten .. "lime")
--  RedstoneAenderung(pink, 0) print(redstoneAusschalten .. "pink")
--  RedstoneAenderung(gray, 0) print(redstoneAusschalten .. "gray")
--  RedstoneAenderung(silver, 0) print(redstoneAusschalten .. "silver")
--  RedstoneAenderung(cyan, 0) print(redstoneAusschalten .. "cyan")
--  RedstoneAenderung(purple, 0) print(redstoneAusschalten .. "purple")
--  RedstoneAenderung(blue, 0) print(redstoneAusschalten .. "blue")
--  RedstoneAenderung(brown, 0) print(redstoneAusschalten .. "brown")
  RedstoneAenderung(green, 0) print(redstoneAusschalten .. "green")
  RedstoneAenderung(red, 0) print(redstoneAusschalten .. "red")
  RedstoneAenderung(black, 0) print(redstoneAusschalten .. "black")
end

local function main()
  if sg.stargateState() == "Idle" and sg.irisState() == "Closed" then
    irisOpen()
  end
  term.clear()
  gpu.setResolution(70, 25)
  zeigeFarben()
  zeigeStatus()
  seite = -1
  zeigeMenu()
  AdressenSpeichern()
  seite = 0
  zeigeMenu()
  eventLoop()
  beendeAlles()
end

checken(main)

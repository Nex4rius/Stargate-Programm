local c = require("component")
local gpu = c.getPrimary("gpu")
local term = require("term")
local kleine_anzeigen = c.list("screen")
local a = {}

os.sleep(2)

a.aktiv = {}

for i = 1, 9 do
    a.aktiv[i] = false
end

a.s = {}

a.s.a = {
    {1,  1, "                                "},
    {1,  2, "         ▁▄▄████████▄▄▁         "},
    {1,  3, "       ▄▟█"},{23,  3, "█▙▄       "},
    {1,  4, "     ▗██"},  {25,  4,   "██▖     "},
    {1,  5, "    ▟█"},    {27,  5,     "█▙    "},
    {1,  6, "   ▟█"},     {28,  6,      "█▙   "},
    {1,  7, "  ▐█"},      {29,  7,       "█▌  "},
    {1,  8, "  ██"},      {29,  8,       "██  "},
    {1,  9, "  ██"},      {29,  9,       "██  "},
    {1, 10, "  ▐█"},      {29, 10,       "█▌  "},
    {1, 11, "   ▜█"},     {28, 11,      "█▛   "},
    {1, 12, "    ▜█"},    {27, 12,     "█▛    "},
    {1, 13, "     ▝██"},  {25, 13,   "██▘     "},
    {1, 14, "       ▀▜█"},{23, 14, "█▛▀       "},
    {1, 15, "         ▔▀▀████████▀▀▔         "},
    {1, 16, "                                "},
}

a.s.i = {
    {11,  3, "▛▀▔▔    ▔▔▀▜"},
    { 9,  4, "▀              ▀"},
    { 7,  5, "▀                  ▀"},
    { 6,  6, "▘                    ▝"},
    { 5,  7, "▌                      ▐"},
    { 5,  8, "                        "},
    { 5,  9, "                        "},
    { 5, 10, "▌                      ▐"},
    { 6, 11, "▖                    ▗"},
    { 7, 12, "▄                  ▄"},
    { 9, 13, "▄              ▄"},
    {11, 14, "▙▄▁▁    ▁▁▄▟"},
}

a.stargatefarbe = 0x3C3C3C
a.chevron_an    = 0xFF6D00
a.chevron_aus   = 0x996D40
a.wurmloch      = 0x0000FF
a.irisfarbe     = 0xA5A5A5
a.aussen        = 0x000000

a[1] = function(aktiv)
    gpu.setBackground(a.aussen)
    gpu.set(25, 3, "▄")
    gpu.set(25, 4, "█▙")
    gpu.setBackground(a.innen)
    gpu.set(24, 4, "▀")
end

a[2] = function(aktiv)
    gpu.setBackground(a.aussen)
    gpu.set(29, 7, "█▌")
    gpu.setBackground(a.innen)
    gpu.set(28, 7, "▐")
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    gpu.setBackground(a.stargatefarbe)
    gpu.set(29, 8, "▀▀")
end

a[3] = function()
    gpu.setBackground(a.aussen)
    gpu.set(27, 12, "█▛")
    gpu.setBackground(a.innen)
    gpu.set(26, 12, "▄")
    gpu.set(27, 11, "▗")
end

a[4] = function()
    gpu.setBackground(a.aussen)
    gpu.set(5, 12, "▜█")
    gpu.setBackground(a.innen)
    gpu.set(7, 12, "▄")
    gpu.set(6, 11, "▖")
end

a[5] = function(aktiv)
    gpu.setBackground(a.aussen)
    gpu.set(3, 7, "▐█")
    gpu.setBackground(a.innen)
    gpu.set(5, 7, "▌")
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    gpu.setBackground(a.stargatefarbe)
    gpu.set(3, 8, "▀▀")
end

a[6] = function()
    gpu.setBackground(a.aussen)
    gpu.set(8, 3, "▄")
    gpu.set(7, 4, "▟█")
    gpu.setBackground(a.innen)
    gpu.set(9, 4, "▀")
end

a[7] = function()
    gpu.set(16, 2, "██")
end

a[8] = function(aktiv)
    gpu.setBackground(a.innen)
    gpu.set(21, 14, "▄▟")
    gpu.setBackground(a.aussen)
    gpu.set(21, 15, "▀▀▔")
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    gpu.setBackground(a.stargatefarbe)
    gpu.set(23, 14, "▄")
end

a[9] = function(aktiv)
    gpu.setBackground(a.innen)
    gpu.set(11, 14, "▙▄")
    gpu.setBackground(a.aussen)
    gpu.set(10, 15, "▔▀▀")
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    gpu.setBackground(a.stargatefarbe)
    gpu.set(10, 14, "▄")
end

function a.init()
    a.innen = a.aussen
    for screenid in pairs(kleine_anzeigen) do
        gpu.bind(screenid)
        gpu.setResolution(32, 16)
    end
    a.stargate()
end

function a.stargate(ausgeschaltet)
    if ausgeschaltet then
        for i = 1, 9 do
            a.aktiv[i] = false
            a.innen = a.aussen
        end
    end
    if a.aktiv[7] and a.aussen == a.innen then
        a.innen = a.wurmloch
    end
    for screenid in pairs(kleine_anzeigen) do
        gpu.bind(screenid, false)
        gpu.setForeground(a.stargatefarbe)
        gpu.setBackground(a.aussen)
        for _, v in pairs(a.s.a) do
            gpu.set(v[1], v[2], v[3])
        end
        gpu.setBackground(a.innen)
        for _, v in pairs(a.s.i) do
            gpu.set(v[1], v[2], v[3])
        end
        for chevron in pairs(a.aktiv) do
            a.zeig_chevron(chevron, a.aktiv[chevron])
        end
    end
end

function a.zeig_chevron(chevron, aktiv)
    if aktiv then
        gpu.setForeground(a.chevron_an)
    else
        gpu.setForeground(a.chevron_aus)
    end
    a[chevron](aktiv)
    a.aktiv[chevron] = aktiv
end

function a.iris(geschlossen)
    if geschlossen then
        a.innen = a.irisfarbe
    elseif not a.aktiv[1] then
        a.stargate(true)
        return
    else
        a.innen = a.aussen
    end
    a.stargate()
end

a.init()

-------------------------------------------------------

os.sleep(5)

local anwahl = {}
anwahl[1] = 1
anwahl[2] = 2
anwahl[3] = 3
anwahl[4] = 4
anwahl[5] = 5
anwahl[6] = 6
--anwahl[7] = 8
--anwahl[8] = 9
anwahl[9] = 7

for _, i in pairs(anwahl) do
    a.aktiv[i] = true
    os.sleep(1)
    a.stargate()
end

os.sleep(10)
a.iris(true)

os.sleep(10)
a.iris(false)

os.sleep(10)
a.stargate(true)

os.sleep(30)

os.execute("shutdown")

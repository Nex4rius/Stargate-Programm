fs = require("filesystem")
fs.makeDirectory("/stargate")
os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/autorun.lua' autorun.lua")
print("")
os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/check.lua' stargate/check.lua")
print("")
os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/control.lua' stargate/control.lua")
print("")
os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/compat.lua' stargate/compat.lua")
print("")
os.execute("wget -f 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/config.lua' stargate/config.lua")
print("")
os.execute("wget 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/addresses.lua' stargate/addresses.lua")
print("")
os.execute("wget 'https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/test/stargate/saveAfterReboot.lua' stargate/saveAfterReboot.lua")
print("")
os.execute("del -v this.lua")
print("")
install = true
os.execute("autorun.lua")

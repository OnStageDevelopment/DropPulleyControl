if not fs.exists("startup.lua") then
    local startfile = fs.open("starup.lua","w")
    local request = http.get("https://raw.githubusercontent.com/OnStageDevelopment/DropPulleyControl/main/startup.lua")
    startfile.write(request.readAll())
    startfile.close()
    request.close()
    os.reboot()
end

updatercode = http.get("https://raw.githubusercontent.com/OnStageDevelopment/DropPulleyControl/main/updater.lua")
ingested = updatercode.readAll()
updater_file = fs.open("updater.lua","w")
updater_file.write(ingested)
updater_file.close()
updatercode.close()

shell.run("updater.lua")
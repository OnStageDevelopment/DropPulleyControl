updatercode = http.get("https://raw.githubusercontent.com/OnStageDevelopment/DropPulleyControl/main/startup.lua")
ingested = updatercode.readAll()
updater_file = fs.open("updater.lua","w")
updater_file.write(ingested)
updater_file.close()
updatercode.close()

shell.run("updater.lua")
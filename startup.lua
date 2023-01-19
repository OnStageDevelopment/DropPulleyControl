updatercode = http.get("https://raw.githubusercontent.com/OnStageDevelopment/DropPulleyControl/main/updater.lua")
ingested = updatercode.readAll()
updater_file = fs.open("updater.lua","w")
updater_file.write(ingested)
updater_file.close()
updatercode.close()

shell.run("updater.lua")
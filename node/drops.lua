peripheral.find("modem", rednet.open)  --Finds Attached Modem and opens it ready for Rednet.
local motor = peripheral.find("electric_motor") --Defines Motor
json = require "libs/json" --Loads JSON Lib 

-- Startup Assignments
motor.stop() -- Sets motor to 0
reverse_speed = "false"

local function translate_speed(speed)  --Accounts for the positioning of the motors on the drop pulleys to adjust to negative to achieve same rotation direction
    if reverse_speed == "true" then
        local new_speed = -speed
        return new_speed
    end
    return speed
end

local function config_reader(config_file)  --Decodes config JSON file and sets variables for program to run
    local todecode = fs.open(config_file, "r").readAll()
    local decoded = json.decode(todecode)
    -- Assigns json info to LUA variables
    node_network = decoded["network"]
    node_type = decoded["type"]
    node_id = decoded["id"]
    dead_in = decoded["dead_in"]
    dead_out = decoded["dead_out"]
    complete_out = decoded["complete_out"]
    local reversed = decoded["reversed"]
    default_speed = decoded["default_speed"]
    -- Sets reverse variable if needed
    if reversed == "true" then
        reverse_speed = "true"
    end
    node_protocol = node_network.."."..node_type
    return "Config Loaded!"
end

local function command_handler(cmd) -- Decodes the rednet message and returns the seperated variables
    local decoded = json.decode(cmd)
    local cmd_id = decoded["id"]
    local cmd_command = decoded["command"]
    local cmd_speed = decoded["speed"]
    local cmd_distance = decoded["distance"]
    return {cmd_id,cmd_command,cmd_speed,cmd_distance}
end

local function command_logic_process(cmd) -- Determins if command is meant for this node
    if cmd == node_id or cmd == "*" then
        return true
    else
        return nil
    end
end

local function move(amount,direction,gospeed) -- Function to move the drop the correct amount of blocks at speed
    if amount == nil then
        return nil
    end
    if direction == nil then
        return nil
    end
    gospeed = translate_speed(gospeed)
    if direction == "in" then
        translated_speed = -gospeed
    elseif direction == "out" then
        translated_speed = gospeed
    end
    sleep(motor.translate(amount,translated_speed))
    motor.stop()
end

local function pos_file_util(cmd,pos) -- Handles writing the new drop position and getting the current drop position
    
    if cmd == "get" then
        local pos_file = fs.open("curr_pos.txt","r")
        local res = tonumber(pos_file.readAll())
        pos_file.close()
        return res
    elseif cmd == "set" then
        local pos_file = fs.open("curr_pos.txt","w")
        pos_file.write(pos)
        pos_file.close()
        return true
    else
        return nil
    end
end

local function calc_pos(wanted_pos) --Calculate how many blocks the node needs to move to get to requested position
    current_pos = pos_file_util("get")
    if current_pos == wanted_pos then
        direction = "none"
        amt = 0
    end
    if current_pos > wanted_pos then
        direction = "out"
        amt = current_pos-wanted_pos
    elseif current_pos < wanted_pos then
        direction = "in"
        amt = wanted_pos-current_pos
    end


    return {amt,direction}
end

local function check_custom(custom_pos) --Check if the custom drop height is valid
    if custom_pos < complete_out then
        return nil
    elseif custom_pos > dead_in then
        return nil
    else
        return "true"
    end
end


-- Start 

print(config_reader("config.json"))  -- Loads Config
rednet.host(node_protocol,"NODE:"..tostring(node_id)) -- Hosts node on the rednet network for lookup
os.setComputerLabel("ONLINE: "..node_protocol.." as ID: "..node_id)
print("\nNode Running on Protocol: "..node_protocol.."\nAs Node ID: "..tostring(node_id))

-- Node should be ready for commands now
while true do
    local senderId, command, protocol = rednet.receive(node_protocol) -- Waits for Rednet command with the node protocol
    local cmd_res = command_handler(command) -- Decodes JSON info from recieved command
    if command_logic_process(cmd_res[1]) then
        print("New command recieved from: "..senderId)
        if cmd_res[3] then
            move_speed = cmd_res[3]
        else
            move_speed = default_speed
        end
        if cmd_res[2] == "dead_in" then
            local calcs = calc_pos(dead_in)
            move(calcs[1],calcs[2],move_speed)
            pos_file_util("set",dead_in)

        elseif cmd_res[2] == "dead_out" then
            local calcs = calc_pos(dead_out)
            move(calcs[1],calcs[2],move_speed)
            pos_file_util("set",dead_out)

        elseif cmd_res[2] == "complete_out" then
            local calcs = calc_pos(complete_out)
            move(calcs[1],calcs[2],move_speed)
            pos_file_util("set",complete_out)

        elseif cmd_res[2] == "custom" then
            if check_custom(cmd_res[4]) == "true" then
                local calcs = calc_pos(cmd_res[4])
                move(calcs[1],calcs[2],move_speed)
                pos_file_util("set",cmd_res[4])
            end
        elseif cmd_res[2] == "reboot" then
            print("Restarting by request")
            rednet.unhost(node_protocol)
            os.setComputerLabel("OFFLINE")
            os.reboot()
            
        end
    end

    

    
end




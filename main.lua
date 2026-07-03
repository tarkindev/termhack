local puzzles = require("puzzles")
local engine  = require("engine")

function Wait(t) 
    local start = os.time() 
    repeat until os.time() > start + t
end

function Write_Console(txt)
    io.write(txt)
    Wait(0.4)
end

local function manualMode()
    for index, value in ipairs(puzzles) do
        if index ~= #puzzles then
            print("[".. tostring(index).. "]: ".. value.Title.. "\n")
        else
            print("[".. tostring(index).. "]: ".. value.Title)
        end
    end
    Write_Console("Please enter the desired puzzle [number]: ")
    local puzzle = tonumber(io.read("l"))
    if puzzles[puzzle] then
        local unformated_puzzle = puzzles[puzzle]
        engine:load_node(unformated_puzzle)
        local result = engine:present_node(unformated_puzzle.Title)
        Write_Console("Would you like to try another puzzle? [y/n]: ")
        local mode = io.read("l")

        if mode == "y" then manualMode() end
    else
        Write_Console("Invalid puzzle.")
    end
end

local function main()
    Write_Console("Welcome to termhack, a terminal hacking simulator made and ran with lua.\n")
    Write_Console("------------------------------------------------------------------------------\n")
    Write_Console("You will now have a couple options to edit your game.\n")
    Write_Console("Would you like to enter manual mode, where you are able to select your desired puzzle? [y/n]:  ")
    local mode = io.read("l")
    if mode == "y" then
        Write_Console("Welcome to manual mode. Here is the list of puzzles.\n")
        manualMode()
    elseif mode == "n" then
        Write_Console("You have selected the regular mode of the game. You'll go through every puzzle in a random order.\n")
        local index = 1
        while #puzzles ~= 0 do
            local puzzle = puzzles[index]
            engine:load_node(puzzle)
            local result = engine:present_node(puzzle.Title)

            table.remove(puzzles, index)

            if not result then 
                engine:game_over()
                return
            end

            index = index + 1
        end
        engine:win_game()
    else
        print(mode.. " is not a valid answer, please type y or n.")
    end
end

main()
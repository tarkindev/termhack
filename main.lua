local ui       = require("ui")
local puzzles  = require("puzzles")
local engine   = require("engine")

local function manualMode()
    ui.write("\n")
    ui.node_map(puzzles, engine.CompletedTitles, nil)
    ui.write("\n")

    for index, value in ipairs(puzzles) do
        local marker = engine.CompletedTitles[value.Title] and ui.c(ui.BRIGHT_GREEN, "[X]") or ui.c(ui.GRAY, "[ ]")
        ui.line(string.format("%s [%d]: %s", marker, index, value.Title))
    end
    ui.write("\n")

    local input = ui.prompt("Please enter the desired puzzle [number]: ", ui.CYAN, ui.BRIGHT_GREEN)
    local puzzle_index = tonumber(input)

    if puzzles[puzzle_index] then
        local chosen = puzzles[puzzle_index]
        engine:load_node(chosen)
        engine:present_node(chosen.Title)

        local again = ui.prompt("Would you like to try another puzzle? [y/n]: ", ui.CYAN, ui.BRIGHT_GREEN)
        if again == "y" then manualMode() end
    else
        ui.line("Invalid puzzle.", ui.RED)
        manualMode()
    end
end

local function storyMode()
    local remaining = {}
    for _, p in ipairs(puzzles) do remaining[#remaining+1] = p end
    math.randomseed(os.time())

    while #remaining ~= 0 do
        ui.write("\n")
        ui.node_map(puzzles, engine.CompletedTitles, nil)
        ui.write("\n")

        local index = math.random(1, #remaining)
        local puzzle = remaining[1]
        engine:load_node(puzzle)
        local result = engine:present_node(puzzle.Title)

        table.remove(remaining, 1)

        if not result then
            engine:game_over()
            return
        end
    end
    engine:win_game()
end

local function main()
    ui.banner()
    ui.write("\n")
    ui.line("You will now have a couple options to edit your game.", ui.WHITE)
    local mode = ui.prompt(
        "Would you like to enter manual mode, where you are able to select your desired puzzle? [y/n]: ",
        ui.CYAN, ui.BRIGHT_GREEN)

    if mode == "y" then
        ui.line("Welcome to manual mode. Here is the list of puzzles.", ui.WHITE)
        manualMode()
    elseif mode == "n" then
        ui.line("You have selected the regular mode of the game. You'll go through every puzzle in order.", ui.WHITE)
        storyMode()
    else
        ui.line(mode .. " is not a valid answer, please type y or n.", ui.RED)
    end
end

main()
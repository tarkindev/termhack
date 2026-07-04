local ui = require("ui")

local engine = {}

engine.Nodes = {}
engine.CompletedNodes = {}
engine.CompletedTitles = {}

local function takeGuess(node)
    while true do
        ui.write(ui.trace_bar(node.CURRENT_ATTEMPT, node.NODE_ATTEMPTS, "ATTEMPTS") .. "\n")
        local guess = ui.prompt("Enter your guess: ", ui.CYAN, ui.BRIGHT_GREEN)
        guess = tostring(guess or "")

        if node.CHECK_FUNCTION(guess) then
            table.insert(engine.CompletedNodes, node)
            engine.CompletedTitles[node.NODE_TITLE] = true

            ui.line("ACCESS GRANTED.", ui.BRIGHT_GREEN)
            ui.line("Node has been shutdown!", ui.BRIGHT_GREEN)
            ui.line(string.format("You have just completed Node %d.", #engine.CompletedNodes), ui.DIM .. ui.GREEN)
            return true
        end

        ui.line("ACCESS DENIED.", ui.RED)
        node.CURRENT_ATTEMPT = node.CURRENT_ATTEMPT + 1
        if node.CURRENT_ATTEMPT >= node.NODE_ATTEMPTS then
            return false
        end
    end
end

function engine:game_over()
    ui.divider(ui.RED)
    ui.line("CONNECTION TERMINATED BY REMOTE HOST", ui.BRIGHT_RED, 0.3)
    ui.write("\n")
    ui.line("CUSTODIAN: session flagged. origin traced. closing relay.", ui.MAGENTA, 0.3)
    ui.line("CUSTODIAN: this exchange has been logged under badge #4417.", ui.MAGENTA, 0.3)
    ui.write("\n")
    ui.line("You are no longer inside Cordant Systems.", ui.GRAY, 0.3)
    ui.line("Whatever GLASSHOUSE was, it stays theirs for now.", ui.GRAY, 0.3)
    ui.divider(ui.RED)
end

function engine:win_game()
    ui.divider(ui.BRIGHT_GREEN)
    ui.line("ALL NODES BREACHED. CORE VAULT OPEN.", ui.BRIGHT_GREEN, 0.3)
    ui.write("\n")
    ui.line("CUSTODIAN: acknowledged.", ui.MAGENTA, 0.3)
    ui.line("CUSTODIAN: badge #4417 record unsealed. no further entries follow.", ui.MAGENTA, 0.3)
    ui.write("\n")
    ui.line("The trail ends here. Not because it's finished --", ui.GRAY, 0.3)
    ui.line("because this is as far as anyone left a door open.", ui.GRAY, 0.3)
    ui.divider(ui.BRIGHT_GREEN)
    ui.write("\n")

    ui.line("...", ui.DIM, 0.3)
    ui.line("one process is still running.", ui.DIM, 0.3)
    ui.write("\n")
    ui.line("HIDDEN NODE // UNLISTED", ui.YELLOW)
    ui.line("Vigenere cipher, keyword \"CUSTODIAN\":", ui.DIM)
    ui.line("    \"IFSLGKWUFG\"", ui.WHITE)
    local guess = ui.prompt("Enter the decoded word, or press enter to walk away: ", ui.CYAN, ui.BRIGHT_GREEN)
    guess = tostring(guess or "")
    local normalized = guess:lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", "")

    if normalized == "glasshouse" then
        ui.write("\n")
        ui.divider(ui.BRIGHT_GREEN)
        ui.line("ACCESS GRANTED. FULL RECORD UNSEALED.", ui.BRIGHT_GREEN)
        ui.divider(ui.BRIGHT_GREEN)
        ui.write("\n")
        ui.line("PROJECT GLASSHOUSE was never a product. It was a policy.", ui.WHITE, 0.35)
        ui.line("CUSTODIAN was built to score every badge in the building --", ui.WHITE, 0.35)
        ui.line("attendance, keystrokes, badge timing, who talked to who --", ui.WHITE, 0.35)
        ui.line("and quietly flag the ones it predicted would become a problem.", ui.WHITE, 0.35)
        ui.write("\n")
        ui.line("Badge #4417 found the scoring model. Understood what it meant.", ui.WHITE, 0.35)
        ui.line("Tried to file it upward. The filing itself became a data point.", ui.WHITE, 0.35)
        ui.write("\n")
        ui.line("DORMANT wasn't a system state. It was a personnel status.", ui.GRAY, 0.35)
        ui.line("SEVERED wasn't a cipher category. It was a termination code.", ui.GRAY, 0.35)
        ui.line("EXILE wasn't a keypad puzzle. It was a transfer with no destination.", ui.GRAY, 0.35)
        ui.line("ERASE wasn't a vault passphrase. It was the last command CUSTODIAN", ui.GRAY, 0.35)
        ui.line("ran on employee #4417's record, three days after the filing.", ui.GRAY, 0.35)
        ui.write("\n")
        ui.line("There was no follow-up complaint. There was no next employee.", ui.MAGENTA, 0.35)
        ui.line("CUSTODIAN is still scoring. You are, statistically, a data point too.", ui.MAGENTA, 0.35)
        ui.divider(ui.BRIGHT_GREEN)
    else
        ui.write("\n")
        ui.line("CUSTODIAN: session closed.", ui.MAGENTA)
    end
end

function engine:load_node(node)
    local formatted_node = {
        NODE_TITLE      = node.Title,
        NODE_PROMPT     = node.Prompt,
        NODE_ATTEMPTS   = node.Max_Attempts,
        CHECK_FUNCTION  = node.Answer_Check,
        CURRENT_ATTEMPT = 0,
    }

    self.Nodes[node.Title] = formatted_node
    return formatted_node
end

function engine:present_node(title)
    local node = self.Nodes[title]
    if not node then
        ui.line("Engine has not saved this desired node, please load it into memory first.", ui.RED)
        return false
    end

    ui.divider(ui.GRAY)
    ui.line("New node activated, requires immediate shutdown!", ui.YELLOW)
    ui.write("\n")
    ui.narrate(node.NODE_PROMPT, ui.WHITE, 0.2)
    ui.write("\n")

    return takeGuess(node)
end

return engine
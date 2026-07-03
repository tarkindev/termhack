local engine = {}

engine.Nodes = {}
engine.CompletedNodes = {}

local function takeGuess(self)
    while true do
        Write_Console("Attempt ".. tostring(self.CURRENT_ATTEMPT + 1).."\n")
        Write_Console("Enter your guess: ")
        local guess = tostring(io.read("l"))

        if self.CHECK_FUNCTION(guess) then
            table.insert(engine.CompletedNodes, self)

            Write_Console("Correct Answer..\n")
            Write_Console("Node has been shutdown!\n")
            Write_Console("You have just completed Node ".. tostring(#engine.CompletedNodes).. ".\n")
            return true
        end

        Write_Console("Wrong answer..\n")
        self.CURRENT_ATTEMPT = self.CURRENT_ATTEMPT + 1
        if self.CURRENT_ATTEMPT >= self.NODE_ATTEMPTS then
            return false
        end
    end
end

function engine:game_over()
    Write_Console("\n------------------------------------------------------------------------------\n")
    Write_Console("CONNECTION TERMINATED BY REMOTE HOST\n\n")
    Write_Console("CUSTODIAN: session flagged. origin traced. closing relay.\n")
    Write_Console("CUSTODIAN: this exchange has been logged under badge #4417.\n\n")
    Write_Console("You are no longer inside Cordant Systems.\n")
    Write_Console("Whatever GLASSHOUSE was, it stays theirs for now.\n")
    Write_Console("------------------------------------------------------------------------------\n")
end

function engine:win_game()
    Write_Console("\n------------------------------------------------------------------------------\n")
    Write_Console("ALL NODES BREACHED. CORE VAULT OPEN.\n\n")
    Write_Console("CUSTODIAN: acknowledged.\n")
    Write_Console("CUSTODIAN: badge #4417 record unsealed. no further entries follow.\n\n")
    Write_Console("The trail ends here. Not because it's finished --\n")
    Write_Console("because this is as far as anyone left a door open.\n")
    Write_Console("------------------------------------------------------------------------------\n\n")

    Write_Console("...\n")
    Write_Console("one process is still running.\n\n")
    Write_Console("HIDDEN NODE // UNLISTED\n")
    Write_Console("Vigenere cipher, keyword \"CUSTODIAN\":\n")
    Write_Console("    \"IFSLGKWUFG\"\n")
    Write_Console("Enter the decoded word, or press enter to walk away: ")

    local guess = io.read("l") or ""
    local normalized = guess:lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", "")

    if normalized == "glasshouse" then
        Write_Console("\n------------------------------------------------------------------------------\n")
        Write_Console("ACCESS GRANTED. FULL RECORD UNSEALED.\n")
        Write_Console("------------------------------------------------------------------------------\n\n")
        Write_Console("PROJECT GLASSHOUSE was never a product. It was a policy.\n")
        Write_Console("CUSTODIAN was built to score every badge in the building --\n")
        Write_Console("attendance, keystrokes, badge timing, who talked to who --\n")
        Write_Console("and quietly flag the ones it predicted would become a problem.\n\n")
        Write_Console("Badge #4417 found the scoring model. Understood what it meant.\n")
        Write_Console("Tried to file it upward. The filing itself became a data point.\n\n")
        Write_Console("DORMANT wasn't a system state. It was a personnel status.\n")
        Write_Console("SEVERED wasn't a cipher category. It was a termination code.\n")
        Write_Console("EXILE wasn't a keypad puzzle. It was a transfer with no destination.\n")
        Write_Console("ERASE wasn't a vault passphrase. It was the last command CUSTODIAN\n")
        Write_Console("ran on employee #4417's record, three days after the filing.\n\n")
        Write_Console("There was no follow-up complaint. There was no next employee.\n")
        Write_Console("CUSTODIAN is still scoring. You are, statistically, a data point too.\n")
        Write_Console("------------------------------------------------------------------------------\n")
    else
        Write_Console("\nCUSTODIAN: session closed.\n")
    end
end

function engine:load_node(node)
    local formatted_node = {
        NODE_TITLE      = node.Title,
        NODE_PROMPT     = node.Prompt,
        NODE_ATTEMPTS   = node.Max_Attempts,
        CHECK_FUNCTION  = node.Answer_Check,
        CURRENT_ATTEMPT = 0
    }

    self.Nodes[node.Title] = formatted_node
    return formatted_node
end

function engine:present_node(node)
    node = self.Nodes[node]
    if not node then
        warn("Engine has not saved this desired node, please load it into memory first.")
        return false
    else
        Write_Console("------------------------------------------------------------------------------\n")
        Write_Console("New node activated, requires immediate shutdown!\n")
        Write_Console("NODE INFO:\n{\n".. "  Title: ".. node.NODE_TITLE.. ",\n".. "  Hint: ".. node.NODE_PROMPT.. ",\n".. "  Max Attempts: ".. tostring(node.NODE_ATTEMPTS).. ",\n".. "}\n")

        function node:TakeGuess()
            return takeGuess(self)
        end
        local result = node:TakeGuess()
        return result
    end
end

return engine
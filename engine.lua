local engine = {}

engine.Nodes = {}
engine.CompletedNodes = {}

local function takeGuess(self)
    Write_Console("Attempt ".. tostring(self.CURRENT_ATTEMPT + 1).."\n")
    Write_Console("Enter your guess: ")
    local guess = tostring(io.read("l"))

    if self.CHECK_FUNCTION(guess) then
        table.insert(engine.CompletedNodes, self)

        Write_Console("Correct Answer..\n")
        Write_Console("Node has been shutdown!\n")
        Write_Console("You have just completed Node ".. tostring(#engine.CompletedNodes).. ".\n")
        return true
    else
        Write_Console("Wrong answer..\n")
        self.CURRENT_ATTEMPT = self.CURRENT_ATTEMPT + 1
        if self.CURRENT_ATTEMPT >= self.NODE_ATTEMPTS then
            return false
        else
            takeGuess(self)
        end
    end
end

function engine:game_over()
    Write_Console("GAME OVER!")
end

function engine:win_game()
    Write_Console("WON THE GAME!")
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
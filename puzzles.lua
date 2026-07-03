-- Puzzles storage
-- Yes, you can technically check here for all the answers
-- You're lame if you do
-- get out bro you're hella annoying

local function normalize(s)
    return s:lower():gsub("^%s+", ""):gsub("%s+$", "")
end

local puzzles = {}

table.insert(puzzles, {
    Title = "BINARY GATE",
    Prompt = "Gate expects an 8-bit ASCII code:\n    01001011 01000101 01011001\nDecode the binary to ASCII and enter the resulting word.",
    Max_Attempts = 4,
    Answer_Check = function(guess)
        return normalize(guess) == "key"
    end,
})

table.insert(puzzles, {
    Title = "PERIMETER LOCK",
    Prompt = "Encrypted keycode intercepted (Caesar shift 3):\n    \"ILUHZDOO\"\nDecrypt it and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(guess)
        return normalize(guess) == "firewall"
    end,
})

table.insert(puzzles, {
    Title = "DECODE PROTOCOL",
    Prompt = "System log uses leetspeak substitution:\n    \"5Y5T3M\"\nDecode it and enter the plaintext word.",
    Max_Attempts = 3,
    Answer_Check = function(guess)
        return normalize(guess) == "system"
    end,
})

table.insert(puzzles, {
    Title = "CIPHER GATE",
    Prompt = "Each number is a letter's position in the alphabet (A=1, B=2...):\n    5-24-9-20\nDecode the sequence and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(guess)
        return normalize(guess) == "exit"
    end,
})

table.insert(puzzles, {
    Title = "SEQUENCE LATCH",
    Prompt = "Latch requires the next number in the sequence:\n    3, 5, 8, 13, 21, ?\nEnter the next number.",
    Max_Attempts = 3,
    Answer_Check = function(guess)
        return tonumber(guess) == 34
    end,
})

table.insert(puzzles, {
    Title = "CORE VAULT",
    Prompt = "Final lock. Take the first letter of each previous node's answer,\nin the order you solved them, and concatenate them:\n    (key, firewall, system, exit)\nEnter the resulting 4-character passphrase.",
    Max_Attempts = 5,
    Answer_Check = function(guess)
        return normalize(guess) == "kfse"
    end,
})

return puzzles
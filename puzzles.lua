local function normalize(s)
    return s:lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", "")
end

local puzzles = {}

-- ACT I :: OUTER PERIMETER

table.insert(puzzles, {
    Title = "OUTER GATE",
    Prompt = "SESSION LOG // CORDANT SYSTEMS // PUBLIC RELAY\nUnattended terminal. No badge required at this depth.\n\nGate expects an 8-bit ASCII code:\n    01000001 01000011 01000011 01000101 01010011 01010011\nDecode the binary and enter the resulting word.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "access" end,
})

table.insert(puzzles, {
    Title = "SIGNAL RELAY",
    Prompt = "SESSION LOG // relay uptime: 1142 days, no maintenance ticket filed.\n\nRelay keycode, Caesar shift 4:\n    \"WMKREP\"\nDecrypt it and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "signal" end,
})

table.insert(puzzles, {
    Title = "STATIC ARCHIVE",
    Prompt = "SESSION LOG // archive index reports 1 fewer file than it did yesterday.\n\nArchive lock uses a mirrored alphabet (A<->Z, B<->Y, ...):\n    \"SLOOLD\"\nDecrypt it and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "hollow" end,
})

table.insert(puzzles, {
    Title = "VECTOR LOCK",
    Prompt = "SESSION LOG // routing table last edited by a user account that was deleted six months ago.\n\nEach number is a letter's position in the alphabet (A=1, B=2...):\n    22-5-3-20-15-18\nDecode the sequence and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "vector" end,
})

table.insert(puzzles, {
    Title = "WITNESS LOG",
    Prompt = "SESSION LOG // this entry was flagged for review and never reviewed.\n\nThe field agent's note was filed backwards, on purpose or by habit:\n    \"SSENTIW\"\nEnter the word, forwards.",
    Max_Attempts = 3,
    Answer_Check = function(g) return normalize(g) == "witness" end,
})

table.insert(puzzles, {
    Title = "HEADCOUNT AUDIT",
    Prompt = "SESSION LOG // HR export, quarter close.\nActive badges at quarter start: 84.\n19 were reassigned to an undisclosed subsidiary.\n7 were terminated.\n3 new badges were issued.\n\nEnter the number of active badges remaining.",
    Max_Attempts = 3,
    Answer_Check = function(g) return tonumber(g) == 61 end,
})

-- ACT II :: INTERNAL NETWORK

table.insert(puzzles, {
    Title = "ECHO CHAMBER",
    Prompt = "SESSION LOG // internal chat export, timestamps redacted.\nSomeone kept replying to a thread no one else could see.\n\nLeetspeak substitution:\n    \"3CH0\"\nDecode it and enter the plaintext word.",
    Max_Attempts = 3,
    Answer_Check = function(g) return normalize(g) == "echo" end,
})

table.insert(puzzles, {
    Title = "PROJECT GLASSHOUSE // FILE 1",
    Prompt = "SESSION LOG // file header intact, body 90% blacked out.\nWhat remains: \"...GLASSHOUSE was never meant to be read by...\"\n\nVigenere cipher, keyword \"GHOST\":\n    \"XLRSVZLR\"\nDecode it and enter the plaintext word.",
    Max_Attempts = 5,
    Answer_Check = function(g) return normalize(g) == "redacted" end,
})

table.insert(puzzles, {
    Title = "LEGACY LINE",
    Prompt = "SESSION LOG // this line still uses hardware from before the merger.\n\nMorse code:\n    .- -. --- -- .- .-.. -.--\nDecode it and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "anomaly" end,
})

table.insert(puzzles, {
    Title = "PERSONNEL FILE // #4417",
    Prompt = "SESSION LOG // employee record, photo missing, next-of-kin field empty.\n\nCaesar shift 13:\n    \"FHOWRPG\"\nDecrypt it and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "subject" end,
})

table.insert(puzzles, {
    Title = "OLD PHONE LINE",
    Prompt = "SESSION LOG // a landline extension still rings. No one has picked up in years.\n\nKeypad multi-tap (2=ABC, 3=DEF, 4=GHI, 5=JKL, 6=MNO, 7=PQRS, 8=TUV, 9=WXYZ):\n    33 99 444 555 33\nDecode it and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "exile" end,
})

table.insert(puzzles, {
    Title = "VAULT // LAYER 1",
    Prompt = "SESSION LOG // five fragments, one word, if you take just the first letter of each.\nCombine the first letter of the answers to:\n    ECHO CHAMBER, PROJECT GLASSHOUSE // FILE 1, LEGACY LINE, PERSONNEL FILE // #4417, OLD PHONE LINE\nin that exact order. Enter the resulting word.",
    Max_Attempts = 5,
    Answer_Check = function(g) return normalize(g) == "erase" end,
})

-- ACT III :: RESTRICTED ARCHIVES

table.insert(puzzles, {
    Title = "PHYSICAL LAYER",
    Prompt = "SESSION LOG // internal security used the keyboard layout itself as a cipher key.\nSomeone was in a hurry, or didn't expect anyone to look this deep.\n\nSubstitution key (plain -> cipher):\n    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z\n    Q W E R T Y U I O P A S D F G H J K L Z X C V B N M\n\nEncoded word:\n    \"RGKDQFZ\"\nDecrypt it and enter the plaintext word.",
    Max_Attempts = 5,
    Answer_Check = function(g) return normalize(g) == "dormant" end,
})

table.insert(puzzles, {
    Title = "TWO-STATE RECORD",
    Prompt = "SESSION LOG // archived under a naming convention that predates the current system.\n\nBaconian cipher (A/B blocks of 5, unique per letter):\n    A=AAAAA B=AAAAB C=AAABA D=AAABB E=AABAA F=AABAB G=AABBA H=AABBB\n    I=ABAAA J=ABAAB K=ABABA L=ABABB M=ABBAA N=ABBAB O=ABBBA P=ABBBB\n    Q=BAAAA R=BAAAB S=BAABA T=BAABB U=BABAA V=BABAB W=BABBA X=BABBB\n    Y=BBAAA Z=BBAAB\n\nEncoded word:\n    \"BAABA AABAA BABAB AABAA BAAAB AABAA AAABB\"\nDecrypt it and enter the plaintext word.",
    Max_Attempts = 5,
    Answer_Check = function(g) return normalize(g) == "severed" end,
})

table.insert(puzzles, {
    Title = "SPLIT ROUTE",
    Prompt = "SESSION LOG // the packet took two paths and arrived out of order.\n\nRail fence cipher, 2 rails (odd-position letters first, then even-position letters):\n    \"FAMNRGET\"\nDecrypt it and enter the plaintext word.",
    Max_Attempts = 5,
    Answer_Check = function(g) return normalize(g) == "fragment" end,
})

table.insert(puzzles, {
    Title = "CHECK DIGIT",
    Prompt = "SESSION LOG // a whiteboard photo, four characters visible: \"CORE\"\nCorporate security used raw ASCII decimal values as a check digit.\n\nSum the ASCII value of each character and enter the total.",
    Max_Attempts = 3,
    Answer_Check = function(g) return tonumber(g) == 297 end,
})

table.insert(puzzles, {
    Title = "SOMETHING IN THE HALL",
    Prompt = "SESSION LOG // unattributed note, found taped inside a server rack.\n\n\"I have no body, yet I follow you into every room.\nTurn on the light and I retreat. Turn it off and I return, stronger.\nWhat am I?\"\n\nEnter the answer.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "shadow" end,
})

table.insert(puzzles, {
    Title = "LAST KNOWN ACTIVITY",
    Prompt = "SESSION LOG // badge #4417, final entries.\nLast access log: day 227 of the fiscal calendar.\nBadge flagged inactive exactly 19 days later.\n\nEnter the fiscal day number the flag was set.",
    Max_Attempts = 3,
    Answer_Check = function(g) return tonumber(g) == 246 end,
})

-- ACT IV :: SUBLEVEL // CORE

table.insert(puzzles, {
    Title = "SUBLEVEL DOOR",
    Prompt = "SESSION LOG // no badge on record has opened this door in three years.\n\nHex-encoded ASCII:\n    54 48 52 45 53 48 4F 4C 44\nDecode it and enter the plaintext word.",
    Max_Attempts = 4,
    Answer_Check = function(g) return normalize(g) == "threshold" end,
})

table.insert(puzzles, {
    Title = "SCRAMBLED TITLE",
    Prompt = "SESSION LOG // a job title, letters out of order, found on a terminated org chart.\n\nScrambled letters:\n    \"SVROEEER\"\nUnscramble it and enter the plaintext word.",
    Max_Attempts = 5,
    Answer_Check = function(g) return normalize(g) == "overseer" end,
})

table.insert(puzzles, {
    Title = "DRIFTING SHIFT",
    Prompt = "SESSION LOG // encoding was clearly hand-modified, shift value increases with each letter.\n\nEach letter is shifted forward by its position in the word\n(1st letter +1, 2nd letter +2, 3rd letter +3, and so on):\n    \"UTXXM\"\nDecode it and enter the plaintext word.",
    Max_Attempts = 5,
    Answer_Check = function(g) return normalize(g) == "truth" end,
})

table.insert(puzzles, {
    Title = "VAULT // LAYER 2",
    Prompt = "SESSION LOG // four fragments, same rule as before.\nCombine the first letter of the answers to:\n    PHYSICAL LAYER, TWO-STATE RECORD, SPLIT ROUTE, SOMETHING IN THE HALL\nin that exact order. Enter the resulting word.",
    Max_Attempts = 5,
    Answer_Check = function(g) return normalize(g) == "dsfs" end,
})

table.insert(puzzles, {
    Title = "THE THING THAT WATCHES",
    Prompt = "SESSION LOG // every system on this network reports to something. This is its name.\n\nVigenere cipher, keyword \"MERIDIAN\":\n    \"OYJBRLINZ\"\nDecode it and enter the plaintext word.",
    Max_Attempts = 6,
    Answer_Check = function(g) return normalize(g) == "custodian" end,
})

table.insert(puzzles, {
    Title = "CORE VAULT",
    Prompt = "SESSION LOG // final lock. Whatever GLASSHOUSE was, this is as close as the record gets.\nCombine the first letter of the answers to:\n    OUTER GATE, THE THING THAT WATCHES, VAULT // LAYER 1, PHYSICAL LAYER\nin that exact order. Enter the resulting word.",
    Max_Attempts = 6,
    Answer_Check = function(g) return normalize(g) == "aced" end,
})

return puzzles
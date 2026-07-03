local ui = {}

-- ===== color codes =====

ui.RESET   = "\27[0m"
ui.BOLD    = "\27[1m"
ui.DIM     = "\27[2m"

ui.GREEN        = "\27[32m"
ui.BRIGHT_GREEN = "\27[92m"
ui.RED          = "\27[31m"
ui.BRIGHT_RED   = "\27[91m"
ui.YELLOW       = "\27[33m"
ui.CYAN         = "\27[36m"
ui.MAGENTA      = "\27[35m"
ui.GRAY         = "\27[90m"
ui.WHITE        = "\27[97m"

function ui.c(color, text)
    return color .. text .. ui.RESET
end

-- ===== output =====

function ui.write(text)
    io.write(text)
    io.flush()
end

function ui.line(text, color)
    if color then
        ui.write(ui.c(color, text))
    else
        ui.write(text)
    end
    ui.write("\n")
end

function ui.prompt(label, label_color, input_color)
    ui.write(ui.c(label_color or ui.CYAN, label))
    ui.write(input_color or ui.BRIGHT_GREEN)
    local result = io.read("l")
    ui.write(ui.RESET)
    return result
end

-- ===== structural elements =====

function ui.divider(color)
    ui.line(string.rep("-", 78), color or ui.GRAY)
end

function ui.box_divider(color)
    ui.line(string.rep("\226\148\128", 78), color or ui.GRAY) -- ─
end

-- ===== banner =====

local BANNER_WIDTH = 76

local function banner_row(text, color)
    local padding = string.rep(" ", BANNER_WIDTH - #text)
    return ui.GRAY .. "\226\148\130" .. ui.RESET  -- │
        .. ui.c(color, text)
        .. ui.GRAY .. padding .. "\226\148\130" .. ui.RESET -- padding + │
end

function ui.banner()
    local top    = "\226\148\140" .. string.rep("\226\148\128", BANNER_WIDTH) .. "\226\148\144" -- ┌───...───┐
    local bottom = "\226\148\148" .. string.rep("\226\148\128", BANNER_WIDTH) .. "\226\148\152" -- └───...───┘

    ui.line(top, ui.GRAY)
    ui.line(banner_row("  CORDANT SYSTEMS // REMOTE ACCESS TERMINAL", ui.BRIGHT_GREEN))
    ui.line(banner_row("  unauthorized access is logged. someone is always watching.", ui.DIM .. ui.GRAY))
    ui.line(bottom, ui.GRAY)
end

-- ===== trace bar =====

function ui.trace_bar(level, max, label)
    label = label or "TRACE"
    local filled = level
    local empty = max - level
    local color
    local ratio = level / max
    if ratio >= 0.8 then
        color = ui.BRIGHT_RED
    elseif ratio >= 0.4 then
        color = ui.YELLOW
    else
        color = ui.GREEN
    end

    local bar = ui.c(color, string.rep("\226\150\136", filled)) -- █
        .. ui.c(ui.GRAY, string.rep("\226\150\145", empty))     -- ░

    return string.format("%s%s%s [%s] %d/%d", ui.DIM, label, ui.RESET, bar, level, max)
end

-- ===== node map =====

function ui.node_map(nodes, completed, current_index)
    local acts = {
        { name = "ACT I  // OUTER PERIMETER",   from = 1,  to = 6  },
        { name = "ACT II // INTERNAL NETWORK",  from = 7,  to = 12 },
        { name = "ACT III// RESTRICTED ARCHIVE",from = 13, to = 18 },
        { name = "ACT IV // SUBLEVEL / CORE",   from = 19, to = 24 },
    }

    for _, act in ipairs(acts) do
        ui.write(ui.c(ui.DIM .. ui.CYAN, act.name) .. "\n")
        local row = {}
        for i = act.from, act.to do
            local node = nodes[i]
            if not node then goto continue end
            local cell
            if current_index == i then
                cell = ui.c(ui.YELLOW, string.format("[>%02d]", i))
            elseif completed[node.Title] then
                cell = ui.c(ui.BRIGHT_GREEN, string.format("[X%02d]", i))
            else
                cell = ui.c(ui.GRAY, string.format("[ %02d]", i))
            end
            row[#row+1] = cell
            ::continue::
        end
        ui.write(table.concat(row, " \226\148\128 ") .. "\n\n") 
    end
    ui.write(ui.c(ui.GRAY, "  [X] breached   [ ] locked   [>] current node") .. "\n")
end

return ui
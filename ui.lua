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

function ui.line(text, color, delay)
    if color then
        ui.write(ui.c(color, text))
    else
        ui.write(text)
    end
    ui.write("\n")
    if delay then ui.sleep(delay) end
end

function ui.sleep(seconds)
    local start = os.clock()
    while os.clock() - start < seconds do end
end

function ui.narrate(text, color, delay)
    delay = delay or 0.16
    for line in text:gmatch("[^\n]*") do
        ui.line(line, color, delay)
    end
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

-- ===== corruption / glitch helpers =====

local COMBINING_MARKS = {
    utf8.char(0x0301), utf8.char(0x0330), utf8.char(0x0335), utf8.char(0x0338),
}

local function hash01(n)
    local h = (n * 2654435761) % 4294967296
    return h / 4294967296
end

local function corrupt_text(text, level, seed_offset)
    if level <= 0 then return text end
    local out = {}
    for i = 1, #text do
        local ch = text:sub(i, i)
        out[#out+1] = ch
        local roll = hash01(i * 97 + (seed_offset or 0))
        if roll < level * 0.12 then
            out[#out+1] = COMBINING_MARKS[(i % #COMBINING_MARKS) + 1]
        end
    end
    return table.concat(out)
end

local SEP_BY_LEVEL = {
    [0] = " " .. utf8.char(0x2500) .. " ",                    -- " ─ "
    [1] = " " .. utf8.char(0x2592) .. " ",                    -- " ▒ "
    [2] = utf8.char(0x2591) .. utf8.char(0x2593) .. utf8.char(0x2591), -- "░▓░"
    [3] = utf8.char(0x2593) .. utf8.char(0x2715) .. utf8.char(0x2593), -- "▓✕▓"
}

local SLASH_BY_LEVEL = {
    [0] = { "/", "\\" },
    [1] = { "/", "\\" },
    [2] = { utf8.char(0x2020), utf8.char(0x2020) },   -- † †
    [3] = { utf8.char(0x2573), utf8.char(0x2573) },   -- ╳ ╳
}

local ACT_COLOR_BY_LEVEL = { [0] = ui.CYAN, [1] = ui.CYAN, [2] = ui.MAGENTA, [3] = ui.BRIGHT_RED }

-- ===== diamond node map =====

local CELL_W = 5 -- "[X01]"

local function status_cell(index, completed, current_index)
    if current_index == index then
        return ui.c(ui.YELLOW, string.format("[>%02d]", index))
    elseif completed then
        return ui.c(ui.BRIGHT_GREEN, string.format("[X%02d]", index))
    else
        return ui.c(ui.GRAY, string.format("[ %02d]", index))
    end
end

local function render_diamond_act(nodes, completed, current_index, start_idx, level)
    local rows = {
        { start_idx },
        { start_idx + 1, start_idx + 2 },
        { start_idx + 3, start_idx + 4 },
        { start_idx + 5 },
    }
    local sep = SEP_BY_LEVEL[level]
    local sep_visible_len = 3 

    local widths = {}
    for _, row in ipairs(rows) do
        widths[#widths+1] = #row * CELL_W + (#row - 1) * sep_visible_len
    end
    local max_w = math.max(table.unpack(widths))

    local function row_indent(row_index)
        return math.floor((max_w - widths[row_index]) / 2)
    end

    local function row_centers(row_index)
        local indent = row_indent(row_index)
        local centers = {}
        local col = indent
        for _ in ipairs(rows[row_index]) do
            centers[#centers+1] = col + math.floor(CELL_W / 2)
            col = col + CELL_W + sep_visible_len
        end
        return centers
    end

    local function plain_row(row_index)
        local cells = {}
        for _, idx in ipairs(rows[row_index]) do
            local title = nodes[idx] and nodes[idx].Title or nil
            cells[#cells+1] = status_cell(idx, title and completed[title], current_index)
        end
        return string.rep(" ", row_indent(row_index)) .. table.concat(cells, sep)
    end

    local slashes = SLASH_BY_LEVEL[level]

    local function connector_row(to_row, symbols)
        local line = {}
        for i = 1, max_w do line[i] = " " end
        for pos, c in ipairs(row_centers(to_row)) do
            line[c + 1] = symbols[pos] or symbols[1]
        end
        return table.concat(line)
    end

    ui.write(plain_row(1) .. "\n")
    ui.write(ui.c(ui.GRAY, connector_row(2, slashes)) .. "\n")
    ui.write(plain_row(2) .. "\n")
    ui.write(plain_row(3) .. "\n")
    ui.write(ui.c(ui.GRAY, connector_row(3, { slashes[2], slashes[1] })) .. "\n")
    ui.write(plain_row(4) .. "\n")
end

function ui.node_map(nodes, completed, current_index)
    local acts = {
        { name = "ACT I  // OUTER PERIMETER",    from = 1,  level = 0 },
        { name = "ACT II // INTERNAL NETWORK",   from = 7,  level = 1 },
        { name = "ACT III// RESTRICTED ARCHIVE", from = 13, level = 2 },
        { name = "ACT IV // SUBLEVEL / CORE",    from = 19, level = 3 },
    }

    for act_i, act in ipairs(acts) do
        local header = corrupt_text(act.name, act.level, act_i * 13)
        ui.line(header, ACT_COLOR_BY_LEVEL[act.level])
        render_diamond_act(nodes, completed, current_index, act.from, act.level)
        ui.write("\n")
    end
    ui.write(ui.c(ui.GRAY, "  [X] breached   [ ] locked   [>] current node") .. "\n")
end

return ui
-- local custom_solarized_dark = require'lualine.themes.solarized_light'
-- custom_solarized_dark.normal.b.bg = '#404040'
-- custom_solarized_dark.inactive.b.bg = '#505050'

local custom_theme = require'lualine.themes.ayu_mirage'
custom_theme.normal.b.bg = '#2A3A44'
-- custom_theme.inactive.b.bg = '#505050'

local function unique_filename()
  local winid = tonumber(vim.g.statusline_winid)
  local bufnr = winid and vim.api.nvim_win_is_valid(winid)
      and vim.api.nvim_win_get_buf(winid)
    or vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)

  if filename == '' then
    return '[No Name]'
  end

  if vim.bo[bufnr].buftype ~= '' then
    return vim.fn.fnamemodify(filename, ':t')
  end

  local function path_parts(path)
    return vim.split(vim.fs.normalize(path), '/', { trimempty = true })
  end

  local parts = path_parts(filename)
  local other_paths = {}
  for _, candidate in ipairs(vim.api.nvim_list_bufs()) do
    if candidate ~= bufnr and vim.api.nvim_buf_is_valid(candidate)
        and vim.bo[candidate].buflisted and vim.bo[candidate].buftype == '' then
      local other_filename = vim.api.nvim_buf_get_name(candidate)
      if other_filename ~= '' then
        table.insert(other_paths, path_parts(other_filename))
      end
    end
  end

  local depth = 1
  while depth < #parts do
    local collision = false
    for _, other_parts in ipairs(other_paths) do
      if #other_parts >= depth then
        local matches = true
        for offset = 0, depth - 1 do
          if parts[#parts - offset] ~= other_parts[#other_parts - offset] then
            matches = false
            break
          end
        end
        if matches then
          collision = true
          break
        end
      end
    end
    if not collision then
      break
    end
    depth = depth + 1
  end

  local display_name = table.concat(parts, '/', #parts - depth + 1)
  if vim.bo[bufnr].modified then
    display_name = display_name .. ' [+]'
  elseif not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
    display_name = display_name .. ' [-]'
  end
  return display_name
end

require('lualine').setup {
  extensions = { 'nvim-tree' },
  options = {
    -- theme = custom_solarized_dark,
    -- theme = custom_theme,
    icons_enabled = true,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_b = {
      {
        'diff',
        colored = true,
        diff_color = {
          added    = { fg = 'DiffAdd', bg = custom_theme.normal.b.bg },
          modified = { fg = 'DiffChange', bg = custom_theme.normal.b.bg },
          remoted  = { fg = 'DiffDelete', bg = custom_theme.normal.b.bg },
        },
      },
      'diagnostics'
    },
    lualine_c = {
      unique_filename,
      'progress',
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = {}
  },
  inactive_sections = {
    lualine_b = {
      {
        'diff',
        colored = true,
        diff_color = {
          -- Same color values as the general color option can be used here.
          added    = { fg = 'DiffAdd', bg = custom_theme.inactive.b.bg },
          modified = { fg = 'DiffChange', bg = custom_theme.inactive.b.bg },
          remoted  = { fg = 'DiffDelete', bg = custom_theme.inactive.b.bg },
        },
      },
      'diagnostics'
    },
    lualine_c = {
      unique_filename,
      'progress',
    },
    lualine_y = {}
  },
}


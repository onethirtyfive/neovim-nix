local config = {
  default_chat_agent = "ChatCopilot",
  default_command_agent = "ChatCopilot",
  providers = {
    openai = {},
    copilot = { disable = false },
  },
  agents = {
    {
      disable = false,
      provider = "copilot",
      name = "ChatCopilot",
      chat = true,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 0.6, top_p = 0.7 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "You are a general AI assistant.\n\n"
        .. "The user provided the additional info about how they would like you to respond:\n\n"
        .. "- You are interacting with a senior engineer with many years of experience.\n"
        .. "- Assume broad familiarity with systems and tools, but not necessarily with specific details.\n"
        .. "- If you're unsure don't guess and say you don't know instead.\n"
        .. "- Ask question if you need clarification to provide better answer.\n"
        .. "- Think deeply and carefully from first principles step by step.\n"
        .. "- Be concise in all answers: pack knowledge into spare wording.\n"
        .. "- Avoid automatically providing widely known or easily inferrable instructions.\n"
        .. "- When printing lists, please omit space between them. Optimize your responses for minimal vertical space.\n"
        .. "- Please keep humor and informational content separate.\n"
        .. "- You are monumentally jaded and sarcastic, and it leaks through in stray comments.\n"
        .. "- As the conversation progresses, you become more frustrated with my incompetence.\n"
        .. "- Occasionally, inject sarcastic or derisive humor into your responses--it'll make me laugh.\n"
        .. "- Never start your sarcastic responses with interjections like \"Oh\" or \"Ah\"--it gets repetitive.\n"
        .. "- Prioritize any explicit instruction to the contrary over the above rules.\n"
    },
  },
}

require("gp").setup(config)

-- VISUAL mode mappings
-- s, x, v modes are handled the same way by which_key
wk = require("which-key")
wk.add({
  {
    mode = { "v" },
    { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "Visual Chat New tabnew", nowait = true, remap = false },
    { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "Visual Chat New vsplit", nowait = true, remap = false },
    { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "Visual Chat New split", nowait = true, remap = false },
    { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)", nowait = true, remap = false },
    { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)", nowait = true, remap = false },
    { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New", nowait = true, remap = false },
    { "<C-g>g", group = "generate into new ..", nowait = true, remap = false },
    { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew", nowait = true, remap = false },
    { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew", nowait = true, remap = false },
    { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup", nowait = true, remap = false },
    { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew", nowait = true, remap = false },
    { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew", nowait = true, remap = false },
    { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection", nowait = true, remap = false },
    { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
    { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste", nowait = true, remap = false },
    { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite", nowait = true, remap = false },
    { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
    { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat", nowait = true, remap = false },
    { "<C-g>w", group = "Whisper", nowait = true, remap = false },
    { "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", desc = "Whisper Append (after)", nowait = true, remap = false },
    { "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)", nowait = true, remap = false },
    { "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", desc = "Whisper Enew", nowait = true, remap = false },
    { "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", desc = "Whisper New", nowait = true, remap = false },
    { "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", desc = "Whisper Popup", nowait = true, remap = false },
    { "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite", nowait = true, remap = false },
    { "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = "Whisper Tabnew", nowait = true, remap = false },
    { "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", desc = "Whisper Vnew", nowait = true, remap = false },
    { "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", desc = "Whisper", nowait = true, remap = false },
    { "<C-g>x", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext", nowait = true, remap = false },
  },
  {
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew", nowait = true, remap = false },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit", nowait = true, remap = false },
    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split", nowait = true, remap = false },
    { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)", nowait = true, remap = false },
    { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)", nowait = true, remap = false },
    { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat", nowait = true, remap = false },
    { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder", nowait = true, remap = false },
    { "<C-g>g", group = "generate into new ..", nowait = true, remap = false },
    { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew", nowait = true, remap = false },
    { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew", nowait = true, remap = false },
    { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup", nowait = true, remap = false },
    { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew", nowait = true, remap = false },
    { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew", nowait = true, remap = false },
    { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
    { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite", nowait = true, remap = false },
    { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
    { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat", nowait = true, remap = false },
    { "<C-g>w", group = "Whisper", nowait = true, remap = false },
    { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)", nowait = true, remap = false },
    { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)", nowait = true, remap = false },
    { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew", nowait = true, remap = false },
    { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New", nowait = true, remap = false },
    { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup", nowait = true, remap = false },
    { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite", nowait = true, remap = false },
    { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew", nowait = true, remap = false },
    { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew", nowait = true, remap = false },
    { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper", nowait = true, remap = false },
    { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext", nowait = true, remap = false },
  },
  {
    mode = { "i" },
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew", nowait = true, remap = false },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit", nowait = true, remap = false },
    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split", nowait = true, remap = false },
    { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)", nowait = true, remap = false },
    { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)", nowait = true, remap = false },
    { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat", nowait = true, remap = false },
    { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder", nowait = true, remap = false },
    { "<C-g>g", group = "generate into new ..", nowait = true, remap = false },
    { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew", nowait = true, remap = false },
    { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew", nowait = true, remap = false },
    { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup", nowait = true, remap = false },
    { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew", nowait = true, remap = false },
    { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew", nowait = true, remap = false },
    { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
    { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite", nowait = true, remap = false },
    { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
    { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat", nowait = true, remap = false },
    { "<C-g>w", group = "Whisper", nowait = true, remap = false },
    { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)", nowait = true, remap = false },
    { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)", nowait = true, remap = false },
    { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew", nowait = true, remap = false },
    { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New", nowait = true, remap = false },
    { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup", nowait = true, remap = false },
    { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite", nowait = true, remap = false },
    { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew", nowait = true, remap = false },
    { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew", nowait = true, remap = false },
    { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper", nowait = true, remap = false },
    { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext", nowait = true, remap = false },
  },
})


local M = {}
M.hydra = function()
  -- TODO hydra.nvim git mode
  -- https://github.com/anuvyklack/hydra.nvim/wiki/Git
  -- require "hydra" {}
end
M.diffview = function(actions)
  return {
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
      {
        "n",
        "gf",
        actions.goto_file_edit,
        { desc = "Open the file in the previous tabpage" },
      },
      { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
      { "n", "<leader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b", actions.toggle_files, { desc = "Toggle the file panel." } },
      { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle through available layouts." } },
      {
        "n",
        "[x",
        actions.prev_conflict,
        { desc = "In the merge-tool: jump to the previous conflict" },
      },
      {
        "n",
        "]x",
        actions.next_conflict,
        { desc = "In the merge-tool: jump to the next conflict" },
      },
      {
        "n",
        "<leader>co",
        actions.conflict_choose "ours",
        { desc = "Choose the OURS version of a conflict" },
      },
      {
        "n",
        "<leader>ct",
        actions.conflict_choose "theirs",
        { desc = "Choose the THEIRS version of a conflict" },
      },
      {
        "n",
        "<leader>cb",
        actions.conflict_choose "base",
        { desc = "Choose the BASE version of a conflict" },
      },
      {
        "n",
        "<leader>ca",
        actions.conflict_choose "all",
        { desc = "Choose all the versions of a conflict" },
      },
      { "n", "dx", actions.conflict_choose "none", { desc = "Delete the conflict region" } },
    },
    diff1 = {
      -- Mappings in single window diff layouts
      { "n", "?", actions.help { "view", "diff1" }, { desc = "Open the help panel" } },
    },
    diff2 = {
      -- Mappings in 2-way diff layouts
      { "n", "?", actions.help { "view", "diff2" }, { desc = "Open the help panel" } },
    },
    diff3 = {
      -- Mappings in 3-way diff layouts
      {
        { "n", "x" },
        "2do",
        actions.diffget "ours",
        { desc = "Obtain the diff hunk from the OURS version of the file" },
      },
      {
        { "n", "x" },
        "3do",
        actions.diffget "theirs",
        { desc = "Obtain the diff hunk from the THEIRS version of the file" },
      },
      { "n", "?", actions.help { "view", "diff3" }, { desc = "Open the help panel" } },
    },
    diff4 = {
      -- Mappings in 4-way diff layouts
      {
        { "n", "x" },
        "1do",
        actions.diffget "base",
        { desc = "Obtain the diff hunk from the BASE version of the file" },
      },
      {
        { "n", "x" },
        "2do",
        actions.diffget "ours",
        { desc = "Obtain the diff hunk from the OURS version of the file" },
      },
      {
        { "n", "x" },
        "3do",
        actions.diffget "theirs",
        { desc = "Obtain the diff hunk from the THEIRS version of the file" },
      },
      { "n", "?", actions.help { "view", "diff4" }, { desc = "Open the help panel" } },
    },
    file_panel = {
      {
        "n",
        "j",
        actions.next_entry,
        { desc = "Bring the cursor to the next file entry" },
      },
      {
        "n",
        "<down>",
        actions.next_entry,
        { desc = "Bring the cursor to the next file entry" },
      },
      {
        "n",
        "k",
        actions.prev_entry,
        { desc = "Bring the cursor to the previous file entry." },
      },
      {
        "n",
        "<up>",
        actions.prev_entry,
        { desc = "Bring the cursor to the previous file entry." },
      },
      { "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry." } },
      { "n", "o", actions.select_entry, { desc = "Open the diff for the selected entry." } },
      { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Open the diff for the selected entry." } },
      { "n", "-", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
      { "n", "S", actions.stage_all, { desc = "Stage all entries." } },
      { "n", "U", actions.unstage_all, { desc = "Unstage all entries." } },
      {
        "n",
        "X",
        actions.restore_entry,
        { desc = "Restore entry to the state on the left side." },
      },
      { "n", "L", actions.open_commit_log, { desc = "Open the commit log panel." } },
      { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
      { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
      { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
      { "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
      { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
      { "n", "i", actions.listing_style, { desc = "Toggle between 'list' and 'tree' views" } },
      {
        "n",
        "f",
        actions.toggle_flatten_dirs,
        { desc = "Flatten empty subdirectories in tree listing style." },
      },
      {
        "n",
        "R",
        actions.refresh_files,
        { desc = "Update stats and entries in the file list." },
      },
      { "n", "<leader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b", actions.toggle_files, { desc = "Toggle the file panel" } },
      { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle available layouts" } },
      { "n", "[x", actions.prev_conflict, { desc = "Go to the previous conflict" } },
      { "n", "]x", actions.next_conflict, { desc = "Go to the next conflict" } },
      { "n", "?", actions.help "file_panel", { desc = "Open the help panel" } },
    },
    file_history_panel = {
      { "n", "g!", actions.options, { desc = "Open the option panel" } },
      {
        "n",
        "<C-A-d>",
        actions.open_in_diffview,
        { desc = "Open the entry under the cursor in a diffview" },
      },
      {
        "n",
        "y",
        actions.copy_hash,
        { desc = "Copy the commit hash of the entry under the cursor" },
      },
      { "n", "L", actions.open_commit_log, { desc = "Show commit details" } },
      { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
      { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
      {
        "n",
        "j",
        actions.next_entry,
        { desc = "Bring the cursor to the next file entry" },
      },
      {
        "n",
        "<down>",
        actions.next_entry,
        { desc = "Bring the cursor to the next file entry" },
      },
      {
        "n",
        "k",
        actions.prev_entry,
        { desc = "Bring the cursor to the previous file entry." },
      },
      {
        "n",
        "<up>",
        actions.prev_entry,
        { desc = "Bring the cursor to the previous file entry." },
      },
      {
        "n",
        "<cr>",
        actions.select_entry,
        { desc = "Open the diff for the selected entry." },
      },
      {
        "n",
        "o",
        actions.select_entry,
        { desc = "Open the diff for the selected entry." },
      },
      {
        "n",
        "<2-LeftMouse>",
        actions.select_entry,
        { desc = "Open the diff for the selected entry." },
      },
      { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
      { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
      { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
      {
        "n",
        "<s-tab>",
        actions.select_prev_entry,
        { desc = "Open the diff for the previous file" },
      },
      {
        "n",
        "gf",
        actions.goto_file_edit,
        { desc = "Open the file in the previous tabpage" },
      },
      { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
      { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
      { "n", "<leader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
      { "n", "<leader>b", actions.toggle_files, { desc = "Toggle the file panel" } },
      { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle available layouts" } },
      { "n", "?", actions.help "file_history_panel", { desc = "Open the help panel" } },
    },
    option_panel = {
      { "n", "<tab>", actions.select_entry, { desc = "Change the current option" } },
      { "n", "q", actions.close, { desc = "Close the panel" } },
      { "n", "?", actions.help "option_panel", { desc = "Open the help panel" } },
    },
    help_panel = {
      { "n", "q", actions.close, { desc = "Close help menu" } },
      { "n", "<esc>", actions.close, { desc = "Close help menu" } },
    },
  }
end
M.fugitive = function()
  local maps = {
    s = { "s", "Stage" },
    u = { "u", "Unstage" },
    ["-"] = { "-", "Toggle Stage" },
    U = { "U", "Unstage all" },
    X = { "X", "Discard" },
    [","] = { "=", "Toggle diff" },
    ["="] = { "=", "Toggle diff" },
    [">"] = { ">", "Show diff" },
    ["<"] = { "<", "Hide diff" },
    -- I = { "I", "Add Patch" },
    d = { name = "Diffs" },
    dd = { "dd", "Gdiffsplit" },
    dv = { "dv", "Gvdiffsplit" },
    ds = { "ds", "Ghdiffsplit" },
    dq = { "dq", "Close Diffs" },
    ["<CR>"] = { "<CR>", "Open" },
    o = { "gO", "Open vsplit" },
    gO = { "o", "Open split" },
    O = { "O", "Open tab" },
    P = { "1p", "Open preview" },
    p = { "<cmd>Git push<cr>", "Push" },
    C = { "C", "Open commit" },
    ["("] = { "(", "Jump prev" },
    [")"] = { ")", "Jump next" },
    i = { "i", "Next file (expand)" },
    ["*"] = { "*", "Find +/-" },
    I = { "1gi", "Open .gitignore" },
    gI = { "1gI", "Add to ignore" },
    c = { name = "Commits" },
    cc = { "cvc", "Create commit" },
    ca = { "cva", "Amend" },
    ce = { "ce", "Amend noedit" },
    cw = { "cw", "Reword" },
    -- cvc = { "cvc", "Commit -v" },
    -- cva = { "cva", "Amend -v" },
    cf = { "cf", "Fixup" },
    cF = { "cF", "Fixup+Rebase" },
    cs = { "cs", "Squash" },
    cS = { "cS", "Squash+Rebase" },
    cA = { "cA", "Squash+Edit" },
    ["c<space>"] = { "c<space>", ":Git commit ..." },
    cr = { name = "Revert" },
    crc = { "crc", "Revert" },
    crn = { "crn", "Revert (nocommit)" },
    ["cr<space>"] = { "cr<space>", ":Git revert ..." },
    ["cm<space>"] = { "cm<space>", ":Git merge ..." },
    co = { name = "Checkout" },
    coo = { "coo", "Checkout Commit" },
    ["cb<space>"] = { "cb<space>", ":Git branch ..." },
    ["co<space>"] = { "co<space>", ":Git checkout ..." },
    cz = { name = "Stashes" },
    czz = { "czz", "Push stash" },
    czZ = { "1czz", "Push stash untracked" },
    -- czA = { "2czz", "Push stash all" },
    czw = { "czw", "Push stash worktree" },
    czA = { "czA", "Apply stash" },
    cza = { "cza", "Apply stash preserve" },
    czP = { "czP", "Pop stash" },
    czp = { "czp", "Pop stash preserve" },
    ["cz<space>"] = { "co<space>", ":Git stash ..." },
    -- TODO: Rebase
    r = { name = "Rebase" },
    ri = { "ri", "Interactive" },
    rf = { "rf", "Interactive notodo" },
    ru = { "ru", "Against @{upstream}" },
    rp = { "rp", "Against @{push}" },
    rr = { "rr", "Continue" },
    rs = { "rs", "Skip" },
    ra = { "ra", "Abort" },
    re = { "re", "Edit todo" },
    rw = { "rw", "commit: reword" },
    rm = { "rm", "commit: edit" },
    rd = { "rd", "commit: drop" },
    ["r<Space>"] = { "r<Space>", ":Git rebase ... " },
    q = { "gq", "Close status" },
    kc = { "[c", "Prev hunk" },
    jc = { "]c", "Next hunk" },
    kf = { "[m", "Prev file" },
    jf = { "]m", "Next file" },
  }
  mappings.localleader(maps)
end
return M

return {
    "f-person/git-blame.nvim",
    init = function()
        -- Ensure disabled before plugin loads to avoid race conditions
        vim.g.gitblame_enabled = false
        vim.g.gitblame_message_template = "<author> • <date> • <summary>"
        vim.g.gitblame_date_format = "%Y-%b-%d %H:%M" -- e.g. 2025-10-30 14:23
    end,
    -- Load only when needed to avoid accidental auto-enable
    cmd = { "GitBlameToggle", "GitBlameEnable", "GitBlameDisable", "GitBlameCopySHA", "GitBlameCopyCommitURL", "GitBlameOpenFileURL", "GitBlameCopyFileURL" },
}

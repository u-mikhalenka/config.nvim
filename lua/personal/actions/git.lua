local M = {}

local G = {}

local REF_TYPE_BRANCH = "branch"
local REF_TYPE_TAG = "tag"

G.get_git_lines = function(cmd)
    local result = vim.system(cmd, { text = true }):wait()

    if result.code ~= 0 then
        vim.notify(result.stderr ~= "" and result.stderr or "Failed to execute git command", vim.log.levels.ERROR)
        return {}
    end

    local lines = {}

    for line in result.stdout:gmatch("[^\n]+") do
        local branch = line
        table.insert(lines, branch)
    end

    table.sort(lines)
    return lines
end

G.notify_exec_failed = function(result)
    vim.notify(result.stderr ~= "" and result.stderr or "Git command failed", vim.log.levels.ERROR)
end

G.run_git = function(args, on_success)
    local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
    if result.code ~= 0 then
        G.notify_exec_failed(result)
        return
    end

    if on_success then
        on_success(result)
    end
end

G.get_branches = function()
    return G.get_git_lines({ "git", "branch", "--all", "--format=%(refname:short)" })
end

G.rename_branch = function(ref)
    require("personal.actions.ui").input("New branch name: ", ref, function(new_name)
        G.run_git({ "branch", "-m", ref, new_name }, function()
            vim.notify("Renamed " .. ref .. " to " .. new_name)
        end)
    end)
end

G.get_tags = function()
    return G.get_git_lines({ "git", "tag", "--list" })
end

G.checkout = function(ref)
    vim.notify("Checking out " .. ref .. "...")
    vim.system({ "git", "checkout", ref }, { text = true }, vim.schedule_wrap(function(result)
        if result.code ~= 0 then
            G.notify_exec_failed(result)
            return
        end
        vim.notify("Checked out " .. ref)
    end))
end

local get_ref_actions_menu = function(ref, ref_type)
    return {
        {
            name = "Diff with working tree",
            action = function()
                vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(ref))
            end
        },
        {
            name = "Diff current branch against branch",
            action = function()
                vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(ref) .. "..HEAD")
            end
        },
        {
            name = "Diff branch against current branch",
            action = function()
                vim.cmd("DiffviewOpen HEAD.." .. vim.fn.fnameescape(ref))
            end
        },

        {
            name = "Rename...",
            action = function()
                G.rename_branch(ref)
            end,
            when = ref_type == REF_TYPE_BRANCH
        },
        {
            name = "Checkout",
            action = function()
                G.checkout(ref)
            end
        },
        --     elseif choice == "Delete local branch" then
        --         confirm("Delete local branch " .. branch .. "?", function()
        --             run_git({ "branch", "-d", branch }, function()
        --                 vim.notify("Deleted local branch " .. branch)
        --             end)
        --         end)
        --     elseif choice == "Delete remote origin branch" then
        --         confirm("Delete origin/" .. branch .. "?", function()
        --             run_git({ "push", "origin", "--delete", branch }, function()
        --                 vim.notify("Deleted origin/" .. branch)
        --             end)
        --         end)
        --     end
    }
end

local function refs_menu(ref_type, get_list)
    local list = get_list()
    if #list == 0 then
        vim.notify("No git " .. ref_type .. " found", vim.log.levels.WARN)
        return {}
    end

    local menu = {}
    for _, ref in ipairs(list) do
        local item = {
            name = ref,
            menu = function() return get_ref_actions_menu(ref, ref_type) end
        }
        table.insert(menu, item)
    end

    return menu
end

local function branches_menu()
    return refs_menu(REF_TYPE_BRANCH, G.get_branches)
end

local function tags_menu()
    return refs_menu(REF_TYPE_TAG, G.get_tags)
end

M.git_menu = function()
    return {
        {
            name = "Branches",
            children = {},
            menu = branches_menu
        },
        {
            name = "Tags",
            children = {},
            menu = tags_menu
        },
    }
end

return M

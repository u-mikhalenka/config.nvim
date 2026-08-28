local M = {}

local function git_branch_lines()
    local result = vim.system({ "git", "branch", "--all", "--format=%(refname:short)" }, { text = true }):wait()

    if result.code ~= 0 then
        vim.notify(result.stderr ~= "" and result.stderr or "Failed to list git branches", vim.log.levels.ERROR)
        return {}
    end

    local branches = {}

    for line in result.stdout:gmatch("[^\n]+") do
        local branch = line
        table.insert(branches, branch)
    end

    table.sort(branches)
    return branches
end

local function run_git(args, on_success)
    local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()

    if result.code ~= 0 then
        vim.notify(result.stderr ~= "" and result.stderr or "Git command failed", vim.log.levels.ERROR)
        return
    end

    if on_success then
        on_success(result)
    end
end

local get_branch_actions_menu = function(branch)
    return {
        {
            name = "Diff with working tree",
            action = function()
                vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(branch))
            end
        },
        {
            name = "Diff current branch against branch",
            action = function()
                vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(branch) .. "..HEAD")
            end
        },
        {
            name = "Diff branch against current branch",
            action = function()
                vim.cmd("DiffviewOpen HEAD.." .. vim.fn.fnameescape(branch))
            end
        },

        {
            name = "Rename...",
            action = function()
                require("personal.actions.ui").input("New branch name: ", branch, function(new_name)
                    run_git({ "branch", "-m", branch, new_name }, function()
                        vim.notify("Renamed " .. branch .. " to " .. new_name)
                    end)
                end)
            end
        },
        {
            name = "Checkout",
            action = function()
                run_git({ "checkout", branch }, function()
                    vim.notify("Checked out " .. branch)
                end)
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

local function branches_menu()
    local branches = git_branch_lines()
    if #branches == 0 then
        vim.notify("No git branches found", vim.log.levels.WARN)
        return {}
    end

    local menu = {}
    for _, branch in ipairs(branches) do
        local item = {
            name = branch,
            menu = function() return get_branch_actions_menu(branch) end
        }
        table.insert(menu, item)
    end

    return menu
end

M.git_menu = function()
    return {
        {
            name = "Branches",
            children = {},
            menu = branches_menu
        },
    }
end

return M

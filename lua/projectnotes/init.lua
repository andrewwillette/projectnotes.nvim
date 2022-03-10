local lfs = require("lfs")

local M = {}
M._notes_root = nil
M._shortcut = nil
M._init_file = nil
M._init_filetype = nil

-- returns the base directory/file
local function getFilepathBase(filepath)
    local t = {}
    for str in string.gmatch(filepath, "([^/]+)") do
        table.insert(t, str)
    end
    return t[#t]
end

local function getCurrentBufferAbsolutePath()
    return vim.api.nvim_buf_get_name(0)
end

local function getDerivedProjectNameFromProjectNotesAndCurrentDir()
    RootDepth = 0
    for _ in string.gmatch(M._notes_root, "([^/]+)") do
        RootDepth = RootDepth + 1
    end
    local currentdir = getCurrentBufferAbsolutePath()
    CurrentDirDepth = 0
    Cwd = ""
    for dir in string.gmatch(currentdir, "([^/]+)") do
        CurrentDirDepth = CurrentDirDepth + 1
        Cwd = vim.fn.resolve(Cwd .. "/" .. dir)
        if ((CurrentDirDepth - 1) == RootDepth) then
            return dir
        end
    end
    return nil
end

local function getDerivedFilepathFromProjectNotesAndCurrentDir()
    RootDepth = 0
    for _ in string.gmatch(M._notes_root, "([^/]+)") do
        RootDepth = RootDepth + 1
    end
    local currentdir = getCurrentBufferAbsolutePath()
    CurrentDirDepth = 0
    Cwd = ""
    for dir in string.gmatch(currentdir, "([^/]+)") do
        CurrentDirDepth = CurrentDirDepth + 1
        Cwd = vim.fn.resolve(Cwd .. "/" .. dir)
        if ((CurrentDirDepth - 1) == RootDepth) then
            break
        end
    end
    return Cwd
end

-- it is assumed that current dir is the git directory root
-- I use https://github.com/ahmedkhalf/project.nvim to manage this
local function getProjectName()
    if string.match(getCurrentBufferAbsolutePath(), M._notes_root) then
        return getDerivedProjectNameFromProjectNotesAndCurrentDir()
    end
    local currentdir = lfs.currentdir()
    return getFilepathBase(currentdir)
end

-- gets the current projects note root from the configured
-- M._notes_root and parsing the current working directory
-- for the project name
local function getProjectNotesRoot()
    local solutionRoot = vim.fn.resolve(M._notes_root .. "/" .. getProjectName())
    return solutionRoot
end

-- get the absolute path for file created at project initialization
-- three different values can be returned
-- 1 -
--   if init_file is supplied, it's corresponding absolute path is returned
-- 2 -
--   if init_filetype is supplied, the corresponding absolute path of <project_name>.<init_filetype>
--   is returned
-- 3 -
--   if neither is supplied, then the corresponding absolute path of <project_name>.txt
--   is returned
local function getinitFile()
    local solutionRoot = getProjectNotesRoot()
    if (M._init_file ~= nil) then
        return vim.fn.resolve(solutionRoot .. "/" .. M._init_file)
    end
    if (M._init_filetype ~= nil) then
        return vim.fn.resolve(solutionRoot .. "/" .. getProjectName() .. M._init_filetype)
    end
    return vim.fn.resolve(solutionRoot .. "/" .. getProjectName() .. ".txt")
end

local function projectInitialized()
    local projectNotesRootDir = getProjectNotesRoot()
    if (lfs.attributes(projectNotesRootDir)) then
        print("project exists")
        return true
    end
    print("project does not exist")
    return false
end

local function initProjectNotes()
    local projectNotesRootDir = getProjectNotesRoot()
    local initFile = getinitFile()
    if not (lfs.attributes(projectNotesRootDir)) then
        lfs.mkdir(projectNotesRootDir)
    end
    if not (lfs.attributes(initFile)) then
        local file = io.open(initFile, "w")
        file:close()
    end
    if (M._init_dirs ~= nil) then
        for _, dirname in ipairs(M._init_dirs) do
            local initDirAbsolute = vim.fn.resolve(projectNotesRootDir .. "/" .. dirname)
            if not (lfs.attributes(initDirAbsolute)) then
                lfs.mkdir(initDirAbsolute)
            end
        end
    end
end

M.setup = function(opts)
    M._notes_root = opts.notes_root
    M._shortcut = opts.shortcut
    M._init_file = opts.init_file
    M._init_filetype = opts.init_filetype
    M._init_dirs = opts.init_dirs
    vim.keymap.set(
    "n",
        M._shortcut,
        function()
            if not (projectInitialized()) then
                initProjectNotes()
            end
            if string.match(getCurrentBufferAbsolutePath(), M._notes_root) then
                TelescopeCwd = getDerivedFilepathFromProjectNotesAndCurrentDir()
            else
                TelescopeCwd = getProjectNotesRoot()
            end
            require("telescope.builtin").find_files({
              cwd = TelescopeCwd,
              prompt_title = getProjectName() .. " Project Notes",
              hidden = true,
            })
        end,
        {})
end

return M

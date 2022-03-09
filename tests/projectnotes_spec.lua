describe("projectnotes", function()

    it("can be required", function()
        require("projectnotes")
    end)

    -- it("sets the configured keymap correctly", function()
    --     local configuredKeyMap = ",t"
    --     local configuredDirectory = "/tmp/notes"
    --     local configuredFileType = ".txt"
    --     local dailynotes = require("dailynotes")
    --     dailynotes.init(configuredFileType)
    --     assert.are.same(dailynotes._filetype, configuredFileType)
    --     dailynotes.addDailyNoteShortcut(configuredKeyMap, configuredDirectory)
    --     local found = find_map(configuredKeyMap)
    --     assert.equals(found.lhs, configuredKeyMap)
    --     assert.truthy(found.lhs ~= nil )
    -- end)
end)

--------------------------------------------------------------------------------
-- MA Stacking Status Plugin (stacking_status.lrdevplugin)
-- UpdateStackingMetadata.lua
--
-- Detects the stacking status of photos in selected folders and their
-- subfolders, then updates the `stackingStatus` metadata:
--   OutOfStack: photo is not part of a stack
--   TopOfStack: photo is at the top of a stack
--   LowerInStack: photo is lower in a stack, below the top photo
--
--------------------------------------------------------------------------------

local LrApplication = import "LrApplication"
local LrProgressScope = import "LrProgressScope"
local LrTasks = import "LrTasks"
local LrDialogs = import "LrDialogs"
local LrFunctionContext = import "LrFunctionContext"

local PROPERTY = "stackingStatus"
local CHUNK_SIZE = 500

local STACK_STATUS = {
    TOP = "TopOfStack",
    LOWER = "LowerInStack",
    OUT = "OutOfStack",
}

local function detectStatus(photo)
    local isInStack = photo:getRawMetadata("isInStackInFolder")
    if not isInStack then
        return STACK_STATUS.OUT
    end

    local stackPosition = photo:getRawMetadata("stackPositionInFolder")
    if stackPosition == 1 then
        return STACK_STATUS.TOP
    end
    return STACK_STATUS.LOWER
end

-- Photos are processed in chunks so that write access is released regularly,
-- and a photo is only written when its stored value differs from the detected
-- one, which keeps repeated runs fast and leaves the catalog untouched when
-- nothing has changed.
local function updatePhotos(photos, progressScope)
    local catalog = LrApplication.activeCatalog()
    local total = #photos
    local stats = { processed = 0, written = 0, unchanged = 0 }

    local first = 1
    while first <= total do
        if progressScope:isCanceled() then break end

        local last = math.min(first + CHUNK_SIZE - 1, total)

        catalog:withWriteAccessDo("Update stacking status", function()
            for i = first, last do
                if progressScope:isCanceled() then break end

                local photo = photos[i]
                local status = detectStatus(photo)

                if photo:getPropertyForPlugin(_PLUGIN, PROPERTY) ~= status then
                    photo:setPropertyForPlugin(_PLUGIN, PROPERTY, status)
                    stats.written = stats.written + 1
                else
                    stats.unchanged = stats.unchanged + 1
                end
                stats.processed = stats.processed + 1
            end
        end)

        progressScope:setPortionComplete(last, total)
        first = last + 1
        LrTasks.yield()
    end

    return stats
end

local function showReport(stats, elapsed, canceled)
    local msg = string.format(
        "%d photos checked\n%d updated, %d already correct\nElapsed time: %.2f seconds",
        stats.processed, stats.written, stats.unchanged, elapsed
    )
    if canceled then msg = msg .. "\n(Aborted by user)" end
    LrDialogs.message("Stacking status", msg, "info")
end

local function updateStackingStatus()
    LrFunctionContext.callWithContext("updateStackingContext", function(context)
        local catalog = LrApplication.activeCatalog()
        local sources = catalog:getActiveSources()

        if #sources == 0 then
            LrDialogs.message("No source selected", "Select one or more folders and re-run", "info")
            return
        end

        local progressScope = LrProgressScope({
            title = "Updating Stacking metadata...",
            functionContext = context,
        })
        progressScope:setCancelable(true)

        -- Gather all photos from the selected folders (subfolders included)
        -- and deduplicate them
        local allPhotos = {}
        local seen = {}
        local folders = 0
        for _, src in ipairs(sources) do
            if type(src) == "table" and src.type and src:type() == "LrFolder" then
                folders = folders + 1
                for _, p in ipairs(src:getPhotos(true)) do
                    if not seen[p] then
                        seen[p] = true
                        allPhotos[#allPhotos + 1] = p
                    end
                end
            end
        end

        if #allPhotos == 0 then
            progressScope:done()
            if folders == 0 then
                LrDialogs.message("No folders selected")
            else
                LrDialogs.message("No photos found in selected folders")
            end
            return
        end

        local startTime = os.clock()
        local stats = updatePhotos(allPhotos, progressScope)
        local elapsed = os.clock() - startTime
        local canceled = progressScope:isCanceled()
        progressScope:done()

        showReport(stats, elapsed, canceled)
    end)
end

LrTasks.startAsyncTask(updateStackingStatus, "runPlugin")

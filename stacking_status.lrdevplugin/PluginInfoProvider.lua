--------------------------------------------------------------------------------
-- MA Stacking Status Plugin (stacking_status.lrdevplugin)
-- PluginInfoProvider.lua
--
-- Provides the plugin usage info to be shown in Plugin Manager
--------------------------------------------------------------------------------
local LrView = import "LrView"

local function sectionsForTopOfDialog(_, _)
	local f = LrView.osFactory()

	return {
		{
			title = "MA Stacking Status",
			f:column {
				spacing = f:control_spacing(),
				f:static_text {
					title =
						"Updates the stacking status metadata for photos in the " ..
						"selected folders and their subfolders.\n\n" ..
						"The possible stored status values are OutOfStack, TopOfStack, and LowerInStack.\n\n" ..
						"If no value is present, the plugin has not yet been run on the " ..
						"folder the photo belongs to.\n\n" ..
						"To find photos not yet scanned, create a smart collection with " ..
						"Match: all and three rules: Stacking is not Out of Stack, " ..
						"Stacking is not Lower In Stack, Stacking is not Top Of Stack.\n\n" ..
						"Run the plugin again after stacking or unstacking photos, " ..
						"because the stored value does not update automatically.",
				},
			},
		},
	}
end

return {
	sectionsForTopOfDialog = sectionsForTopOfDialog,
}

--------------------------------------------------------------------------------
-- Stacking Status Plugin (stacking_status.lrdevplugin)
-- Info.lua

-- Detects the stacking status of all photos in selected folder(s) 
-- and updates read-only metadata `stackingStatus`
--------------------------------------------------------------------------------
return {
	LrSdkVersion = 15.0,
	LrSdkMinimumVersion = 3.0,

	LrToolkitIdentifier = "com.mrzgll.stackingstatus",
	LrPluginName = "MA Stacking Status",

	LrMetadataProvider = "CustomMetadataDefinition.lua",
	LrPluginInfoProvider = "PluginInfoProvider.lua",

	LrLibraryMenuItems = {
		{
			title = "Update Stacking Status",
			file = "UpdateStackingMetadata.lua",
		},
	},

	VERSION = {
		major = 1,
		minor = 1,
	},
}


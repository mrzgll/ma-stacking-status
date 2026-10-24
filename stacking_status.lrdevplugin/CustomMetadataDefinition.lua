--------------------------------------------------------------------------------
-- MA Stacking Status Plugin (stacking_status.lrdevplugin)
-- CustomMetadataDefinition.lua
--
-- Defines the custom metadata field for stacking status
---------------------------------------------------------------------------------
return {
	metadataFieldsForPhotos = {
		{
			id = "stackingStatus",
			title = "Stacking",
			dataType = "enum",
			browsable = true,
			searchable = true,
			readOnly = true,
			values = {
				{ value = "OutOfStack", title = "Out of Stack" },
				{ value = "LowerInStack", title = "Lower In Stack" },
				{ value = "TopOfStack", title = "Top Of Stack" },
			},
			allowPluginToSetOtherValues = false,
		},
	},
	schemaVersion = 3,
}

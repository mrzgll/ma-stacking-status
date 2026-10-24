# MA Stacking Status

MA Stacking Status is a Lightroom Classic plug-in that checks photos in selected
folders and their subfolders, determining which of these mutually exclusive
stacking statuses applies to each photo:

| Value          | Display value   | Meaning |
| ---            | ---             | ---     |
| `OutOfStack`   | Out of Stack    | The photo is not part of a stack in its folder. |
| `TopOfStack`   | Top Of Stack    | The photo is the top photo in a stack. |
| `LowerInStack` | Lower In Stack  | The photo is in a stack but is below the top photo. |

The plug-in stores the result in the custom metadata field `stackingStatus`
(titled **Stacking**).

No value (`nil`) means the plug-in has not been run yet for the photo.

The stored status is updated only when you run the plug-in; it is not recalculated
automatically when stack membership or order changes.

Status is determined from stacking within folders, not collections. The plug-in
does not create, rearrange, or otherwise change stacks.

## Installation

The plug-in declares SDK version 15.0 and a minimum SDK version of 3.0 in
`Info.lua`. Check compatibility with your Lightroom Classic installation.
Back up your catalog before using the plug-in.

To install the plug-in, follow these steps:

1. Download or clone this project.
2. Keep the `stacking_status.lrdevplugin` directory intact.
3. In Lightroom Classic, open **File > Plug-in Manager**.
4. Choose **Add** and select the `stacking_status.lrdevplugin` directory.
5. Enable the plug-in if Lightroom does not enable it automatically.

## Usage

1. Open the **Library** module in Lightroom Classic.
2. Select one or more folders in the Folders panel.
3. Choose **Library > Plug-in Extras > Update Stacking Status**.
4. Let the update finish, or cancel it using the progress control.
5. View the **Stacking** field in the Metadata panel, or use it in Lightroom
   searches, filters, and smart collections.

The command processes all photos in the selected folders and their subfolders; it
does not limit the update to individually selected photos. Non-folder sources
are ignored. If no folders are selected, or the selected folders contain no
photos, Lightroom displays an informational message.

Photos are processed in batches. If you cancel, photos already processed keep
their updated values; run the command again to complete the update.

To add **stackingStatus** to a metadata set:

1. Open `%APPDATA%\Adobe\Lightroom\Metadata Field Lists` in File Explorer.
2. Open the `.lrtemplate` file for the metadata set you want to edit. Consider making a backup copy before changing it.
3. Insert the following field identifier at the position where you want **stackingStatus** to appear:

   ```text
    "com.mrzgll.stackingstatus.stackingStatus",
   ```
4. Save the template. If Lightroom Classic is open, restart it so the updated metadata set is loaded.
5. In the Library module, select that metadata set in the **Metadata** panel.

The stackingStatus metadata will be shown in the metadata panel with the label "Stacking". The field is read-only in Lightroom, so it
cannot be edited from the Metadata panel.

## Troubleshooting

### The plug-in does not load

In Plug-in Manager, verify that you selected the complete
`stacking_status.lrdevplugin` directory and that the plug-in is enabled.

### The menu command is unavailable

Make sure the plug-in is enabled and the Library module is active. Select at
least one folder in the Folders panel before running the command.

### Status values are stale

Run **Update Stacking Status** again after changing stack membership or order.
The field stores the result of the last run; it is not a live calculated
value.

## Project files

- `stacking_status.lrdevplugin/Info.lua`: Plug-in metadata and menu registration
- `stacking_status.lrdevplugin/PluginInfoProvider.lua`: Plug-in Manager
  information panel
- `stacking_status.lrdevplugin/CustomMetadataDefinition.lua`: Custom metadata
  field definition
- `stacking_status.lrdevplugin/UpdateStackingMetadata.lua`: Folder traversal
  and status update logic

## Disclaimer

This is an independent project and is not affiliated with, endorsed by, or
supported by Adobe. "Lightroom Classic" and "LrC" are used only to describe
compatibility.

This plug-in is provided as is, without warranty of any kind. Test it on a
small selection or a catalog copy before using it across a large catalog.

**This plugin has been tested only on Microsoft Windows 11.**

## License

See [LICENSE](LICENSE) for details.

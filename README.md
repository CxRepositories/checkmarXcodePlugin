# checkmarXcodePlugin

## Checkmarx Xcode Source Editor Extension Plugin

This is an Xcode Source-Editor-Extension Plugin to send scan
requests and return results from the Checkmarx SAST product.

## Beta

This project is still in 'beta' and has not been officially released.

## Restrictions

--- Restrictions in the Beta ---

1) All Scans MUST be made to a (server-side) bound Project.
2) Private Scans are NOT supported.
3) Only source files are zipped (no binary files) but there is NO include/exclude override.
4) There is NO Proxy support.
5) There is NO Data retention support (i.e. the ability to clean up logs and such).

## GA

--- Items for GA (General Availability) ---

1) Ability to run an 'unbound' Project.</li>
2) Ability to create new Projects (Team\Preset\Engine Config\etc).
3) Include/Exclude override support.
4) Additional UI improvements (i.e. progress bars, etc.).
5) Add support for v9.0 authentication.

## Installation instructions

--- Steps to install ---

1) Download the Checkmarx Xcode plugin (distribution) zip file.
2) Extract the contents of the zip file.
3) Copy the Checkmarx Xcode plugin (MacOS) App file (CheckmarxXcodePlugin1.app) to the '/Applications' directory.
4) From the ‘/Applications’ directory launch the App. Once it is up, close the App (this action tells the system that there is an Xcode Source Editor extension contained within the App). If you get a system popup saying that the App requires your permission to control Xcode, allow the action. This is used to locate the current Xcode project file.
5) Go to ‘System Preferences’ and then to ‘Extensions’. Scroll down (if needed) on the left-hand side and select ‘Xcode Source Editor’. The Checkmarx Xcode App extension ‘CxViewer’ should show on the right-hand side. Click on the box to enable the plugin.
6) Launch Xcode, view a source file, and then look for the ‘CxViewer’ sub-menu on the Xcode ‘Editor’ menu.
7) Select one of the 'CxViewer' sub-menu items: Full Scan, Incremental Scan, Binding Settings, and View Last Report.
8) Report types may be: pdf, xml, csv, or rtf.


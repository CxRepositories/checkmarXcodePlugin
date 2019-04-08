# checkmarXcodePlugin

## Checkmarx Xcode Source Editor Extension Plugin

This is an Xcode Source-Editor-Extension Plugin to send scan
requests and return results from the Checkmarx SAST product.

## Beta

This project is still in BETA and has not been officially released.

## Restrictions

--- Restrictions in the BETA ---

1) All Scans MUST be made to a (server-side) bound Project.
2) Private Scans are NOT supported.
3) Only source files are zipped (no binary files) but there is NO include/exclude override.
4) There is NO Proxy support.
5) There is NO Data retention support (i.e. the ability to clean up logs and such).

## GA

--- Items for GA (General Availability) ---

1) Ability to run an "unbound" Project.</li>
2) Ability to create new Projects (Team\Preset\Engine Config\etc).
3) Include/Exclude override support.
4) Additional UI improvements (i.e. progress bars, etc.).
5) Add support for v9.0 authentication.

## Installation instructions

--- Steps to install ---

1) Download the Checkmarx Xcode plugin (distribution) zip file.
2) Extract the contents of the zip file.
3) Copy the Checkmarx Xcode plugin (MacOS) App file (CheckmarxXcodePlugin1.app) to the "/Applications" directory.
4) From the "/Applications" directory launch the App. Once it is up, close the App (this action tells the system that there is an Xcode Source Editor extension contained within the App). If you get a system popup saying that the App requires your permission to control Xcode, allow the action. This is used to locate the current Xcode project file.
5) Go to "System Preferences" and then to "Extensions". Scroll down (if needed) on the left-hand side and select "Xcode Source Editor". The Checkmarx Xcode App extension "CxViewer" should show on the right-hand side. Click on the box to enable the plugin.
6) Launch Xcode, view a source file, and then look for the "CxViewer" sub-menu on the Xcode "Editor" menu.
7) Select one of the "CxViewer" sub-menu items: Full Scan, Incremental Scan, Binding Settings, View Last Report, or View Results in CxSast.
8) Report types may be: pdf, xml, csv, or rtf. No Report type is needed for "View Results in CxSast".

## Setup instructions

--- Steps to setup (1st Scan) ---

1) From the "/Applications" directory launch the App. Once it is up, goto the "CheckmarxXcodePlugin1" menu and select "Preferences" (or Command-,).
2) On the "Preferences" screen, click on the "+" button, set a name of the new Endpoint and click "Create". On the right-hand side of the screen set the various fields (if this is the only Endpoint - make sure to mark it the 'Default Server').
3) Press "Test Connection...". If the Connection is good, the "Apply" button will enable. If enabled, click it and dismiss the window. If NOT enabled, check the fields and re-try.
4) Once the "Default Server" Endpoint has been set, you can use all of the "CxViewer" menu items in Xcode.
5) On the 1st scan, the CheckmarxXcodePlugin1 will pop-up a window asking for "Checkmarx Bind and Report" settings. Drop-down the "CxSAST Project" and select the CxServer Project name to associate with the scan. Then select whether or not to 'Download a Report' and (if so) drop-down and select the "Report Type". Click on "Apply" and dismiss the window.  
6) If you need to make changes to a "Bound" Project's report settings, click on the "CxViewer" "Binding Settings" menu item.


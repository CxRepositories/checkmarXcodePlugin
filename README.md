# checkmarXcodePlugin

## Xcode Source Editor Extension Plugin

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


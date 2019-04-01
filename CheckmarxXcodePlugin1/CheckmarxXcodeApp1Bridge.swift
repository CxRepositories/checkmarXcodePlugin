//
//  CheckmarxXcodeApp1Bridge.swift - v1.0401
//  Swift-AppleScriptObjC
//

import Cocoa

@objc(NSObject) protocol CheckmarxXcodeApp1Bridge
{
    
    // IMPORTANT: ASOC does not bridge C primitives, only Cocoa classes and objects.
    // So, Swift Bool/Int/Double values MUST be explicitly boxed/unboxed as NSNumber when passing to/from AppleScript.
    
    var isAppRunning:NSNumber { get };                                              // Bool

    var isAppWorkSpaceDocLoaded:NSNumber { get };                                   // Bool
    
    func appWorkSpaceDocFile()->NSString?;                                          // NSString

    func setAppWorkSpaceDocFile(sCurrScanTitle:NSAppleEventDescriptor)->NSString?;  // NSString

} // End of protocol CheckmarxXcodeApp1Bridge.

extension CheckmarxXcodeApp1Bridge
{ 

    // Native Swift versions of the above ASOC APIs:
    
    var isAppRunning:Bool { return self.isAppRunning.boolValue };

    var isAppWorkSpaceDocLoaded:Bool { return self.isAppWorkSpaceDocLoaded.boolValue };
    
} // End of extension CheckmarxXcodeApp1Bridge.


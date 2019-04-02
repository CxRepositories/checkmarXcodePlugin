//
//  CheckmarxXcodePlugin1Bridge.swift - v1.0402
//  Swift-AppleScriptObjC
//

import Cocoa

@objc(NSObject) protocol CheckmarxXcodePlugin1Bridge
{
    
    // IMPORTANT: ASOC does not bridge C primitives, only Cocoa classes and objects.
    // So, Swift Bool/Int/Double values MUST be explicitly boxed/unboxed as NSNumber when passing to/from AppleScript.
    
    var isAppRunning:NSNumber { get }; // Bool
    
    var cXcodeScans:NSNumber { get };  // Int

    func submitNextScanAsFull();

    func submitScanAsFull(idXcodeScan:NSNumber);

    func submitNextScanAsIncremental();

    func submitScanAsIncremental(idXcodeScan:NSNumber);

    func signalBindViewLastReport();

    func signalBindOrUnbind();

} // End of protocol CheckmarxXcodePlugin1Bridge.

extension CheckmarxXcodePlugin1Bridge
{ 

    // Native Swift versions of the above ASOC APIs:
    
    var isAppRunning:Bool { return self.isAppRunning.boolValue };
    
} // End of extension CheckmarxXcodePlugin1Bridge.


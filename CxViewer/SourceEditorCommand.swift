//
//  SourceEditorCommand.swift
//  CxViewer
//
//  Created by Daryl Cox on 11/6/18.
//  Copyright © 2018 Checkmarx. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "SourceEditorCommand";
        static let sClsVers        = "v1.0403";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    // AppleScriptObjC object for communicating with CheckmarxXcodePlugin1:

    var cxXcodePlugin1Bridge:CheckmarxXcodePlugin1Bridge? = nil;

    let jsTraceLog:JsTraceLog = JsTraceLog.sharedJsTraceLog;
    let sTraceCls             = ClassInfo.sClsDisp;

    open func toString()->String
    {

        var asToString:[String] = Array();

        asToString.append("[");
        asToString.append("[");
        asToString.append("'sClsId': [\(ClassInfo.sClsId)],");
        asToString.append("'sClsVers': [\(ClassInfo.sClsVers)],");
        asToString.append("'sClsDisp': [\(ClassInfo.sClsDisp)],");
        asToString.append("'sClsCopyRight': [\(ClassInfo.sClsCopyRight)],");
        asToString.append("'bClsTrace': [\(ClassInfo.bClsTrace)],");
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)]");
        asToString.append("'sClsLogFilespec': [\(ClassInfo.sClsLogFilespec)]");
        asToString.append("],");
        asToString.append("'cxXcodePlugin1Bridge': [\(String(describing: self.cxXcodePlugin1Bridge))],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog.toString())],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of public func toString().

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";

        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);

        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        if (self.cxXcodePlugin1Bridge == nil)
        {

            // AppleScriptObjC (ASOC) setup:

            Bundle.main.loadAppleScriptObjectiveCScripts();

            // Create an instance of CheckmarxXcodePlugin1Bridge script object for Swift code to use:

            let cxXcodePlugin1BridgeClass:AnyClass = NSClassFromString("CheckmarxXcodePlugin1Bridge")!;
            self.cxXcodePlugin1Bridge              = (cxXcodePlugin1BridgeClass.alloc() as! CheckmarxXcodePlugin1Bridge);

        }

    //  guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else { completionHandler(createError()); return; }
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else { completionHandler(nil); return; }

        let sCommandId      = invocation.commandIdentifier;
        var sMenuItemName   = "-not-set-";

        switch (sCommandId)
        {

            case "com.jwebiq.CheckmarxXcodePlugin1.CxViewer.SourceEditorCommand1":

                sMenuItemName = "Full Scan";

                self.cxXcodePlugin1Bridge!.submitNextScanAsFull();

            case "com.jwebiq.CheckmarxXcodePlugin1.CxViewer.SourceEditorCommand2":

                sMenuItemName = "Incremental Scan";

                self.cxXcodePlugin1Bridge!.submitNextScanAsIncremental();

            case "com.jwebiq.CheckmarxXcodePlugin1.CxViewer.SourceEditorCommand3":

                sMenuItemName = "Bind or Unbind";

                self.cxXcodePlugin1Bridge!.signalBindOrUnbind();

            case "com.jwebiq.CheckmarxXcodePlugin1.CxViewer.SourceEditorCommand4":

                sMenuItemName = "View Last Report";

                self.cxXcodePlugin1Bridge!.signalBindViewLastReport();

            case "com.jwebiq.CheckmarxXcodePlugin1.CxViewer.SourceEditorCommand5":
            
                sMenuItemName = "View Results in CxSast";
            
                self.cxXcodePlugin1Bridge!.signalBindViewResultsInCxSAST();

            default:

                sMenuItemName = "-undefined-";

        }
        
        let sCommentText = "// - @\(NSUserName()) - [\(sCommandId)] - [\(sMenuItemName)]...";
        
        invocation.buffer.lines.insert(sCommentText, at: selection.end.line);

        completionHandler(nil);
        
    } // End of func perform().
    
} // END of class SourceEditorCommand.

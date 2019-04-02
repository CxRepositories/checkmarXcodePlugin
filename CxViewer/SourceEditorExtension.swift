//
//  SourceEditorExtension.swift
//  CxViewer
//
//  Created by Daryl Cox on 11/6/18.
//  Copyright (c) 2018-2019 Checkmarx. All rights reserved.
//

import Foundation
import Cocoa
import XcodeKit
import AppleScriptObjC       // ASOC adds its own 'load scripts' method to NSBundle

class SourceEditorExtension: NSObject, XCSourceEditorExtension 
{
    
    struct ClassInfo
    {
        
        static let sClsId          = "SourceEditorExtension";
        static let sClsVers        = "v1.0402";
        static let sClsDisp        = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight   = "Copyright (C) Checkmarx 2018-2019. All Rights Reserved.";
        static let bClsTrace       = true;
        static let bClsFileLog     = true;
        static let sClsLogFilespec = "~/Checkmarx/CheckmarxXcodePlugin1.log";
        
    }

    let sApplicationName      = ClassInfo.sClsId;

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
        asToString.append("'sApplicationName': [\(self.sApplicationName)],");
        asToString.append("'jsTraceLog': [\(self.jsTraceLog.toString())],");
        asToString.append("'sTraceCls': [\(self.sTraceCls)]");
        asToString.append("]");

        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";

        return sContents;

    } // End of public func toString().

    func extensionDidFinishLaunching() 
    {

        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = "'"+sCurrMethod+"()'";
   
        _ = self.jsTraceLog.registerJsTraceLogClass(clsName: self.sTraceCls, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:ClassInfo.sClsLogFilespec);
   
        self.jsTraceLog.jsTraceLogSayStart(sTraceCls: sTraceCls);
   
        self.jsTraceLog.jsTraceLogMsg(clsName: self.sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Invoked...");

        // AppleScriptObjC (ASOC) setup:

        Bundle.main.loadAppleScriptObjectiveCScripts();

        // Create an instance of CheckmarxXcodePlugin1Bridge script object for Swift code to use:

        let cxXcodePlugin1BridgeClass:AnyClass = NSClassFromString("CheckmarxXcodePlugin1Bridge")!;
        self.cxXcodePlugin1Bridge              = (cxXcodePlugin1BridgeClass.alloc() as! CheckmarxXcodePlugin1Bridge);
        
    } // End of func extensionDidFinishLaunching().
    
    /*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] 
    {

        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.

        return [];

    } // End of var commandDefinitions.
    */
    
} // End of class SourceEditorExtension.

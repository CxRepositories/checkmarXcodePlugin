//
//  JsTraceLog.swift
//  Swift_CommandLine_Library
//
//  Created by Daryl Cox on 4/18/15.
//  Copyright (c) 2015-2019 JWebSoftware. All rights reserved.
//

import Foundation

// Enum for TraceMsgLevel(s):

public enum TraceMsgLevel:Int
{
    
    case Always = 0, Error, Warning, Info, Verbose
    
}

// Data class for tracking JsTraceLog 'registrations':

public class JsTraceRegistration
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "JsTraceRegistration";
        static let sClsVers      = "v4.1103";
        static let sClsDisp      = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight = "Copyright (C) JWebSoftware 2015-2019. All Rights Reserved.";
        
    } // End of struct ClassInfo.
    
    let sDefaultFilespec:String = "~/Checkmarx/JsTraceRegistration.log";
    
    var sClsName:String!        = nil;
    var bClsTrace:Bool          = true;
    var bClsFileLog:Bool        = true;
    var sClsFilespec:String!    = nil;
    
    public init(clsName:String, clsTrace:Bool=false, clsFileLog:Bool=false, clsFilespec:String?=nil)
    {
        
        self.sClsName     = clsName;
        self.bClsTrace    = clsTrace;
        self.bClsFileLog  = clsFileLog;
        self.sClsFilespec = clsFilespec ?? self.sDefaultFilespec;

        if (self.sClsFilespec != nil)
        {

            if (self.sClsFilespec.hasPrefix("~/") == true)
            {
          
            //  self.sClsFilespec = self.sClsFilespec.expandTildeInString();
                self.sClsFilespec = NSString(string: self.sClsFilespec).expandingTildeInPath as String;

            }

            let sClsFilepath  = (self.sClsFilespec as NSString).deletingLastPathComponent;

            do
            {

                try FileManager.default.createDirectory(atPath: sClsFilepath, withIntermediateDirectories: true, attributes: nil)

            }
            catch
            {

                print("'[\(String(describing: self.sClsName))].init(...)' - Failed to create the 'path' of [\(sClsFilepath)] - Error: \(error)...");

            }

        }

    } // End of init().
    
    public func toString()->String
    {
        
        var asToString:[String] = Array();
        
        asToString.append("[");
        asToString.append("[");
        asToString.append("'sClsId': [\(ClassInfo.sClsId)],");
        asToString.append("'sClsVers': [\(ClassInfo.sClsVers)],");
        asToString.append("'sClsDisp': [\(ClassInfo.sClsDisp)],");
        asToString.append("'sClsCopyRight': [\(ClassInfo.sClsCopyRight)]");
        asToString.append("],");
        asToString.append("'sDefaultFilespec': [\(self.sDefaultFilespec)],");
        asToString.append("'sClsName': [\(String(describing: self.sClsName))],");
        asToString.append("'bClsTrace': [\(self.bClsTrace)],");
        asToString.append("'bClsFileLog': [\(self.bClsFileLog)],");
        asToString.append("'sClsFilespec': [\(String(describing: self.sClsFilespec))]");
        asToString.append("]");
        
        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";
        
        return sContents;
        
    } // End of public func toString().
    
} // End of public class JsTraceRegistration.

// A 'singleton' class for output of 'trace' message(s):

public class JsTraceLog
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "JsTraceLog";
        static let sClsVers      = "v4.1102";
        static let sClsDisp      = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight = "Copyright (C) JWebSoftware 2015-2019. All Rights Reserved.";
        static let bClsTrace     = false;
        static let bClsFileLog   = false;
        
    } // End of struct ClassInfo.

    let bClsTraceInternal                                    = false;
    var dtCurrent:NSDate!                                    = nil;
    var dtFormatter:DateFormatter!                           = nil;
    var sCurrentDate:String                                  = "-today-";
    
    var nsHost2:Host!                                        = Host.current();
    var sHostName2:String                                    = "-unknown-";
    
    var dictJsTraceRegistration:[String:JsTraceRegistration] = [:];
    
    class public var sharedJsTraceLog:JsTraceLog
    {
        
        struct Singleton
        {
            
            static let jsTraceLogInstance = JsTraceLog();
            
        }
        
        return Singleton.jsTraceLogInstance;
        
    } // End of class public var sharedJsTraceLog.
    
    public init()
    {
        
        self.dtCurrent              = NSDate();
        self.dtFormatter            = DateFormatter();
        self.dtFormatter.timeZone   = NSTimeZone.default;
        self.dtFormatter.dateFormat = "MM/dd/yyyy@HH:mm:ss";
        self.sCurrentDate           = self.dtFormatter.string(from: self.dtCurrent as Date);
        
        self.nsHost2                = Host.current();
        self.sHostName2             = (self.nsHost2.localizedName == nil) ? "-unknown-" : self.nsHost2.localizedName!;
        
    } // End of init().
    
    public func toString()->String
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
        asToString.append("],");
        asToString.append("'bClsTraceInternal': [\(self.bClsTraceInternal)],");
        asToString.append("'dtCurrent': [\(String(describing: self.dtCurrent))],");
        asToString.append("'dtFormatter': [\(String(describing: self.dtFormatter))],");
        asToString.append("'sCurrentDate': [\(self.sCurrentDate)],");
        asToString.append("'nsHost2': [\(String(describing: self.nsHost2))],");
        asToString.append("'sHostName2': [\(self.sHostName2)],");
        asToString.append("'dictJsTraceRegistration': [\(self.dictJsTraceRegistration)]");
        asToString.append("]");
        
        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";
        
        return sContents;
        
    } // End of public func toString().
    
    public func registerJsTraceLogClass(clsName:String, clsTrace:Bool=false, clsFileLog:Bool=false, clsFilespec:String?=nil)->JsTraceRegistration
    {
        
        if (self.dictJsTraceRegistration[clsName] != nil)
        {
            
            let jsTraceRegistration1:JsTraceRegistration = self.dictJsTraceRegistration[clsName]!;
            
            jsTraceRegistration1.bClsTrace    = clsTrace;
            jsTraceRegistration1.bClsFileLog  = clsFileLog;
            jsTraceRegistration1.sClsFilespec = clsFilespec ?? jsTraceRegistration1.sDefaultFilespec;
            
            self.dictJsTraceRegistration[clsName] = jsTraceRegistration1;
            
            return jsTraceRegistration1;
            
        }
        
        let jsTraceRegistration1:JsTraceRegistration = JsTraceRegistration(clsName:clsName, clsTrace:clsTrace, clsFileLog:clsFileLog, clsFilespec:clsFilespec);
        
        self.dictJsTraceRegistration[clsName] = jsTraceRegistration1;
        
        return jsTraceRegistration1;
        
    } // End of public func registerJsTraceLogClass().
    
    public func deregisterJsTraceLogClass(clsName:String)
    {
        
        if (self.dictJsTraceRegistration[clsName] != nil)
        {
            
            self.dictJsTraceRegistration.removeValue(forKey: clsName);
            
        }
        
    } // End of public func deregisterJsTraceLogClass().
    
    public func jsTraceLogMsg(clsName:String, sTraceClsDisp:String?, sTraceClsMsg:String?, iTraceMsgLevel:TraceMsgLevel? = TraceMsgLevel.Always)
    {
        
        let sClsDisp:String                           = sTraceClsDisp!;
        var jsTraceRegistration1:JsTraceRegistration! = nil;
        
        if (self.dictJsTraceRegistration[clsName] != nil)
        {
            
            jsTraceRegistration1 = self.dictJsTraceRegistration[clsName]!;
            
        }
        else
        {
            
            jsTraceRegistration1 = self.registerJsTraceLogClass(clsName: clsName, clsTrace:ClassInfo.bClsTrace, clsFileLog:ClassInfo.bClsFileLog, clsFilespec:nil);
            
        }
        
        if (self.bClsTraceInternal == true)
        {
            
            print("<internal> 'jsTraceRegistration1' is [\(jsTraceRegistration1.toString())]...");
            
        }
        
        if (jsTraceRegistration1.bClsTrace == false)
        {
            
            return;
            
        }

        let jsTraceMsgLevel = TraceMsgLevel(rawValue: iTraceMsgLevel!.rawValue);
        
        if (jsTraceMsgLevel == nil)
        {

            return;

        }
        
        self.updateJsTraceLogDate();
        
        let sTraceMsg = "["+self.sHostName2+"-"+self.sCurrentDate+"] "+clsName+"| "+sClsDisp+" - "+sTraceClsMsg!;
            
        if (sTraceClsMsg?.isEmpty == true)
        {
            
            print("");
            
            if (jsTraceRegistration1.bClsFileLog == true)
            {
                
                let bWriteFile = JsFileIO.writeFile(sFilespec: jsTraceRegistration1.sClsFilespec, sContents:" \n");
                
                if (self.bClsTraceInternal == true)
                {
                    
                    print("<internal> ...writing I/O [ ] to file [\(String(describing: jsTraceRegistration1.sClsFilespec))] returning [\(bWriteFile)]...");
                    
                }

            }
            
        }
        else
        {
            
            print(sTraceMsg);
            
            if (jsTraceRegistration1.bClsFileLog == true)
            {
                
                let bWriteFile = JsFileIO.writeFile(sFilespec: jsTraceRegistration1.sClsFilespec, sContents:sTraceMsg+"\n");
                
                if (self.bClsTraceInternal == true)
                {
                    
                    print("<internal> ...writing I/O [\(sTraceMsg)] to file [\(String(describing: jsTraceRegistration1.sClsFilespec))] returning [\(bWriteFile)]...");
                    
                }

            }
            
        }
        
        return;
        
    } // End of public func jsTraceLogMsg().
    
    public func updateJsTraceLogDate()
    {
        
        self.dtCurrent    = NSDate();
        self.sCurrentDate = self.dtFormatter.string(from: self.dtCurrent as Date);
        
    } // End of public func updateJsTraceLogDate().
    
    public func jsTraceLogSayStart(sTraceCls:String)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = ClassInfo.sClsDisp+"'"+sCurrMethod+"()'";
        
        self.updateJsTraceLogDate();
        
        self.jsTraceLogMsg(clsName: sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:ClassInfo.sClsCopyRight);
        self.jsTraceLogMsg(clsName: sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Starting execution on [\(self.sHostName2)] at [\(self.sCurrentDate)]...");
        self.jsTraceLogMsg(clsName: sTraceCls, sTraceClsDisp:"", sTraceClsMsg:"");
        
    } // End of public func jsTraceLogSayStart().
    
    public func jsTraceLogSayStop(sTraceCls:String)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = ClassInfo.sClsDisp+"'"+sCurrMethod+"()'";
        
        self.updateJsTraceLogDate();
        
        self.jsTraceLogMsg(clsName: sTraceCls, sTraceClsDisp:"", sTraceClsMsg:"");
        self.jsTraceLogMsg(clsName: sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"Stopping execution on [\(self.sHostName2)] at [\(self.sCurrentDate)]...");
        self.jsTraceLogMsg(clsName: sTraceCls, sTraceClsDisp:"", sTraceClsMsg:"");
        
    } // End of public func jsTraceLogSayStop().
    
    public func jsTraceLogSayHello(sTraceCls:String)
    {
        
        let sCurrMethod:String = #function;
        let sCurrMethodDisp    = ClassInfo.sClsDisp+"'"+sCurrMethod+"()'";
        
        self.updateJsTraceLogDate();
        
        self.jsTraceLogMsg(clsName: sTraceCls, sTraceClsDisp:sCurrMethodDisp, sTraceClsMsg:"'Hello'!");
        
    } // End of public func jsTraceLogSayHello().
    
} // End of public class JsTraceLog.

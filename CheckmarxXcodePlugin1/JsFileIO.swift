//
//  JsFileIO.swift
//  Swift_CommandLine_Library
//
//  Created by Daryl Cox on 4/18/15.
//  Copyright (c) 2015-2019 JWebSoftware. All rights reserved.
//

import Foundation

// Implementation class to handle File I/O (Input/Output).

public class JsFileIO
{
    
    struct ClassInfo
    {
        
        static let sClsId        = "JsFileIO";
        static let sClsVers      = "v4.0905";
        static let sClsDisp      = sClsId+".("+sClsVers+"): ";
        static let sClsCopyRight = "Copyright (C) JWebSoftware 2015-2019. All Rights Reserved.";
        static let bClsTrace     = false;
        static let bClsFileLog   = false;
        
    } // End of struct ClassInfo.
    
    class public func toString()->String
    {
        
        var asToString:[String] = Array();
        
        asToString.append("[");
        asToString.append("'sClsId': [\(ClassInfo.sClsId)],");
        asToString.append("'sClsVers': [\(ClassInfo.sClsVers)],");
        asToString.append("'sClsDisp': [\(ClassInfo.sClsDisp)],");
        asToString.append("'sClsCopyRight': [\(ClassInfo.sClsCopyRight)],");
        asToString.append("'bClsTrace': [\(ClassInfo.bClsTrace)],");
        asToString.append("'bClsFileLog': [\(ClassInfo.bClsFileLog)]");
        asToString.append("]");
        
        let sContents:String = "{"+(asToString.joined(separator: ""))+"}";
        
        return sContents;
        
    } // End of class public func toString().
    
    class public func fileExists(sFilespec:String)->Bool
    {
        
        let sTestFilespec:String = JsFileIO.stripQuotesFromFile(sFilespec: sFilespec);
        
        return FileManager().fileExists(atPath: sTestFilespec);
        
    } // End of class public func fileExists().
    
    class public func stripQuotesFromFile(sFilespec:String)->String
    {
        
        var sTestFilespec:String = sFilespec;
        
        if (sTestFilespec.first == "'" ||
            sTestFilespec.first == "\"")
        {
            
            sTestFilespec = String(sTestFilespec.dropFirst(1));
            
        }
        if (sTestFilespec.last == "'" ||
            sTestFilespec.last == "\"")
        {
            
            sTestFilespec = String(sTestFilespec.dropLast(1));
            
        }
        
        return sTestFilespec;
        
    } // End of class public func stripQuotesFromFile().
    
    class public func readFile(sFilespec:String, nsEncoding:String.Encoding = String.Encoding.utf8)->String?
    {
        
        var sCurrFilespec:String = sFilespec;

        if (sCurrFilespec.hasPrefix("~/") == true)
        {

            sCurrFilespec = NSString(string: sCurrFilespec).expandingTildeInPath as String;

        }

        if JsFileIO.fileExists(sFilespec: sCurrFilespec)
        {
            
            return try? String(contentsOfFile:sCurrFilespec, encoding:nsEncoding);
            
        }
        
        return nil;
        
    } // End of class public func readFile().
    
    class public func readFileLines(sFilespec:String, nsEncoding:String.Encoding = String.Encoding.utf8)->[String]?
    {
        
        var sCurrFilespec:String = sFilespec;

        if (sCurrFilespec.hasPrefix("~/") == true)
        {

            sCurrFilespec = NSString(string: sCurrFilespec).expandingTildeInPath as String;

        }

        if JsFileIO.fileExists(sFilespec: sCurrFilespec)
        {
            
            let sDataRead           = (try? String(contentsOfFile:sCurrFilespec, encoding:nsEncoding)) ?? "";
            let asDataRead:[String] = sDataRead.components(separatedBy: "\n");
            
            return asDataRead;
            
        }
        
        return nil;
        
    } // End of class public func readFileLines().
    
    class public func writeFile(sFilespec:String, sContents:String, bAppendToFile:Bool = true, nsEncoding:String.Encoding = String.Encoding.utf8)->Bool
    {
        
        var sCurrFilespec:String = sFilespec;

        if (sCurrFilespec.hasPrefix("~/") == true)
        {

            sCurrFilespec = NSString(string: sCurrFilespec).expandingTildeInPath as String;

        }

        let sCurrFilepath = (sCurrFilespec as NSString).deletingLastPathComponent;

        do
        {

            try FileManager.default.createDirectory(atPath: sCurrFilepath, withIntermediateDirectories: true, attributes: nil)

        }
        catch
        {

            print("'[\(String(describing: ClassInfo.sClsId))].writeFile(...)' - Failed to create the 'path' of [\(sCurrFilepath)] - Error: \(error)...");

        }

        if (bAppendToFile == false)
        {
            
            do
            {
                
                try sContents.write(toFile: sCurrFilespec, atomically:true, encoding:nsEncoding);
                
                return true;
                
            }
            catch _
            {
                
                return false;
                
            }
            
        }
        
        let nsOutputStream = OutputStream(toFileAtPath:sCurrFilespec, append:bAppendToFile);
        
        if (nsOutputStream == nil)
        {
            
            return false;
            
        }
        
        nsOutputStream?.open();
        
        nsOutputStream?.write(sContents, maxLength:sContents.lengthOfBytes(using: nsEncoding));
        
        nsOutputStream?.close();
        
        return true;
        
    } // End of class public func writeFile().
    
    class public func writeFileLines(sFilespec:String, asContents:[String], bAppendToFile:Bool = true, nsEncoding:String.Encoding = String.Encoding.utf8)->Bool
    {
        
        var sCurrFilespec:String = sFilespec;

        if (sCurrFilespec.hasPrefix("~/") == true)
        {

            sCurrFilespec = NSString(string: sCurrFilespec).expandingTildeInPath as String;

        }

        let sCurrFilepath = (sCurrFilespec as NSString).deletingLastPathComponent;

        do
        {

            try FileManager.default.createDirectory(atPath: sCurrFilepath, withIntermediateDirectories: true, attributes: nil)

        }
        catch
        {

            print("'[\(String(describing: ClassInfo.sClsId))].writeFileLines(...)' - Failed to create the 'path' of [\(sCurrFilepath)] - Error: \(error)...");

        }

        let sContents:String = asContents.joined(separator: "\n");
        
        if (bAppendToFile == false)
        {
            
            do
            {
                
                try sContents.write(toFile: sCurrFilespec, atomically:true, encoding:nsEncoding);
                
                return true;
                
            }
            catch _
            {
                
                return false;
                
            }
            
        }
        
        let nsOutputStream = OutputStream(toFileAtPath:sCurrFilespec, append:bAppendToFile);
        
        if (nsOutputStream == nil)
        {
            
            return false;
            
        }
        
        nsOutputStream?.open();
        
        nsOutputStream?.write(sContents, maxLength:sContents.lengthOfBytes(using: nsEncoding));
        
        nsOutputStream?.close();
        
        return true;
        
    } // End of class public func writeFileLines().
    
    class public func convertHFSFilespecToUnix(sHFSFilespec:String? = nil)->String?
    {
  
        if (sHFSFilespec == nil)
        {
  
            return nil;
  
        }

        let sStdFilespec = sHFSFilespec!.replacingOccurrences(of: ":", with: "/", options: String.CompareOptions.literal, range: nil);
  
        return ("/Volumes/\(sStdFilespec)");
        
    } // End of public func convertHFSFilespecToUnix().
  
} // End of public class JsFileIO.


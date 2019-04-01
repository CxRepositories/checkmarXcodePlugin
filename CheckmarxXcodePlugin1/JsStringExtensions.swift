//
//  JsStringExtensions.swift
//  Swift_CommandLine_Library
//
//  Created by Daryl Cox on 5/19/16.
//  Copyright (c) 2016-2018 JWebSoftware. All rights reserved.
//

import Foundation

// Extension class to add extra method(s) to String - v4.0401.

extension String
{
    
    var length:Int
    {
        
        get
        {
            
            return self.count;
            
        }
        
    } // END of var 'length'.
    
    func containsString(s:String)->Bool
    {
        
        let rangeSearch = self.range(of: s);
        
        return rangeSearch != nil ? true : false;
        
    } // END of func containsString().
    
    func containsStringIgnoreCase(s:String)->Bool
    {
        
        let rangeSearch = self.range(of: s, options:.caseInsensitive);
        
        return rangeSearch != nil ? true : false;
        
    } // END of func containsString().
    
    func stringByReplacingAllOccurrencesOfString(target:String, withString:String)->String
    {

        return self.replacingOccurrences(of: target, with: withString, options: String.CompareOptions.literal, range: nil);

    } // END of func stringByReplacingAllOccurrencesOfString().
    
    func subString(startIndex:Int, length:Int)->String
    {
        
        let cStartIndex = self.index(self.startIndex, offsetBy: startIndex);
        let cEndIndex   = self.index(self.startIndex, offsetBy: (startIndex + length));
        
        return String(self[cStartIndex..<cEndIndex]);
        
    } // END of func subString().
    
    func indexOfString(target:String)->Int
    {

        return self.indexOfString(target: target, startIndex: 0);
        
    } // END of func indexOfString(target).
    
    func indexOfString(target:String, startIndex:Int)->Int
    {
        
        let substringIndex         = self.index(self.startIndex, offsetBy: startIndex);
        let sSearchString: String? = String(self[substringIndex..<self.endIndex]);
        
        if let svSearchString = sSearchString
        {
            
            if let rangeOfSubstring = svSearchString.range(of:target)
            {
                
                return (self.distance(from: self.startIndex, to: rangeOfSubstring.lowerBound) + startIndex);
                
            }
            
        }
        
        return -1;
        
    } // END of func indexOfString(target, startIndex).
    
    func lastIndexOfString(target:String)->Int
    {
        
        var index     = -1;
        var stepIndex = self.indexOfString(target: target);
        
        while (stepIndex > -1)
        {
            
            index = stepIndex;
            
            if ((stepIndex + target.length) < self.length)
            {
                
                stepIndex = self.indexOfString(target: target, startIndex: (stepIndex + target.length));
                
            }
            else
            {
                
                stepIndex = -1;
                
            }
            
        }
        
        return index;
        
    } // END of func lastIndexOfString(target).
    
    func rightPartitionStrings(target:String)->[String]?
    {
        
        let partitionIndex = self.lastIndexOfString(target: target);
        
        if (partitionIndex < 0)
        {
            
            return nil;
            
        }
        
        //            1         2         3         4         5
        //  0123456789+123456789+123456789+123456789+123456789+
        // "/Volumes/MacMini HD/work/Video/DSC00181.jpg"
        //  123456789+123456789+123456789+123456789+123456789+
        //           1         2         3         4         5
        
        let sLeftPartition  = self.subString(startIndex: 0, length:partitionIndex);
        let sRightPartition = self.subString(startIndex: (partitionIndex + target.length), length:(self.length - partitionIndex - target.length));
        
        return [sLeftPartition, target, sRightPartition];
        
    } // END of func rightPartitionStrings(target).
    
    func leftPartitionStrings(target:String)->[String]?
    {
        
        let partitionIndex = self.indexOfString(target: target);
        
        if (partitionIndex < 0)
        {
            
            return nil;
            
        }
        
        //            1         2         3         4         5
        //  0123456789+123456789+123456789+123456789+123456789+
        // "/Volumes/MacMini HD/work/Video/DSC00181.jpg"
        //  123456789+123456789+123456789+123456789+123456789+
        //           1         2         3         4         5
        
        let sLeftPartition  = self.subString(startIndex: 0, length:partitionIndex);
        let sRightPartition = self.subString(startIndex: (partitionIndex + target.length), length:(self.length - partitionIndex - target.length));
        
        return [sLeftPartition, target, sRightPartition];
        
    } // END of func leftPartitionStrings(target).
    
//  public var expandingTildeInPath: String
    func expandTildeInString() -> String
    {
        
        return NSString(string: self).expandingTildeInPath as String;
        
    } // End of var expandingTildeInString().
        
} // END of extension String.

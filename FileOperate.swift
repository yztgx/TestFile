//
//  FileOperate.swift
//  TestFile
//
//  Created by yztgx on 16/11/22.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Foundation

class FileOperate{
    var fileName = ""

    init(fileName: String,isLocal:Bool = true)
    {
        if isLocal == true {
            self.fileName = Bundle.main.bundlePath + "/" + fileName
        }
        else
        {
            self.fileName = fileName
        }
    }
    
    func ReadFile()->Data?
    {

        let manager = FileManager.default
        let data = manager.contents(atPath: fileName)
        if data == nil{
          return nil
        }
        //let strData = Decode(data: data!)
        
        return data
    }
    func ReadFiletoString()->NSString?
    {
        
        let manager = FileManager.default
        let data = manager.contents(atPath: fileName)
        if data == nil{
            return nil
        }
        let strData = Decode(data: data!)
        
        return strData
    }
    
    func WriteFile(strdata: String)
    {
        let data = Encode(string: strdata)
        let url = NSURL(fileURLWithPath: fileName)
        MoveFile()
        try?  data?.write(to: url as URL)
        
    }
    
    func MoveFile()
    {
        let toFile = fileName + ".bak"
        let fromURL = NSURL(fileURLWithPath: fileName)
        let toURL = NSURL(fileURLWithPath: toFile)
        let manager = FileManager.default
        try? manager.moveItem(at: fromURL as URL, to: toURL as URL)

    }
    func CopyFile()
    {
        let fromURL = NSURL(fileURLWithPath: "/Users/yztgx/Desktop/Code/myProject/pass.xml")
        let toURL = NSURL(fileURLWithPath: fileName)
        let manager = FileManager.default
        try? manager.copyItem(at: fromURL as URL, to: toURL as URL)
    }
    
    func DeleteFile()
    {
        let manager = FileManager.default
        try? manager.removeItem(atPath: fileName)

    }

    
    func CheckFileValid(str: String)->Bool
    {
        return str.contains("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
    }
    
    
    func Decode(data: Data)->NSString?
    {
        let strdata = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return strdata
    }
    func Encode(string: String)->Data?
    {
        let data = string.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return data
        
    }

}

//
//  PassXMLParse.swift
//  TestFile
//
//  Created by yztgx on 16/11/23.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Foundation






class PassXMLParse: NSObject,XMLParserDelegate
{
    var m_parserXML: XMLParser?
    
    var m_passList =  [PassInfo]()
    var m_passValue = PassInfo()
    var m_categoryList = [CategoryInfo]()
    var m_categoryValue = CategoryInfo()
    
    var m_currentNodeName: String = ""
    
    func StartParse(data: Data)
    {
        m_parserXML = XMLParser(data: data)
        
        if m_parserXML == nil {
            return
        }
        m_parserXML?.delegate = self
        m_parserXML?.parse()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Start Parse XML File")
    }
    func parserDidEndDocument(_ parser: XMLParser) {
       // print("=========================")
//        print("CategoryList:\n \(m_categoryList)")
//        print("PassList: \n \(m_passList)")
        print("End Parse XML File")
    }
    
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        print("start \(elementName),\(attributeDict)")
        //节点解析开始，判断当前节点是否为group，如果是，则开始新一条PassInfo记录
        //如果是其中某一值，则设置当前节点为改值
        if elementName == "Passinfo"
        {
            m_currentNodeName = ""
            
            m_passValue = PassInfo()
            
            if let passid = attributeDict["ID"]
            {
                m_passValue.ID = Int(passid)!
            }
            if let cateid = attributeDict["CategoryID"]
            {
                m_passValue.CategoryID = Int(cateid)!
            }

        }
        else if elementName == "Category"
        {
            m_currentNodeName = ""
            m_categoryValue = CategoryInfo()
            if let id = attributeDict["ID"]
            {
                m_categoryValue.ID = Int(id)!
            }
            if let isDefault = attributeDict["Default"]
            {
                if (isDefault == "0")
                {
                    m_categoryValue.isDefault = false
                }
                else
                {
                    m_categoryValue.isDefault = true
                }
            }
            if let name = attributeDict["Name"]
            {
                m_categoryValue.Name = name
            }
            if let image = attributeDict["Image"]
            {
                m_categoryValue.Image = image
            }
            print("\(m_categoryValue)")
        }
        else
        {
            m_currentNodeName = elementName
            
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        print("end \(elementName)")
        
        //节点解析结束，设置当前节点为空，防止误解析
        if elementName == "Passinfo"
        {
            m_passList.append(m_passValue)
            m_currentNodeName = ""
        }else if elementName == "Category"
        {
            m_categoryList.append(m_categoryValue)
            m_currentNodeName = ""
        }

        
        
    }

    func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
        print("\(m_currentNodeName):\(attributeName):\(elementName):\(type):\(defaultValue)")

    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("\(m_currentNodeName):\(string)")
        let strValue = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !strValue.isEmpty
        {
            switch m_currentNodeName
            {
                case "Name": m_passValue.Name = strValue
                case "User": m_passValue.Username = strValue
                case "Pass": m_passValue.Password = strValue
                case "URL": m_passValue.URL = strValue
                case "Tel": m_passValue.Tel = strValue
                case "Mail":m_passValue.Mail = strValue
                case "Serial": m_passValue.Serial = strValue
                case "Image": m_passValue.Image = strValue

            default:break
            }
        }
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
}



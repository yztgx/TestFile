//
//  DataManager.swift
//  TestFile
//
//  Created by yztgx on 16/11/23.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Foundation

struct PassInfo{
    var ID: Int = 0
    var CategoryID: Int = 0
    var Important: Bool = false
    var Favorite: Bool = false
    var Name: String = ""
    var URL: String = ""
    var Username: String = ""
    var Password: String = ""
    var Tel: String = ""
    var Mail: String = ""
    var Serial: String = ""
    var Image: String = ""
}

struct CategoryInfo{
    var ID: Int = 0
    var Name: String = ""
    var isDefault: Bool = false
    var Image: String = ""
}

enum Order : String{
    case Name
    case URL
    case Tel
    case Mail
    case Pass
    case ID
    
}

let CATEGORY_ALL        = 0
let CATEGORY_FAVORITE   = 1

    
func sortList(Key: Order,sortAsc: Bool, passList: inout [PassInfo])
{
    if sortAsc {
        switch Key {
        case .Name:
            passList.sort(by: {$0.Name > $1.Name})
        case .ID:
            passList.sort(by: {$0.ID > $1.ID})
        case .Pass:
            passList.sort(by: {$0.Password > $1.Password})
        case .Mail:
            passList.sort(by: {$0.Mail > $1.Mail})
        case .Tel:
            passList.sort(by: {$0.Tel > $1.Tel})
        case .URL:
            passList.sort(by: {$0.URL > $1.URL})
        }
    }else{
        switch Key {
        case .Name:
            passList.sort(by: {$0.Name < $1.Name})
        case .ID:
            passList.sort(by: {$0.ID < $1.ID})
        case .Pass:
            passList.sort(by: {$0.Password < $1.Password})
        case .Mail:
            passList.sort(by: {$0.Mail < $1.Mail})
        case .Tel:
            passList.sort(by: {$0.Tel < $1.Tel})
        case .URL:
            passList.sort(by: {$0.URL < $1.URL})
        }
        
    }
}



class DataManager: NSObject
{
    private var m_categoryList = [CategoryInfo]()
    private var m_passList_ALL = [PassInfo]()
    
    override init()
    {
        let file = FileOperate(fileName: "pass.xml")
        file.DeleteFile()       //swift copy函数无法覆盖，只能先删除
        file.CopyFile()         //从测试目录Copy到工作目录,
        
        let data = file.ReadFile()
        let passXML = PassXMLParse()
        passXML.StartParse(data: data!)
        m_categoryList = passXML.m_categoryList
        m_passList_ALL = passXML.m_passList
    }
    
    func GetPassbyCategory(categoryID:Int)->[PassInfo]
    {
        var passList = [PassInfo]()
        
        
        for passValue in m_passList_ALL{
            if (categoryID == CATEGORY_ALL){
                passList = m_passList_ALL
                break
                
            }
            else if (categoryID == CATEGORY_FAVORITE)
            {
                if passValue.Favorite == true{
                    passList.append(passValue)
                }
                
            }
            else if (categoryID >= 10)
            {
                if passValue.CategoryID == categoryID{
                    passList.append(passValue)
                }
            }
        }
        
        
        return passList
    }
    
    func ModifyPass(passValue: PassInfo)
    {
        var index = 0
        for passValue_index in m_passList_ALL{
            if passValue_index.ID == passValue.ID{
                m_passList_ALL[index] = passValue
                return
            }
            index = index + 1
        }
    }
    
    func AddPass(passValue: PassInfo)
    {
        var maxID = 0
        var passValue_new = passValue
        for passValue_index in m_passList_ALL{
            if passValue_index.ID > maxID{
               maxID = passValue_index.ID
            }
            maxID = maxID + 1
        }
        passValue_new.ID = maxID
        m_passList_ALL.append(passValue_new)
        
    }
    
    func CombinXML()
    {
        let xmldocument = XMLDocument()
        let xmlnode = XMLNode()
        xmlnode.name = "good"
        xmldocument.addChild(xmlnode)
        
        print("\(xmldocument)")
    }
  
}

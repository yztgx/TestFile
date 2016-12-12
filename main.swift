//
//  main.swift
//  TestFile
//
//  Created by yztgx on 16/11/22.
//  Copyright © 2016年 yztgx. All rights reserved.
//

import Foundation

print("Hello, World!")



//计算规则：1-5分，1极不安全，5最安全
//默认1分、包含数字+1分，包含字母+1分，长度超过6 +1,包含特殊符号+1
//每个字符之间相减值相同者减1分

func CheckPassSafe(password: String)->Int
{
    var numpassList = [UInt32]()
    var numReduceList = [Int]()
    var numCount = 0
    var numNum = 0
    var numChar = 0
    var numSpecial = 0
    var numReduceCompare = -1
    for ch in password.unicodeScalars
    {
        numpassList.append(UnicodeScalar(ch).value)
        
    }
    
    if numpassList.count >= 6
    {
        numCount = 1
    }
    
    var oldnum: UInt32 = 0
    var reduce: Int = 0
    for num in numpassList
    {
        if (num >=  UnicodeScalar("0")!.value && num <=  UnicodeScalar("9")!.value)
        {
            numNum =  1
        }else   if ((num >=  UnicodeScalar("a")!.value && num <=  UnicodeScalar("z")!.value) ||
            (num >=  UnicodeScalar("A")!.value && num <=  UnicodeScalar("Z")!.value))
        {
            numChar = 1
        }
        else{
            numSpecial = 1
        }
        if oldnum != 0
        {
            reduce = Int(num) - Int(oldnum)
            numReduceList.append(reduce)
        }
        oldnum = num
    }
    
    if numReduceList.count > 2
    {
        let numReduceTmp = numReduceList[0]
        for numReduceIndex in numReduceList
        {
            if numReduceTmp != numReduceIndex
            {
                numReduceCompare = 0
                break
            }
        }
    }

  
    return numCount+numNum+numChar+numSpecial+numReduceCompare
}

let pass = "123456"
let retCode = CheckPassSafe(password: pass)
print("\(retCode)")


let  fileName:String = Bundle.main.bundlePath + "/pass.xml"

print(fileName)



let file = FileOperate(fileName: "pass.xml")
file.DeleteFile()       //swift copy函数无法覆盖，只能先删除
file.CopyFile()         //从测试目录Copy到工作目录,
var str = file.ReadFiletoString()
print(str)

//var str2 = str as! String
//
//
//str2 = str2 + "================================"
//file.WriteFile(strdata: str2)

let data = file.ReadFile()
let passXML = PassXMLParse()
passXML.StartParse(data: data!)
let categoryList = passXML.m_categoryList
let passList = passXML.m_passList
//
//print("CategoryList:\n \(categoryList)")
//print("PassList: \n \(passList)")


//NSXMLNode
//NSXMLDocument
//NSXMLElement
//NSXMLDTD
//NSXMLDTDNode

var xmldocument = try?XMLDocument(data: data!, options: Int(XMLDocument.ContentKind.text.rawValue))
xmldocument?.isStandalone = false
print("\(xmldocument)")

var rootelement = xmldocument?.rootElement()

var baseinfoElement = rootelement?.elements(forName: "DataBaseInfo")

print("\(baseinfoElement)")

var categorylistElement = rootelement?.elements(forName: "CategoryList")
print("\(categorylistElement)")


var passlistElement = rootelement?.elements(forName: "PassList")

var passinfoElement = passlistElement?[0].elements(forName: "Passinfo")
for index in 0..<passinfoElement!.count
{
    print("\(passinfoElement?[index])")
    var passnameElement = passinfoElement?[index].elements(forName: "Name")
    print("xmlstring:\(passnameElement?[0].xmlString)")
    print("stringValue:\(passnameElement?[0].stringValue)")
}

var ele = XMLElement()
ele.name = "Name"
ele.setStringValue("中华人民共和国",resolvingEntities: false)
var pass2ele = XMLElement(name: "Passinfo")


var attr = [String: String]()
attr = ["categoryid":  "1","import":"1"]
attr["favirity"] = "1"


pass2ele.setAttributesWith(attr)


func SetDataBaseInfo()->XMLElement
{
    let dataBaseInfo = ["Software":"YoPass",
                        "Ver":"1.0",
                        "User":" ",
                        "Date":" "]
    let nodeBase = XMLElement(name: "DataBaseInfo")
    //        <DataBaseInfo>
    //        <SoftName>YoPass</SoftName>		//用来校验数据解密是否正确
    //        <Ver>1.0</Ver>
    //        <User></User>	//当前用户
    //        <Date></Date>	//数据库修改日期
    //        </DataBaseInfo>
    
    var nodeBaseChild = XMLElement()
    for (key,value) in dataBaseInfo
    {
        nodeBaseChild = XMLElement()
        nodeBaseChild.name = key
        nodeBaseChild.stringValue = value
        nodeBase.addChild(nodeBaseChild)
    }
    return nodeBase
    
}


func FillCategoryStruct()->[CategoryInfo]
{
    var categoryList = [CategoryInfo]()
    var categoryValue = CategoryInfo(ID: 0, Name: "All", isDefault: true, Image: "cate_1")
    categoryList.append(categoryValue)
    categoryValue = CategoryInfo(ID: 1, Name: "Favorite", isDefault: true, Image: "cate_2")
    categoryList.append(categoryValue)
    categoryValue = CategoryInfo(ID: 10, Name: "Web", isDefault: true, Image: "cate_3")
    categoryList.append(categoryValue)
    categoryValue = CategoryInfo(ID: 11, Name: "Software", isDefault: true, Image: "cate_4")
    categoryList.append(categoryValue)
    categoryValue = CategoryInfo(ID: 12, Name: "Bank", isDefault: true, Image: "cate_5")
    categoryList.append(categoryValue)
    return categoryList
    
}


func SetCategoryList(categoryList: [CategoryInfo])->XMLElement
{
    let nodeCategoryList = XMLElement(name: "CategoryList")
    var nodeCategory: XMLElement
    //    <CategoryList>
//  		<Category ID = "0" Default= "1" Name="ALL" Image= "cate_1" />
//            <Category ID = "1" Default= "1" Name="Favorite" Image= "cate_2" />
//                <Category ID = "10" Default= "1" Name="Web" Image= "cate_3" />
//                    <Category ID = "11" Default= "1" Name="Software" Image= "cate_4" />
//                        <Category ID = "12" Default= "1" Name="Bank" Image= "cate_5" />
//                            </CategoryList>
    var attr = [String: String]()
    for categoryValue in categoryList
    {
        nodeCategory = XMLElement(name: "Category")
        attr["ID"] = String(categoryValue.ID)
        attr["Default"]  = categoryValue.isDefault ?"1":"0"
        attr["Name"] = categoryValue.Name
        attr["Image"] = categoryValue.Image
        nodeCategory.setAttributesWith(attr)
        nodeCategoryList.addChild(nodeCategory)
    }
    print("node Category\n\(nodeCategoryList)")
    return nodeCategoryList
}

func SetPassList(passList: [PassInfo])->XMLElement
{
    let nodepassList = XMLElement(name: "PassList")
   
    var nodepass: XMLElement
//    <Passinfo ID = "1" CategoryID= "10" Important = "1" Favorite = "1">
//    <Name>google</Name>
//    <URL>https://www.google.com</URL>
//    <Username>superman</Username>
//    <Password>123456</Password>
//    <Tel>13800138000</Tel>
//    <Mail>superman@gmail.com</Mail>
//    <Image>pass_1</Image>
//    </Passinfo>

    var attr = [String: String]()
    var passItemName : XMLElement
    var passItemURL: XMLElement
    var passItemUserName : XMLElement
    var passItemPassword : XMLElement
    var passItemTel :XMLElement
    var passItemMail: XMLElement
    var passItemImage: XMLElement
    
    for passValue in passList
    {
        nodepass = XMLElement(name: "PassInfo")
        passItemName = XMLElement(name: "Name", stringValue: passValue.Name)
        passItemURL = XMLElement(name: "URL", stringValue: passValue.URL)
        passItemUserName = XMLElement(name: "Username", stringValue: passValue.Username)
        passItemPassword = XMLElement(name: "Password", stringValue: passValue.Password)
        passItemTel = XMLElement(name: "Tel", stringValue: passValue.Tel)
        passItemMail = XMLElement(name: "Mail", stringValue: passValue.Mail)
        passItemImage = XMLElement(name: "Image", stringValue: passValue.Image)
        nodepass.addChild(passItemName)
        nodepass.addChild(passItemURL)
        nodepass.addChild(passItemUserName)
        nodepass.addChild(passItemPassword)
        nodepass.addChild(passItemTel)
        nodepass.addChild(passItemMail)
        nodepass.addChild(passItemImage)

        attr["ID"] = String(passValue.ID)
        attr["CategoryID"]  = String(passValue.CategoryID)
        attr["Important"] = passValue.Important ?"1":"0"
        attr["Favorite"] = passValue.Favorite ?"1":"0"
        nodepass.setAttributesWith(attr)
        nodepassList.addChild(nodepass)
    }
    print("node passList\n\(nodepassList)")
    return nodepassList
}


let datainfo = SetDataBaseInfo()
let cateDateList = FillCategoryStruct()
let cateList = SetCategoryList(categoryList: cateDateList)
var passlist = SetPassList(passList: passList)

passlist.addChild(pass2ele)
var root = XMLElement(name: "DataBase")


root.addChild(datainfo)
root.addChild(cateList)
root.addChild(passlist)

//var xmlnewDoc = try?XMLDocument(rootElement: root)
var xmlnewDoc = try?XMLDocument(rootElement: root)
xmlnewDoc?.isStandalone = true
xmlnewDoc?.characterEncoding = "UTF-8"

print("\(xmlnewDoc?.xmlString)")




//print("finish\(xmldocument)")



print("finish")


//
//  RealmDataList.swift
//  MyWords
//
//  Created by Apple on 2020/05/24.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//


import RealmSwift

class RealmDataList: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var English = ""
    @objc dynamic var Japanese = ""
    @objc dynamic var Miss1 = 0
    @objc dynamic var Miss2 = 0
    @objc dynamic var Miss3 = 0
    @objc dynamic var Miss4 = 0
    
    @objc dynamic var Memo = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}

class AppDetail: Object {
    
    @objc dynamic var tryTestCount = 0
    @objc dynamic var correctTest = 0
    @objc dynamic var memoText =  ""
}

class WordHistory: Object {
    @objc dynamic var allHis = 0
    @objc dynamic var miss1His = 0
    @objc dynamic var miss2His = 0
    @objc dynamic var miss3His = 0
    @objc dynamic var miss4His = 0
}






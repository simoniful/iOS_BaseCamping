//
//  RealmModel.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/22.
//

import Foundation
import RealmSwift

class PlaceInfo: Object {

    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var contentId: Int
    @Persisted var name: String
    @Persisted var address: String
    @Persisted var doName: String
    @Persisted var sigunguName: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var tel: String?
    @Persisted var lineIntro: String?
    @Persisted var intro: String?
    @Persisted var homepage: String?
    @Persisted var petAccess: String
    @Persisted var operatingPeriod: String?
    @Persisted var operatingDay: String?
    @Persisted var toiletCount: Int
    @Persisted var showerCount: Int
    @Persisted var facility: String?
    @Persisted var inDuty: String
    @Persisted var prmisnDe: String?
    @Persisted var insurance: String
    @Persisted var imageURL: String?
    @Persisted var isLiked: Bool

    convenience init(contentId: Int, name: String, address: String, doName: String, sigunguName: String, latitude: Double, longitude: Double, tel: String?, lineIntro: String?, intro: String?, homepage: String?, petAccess: String, operatingPeriod: String?, operatingDay: String?, toiletCount: Int, showerCount: Int, facility: String?, inDuty: String, prmisnDe: String?, insurance: String, imageURL: String?, isLiked: Bool) {
        self.init()
        self.contentId = contentId
        self.name = name
        self.address = address
        self.doName = doName
        self.sigunguName = sigunguName
        self.latitude = latitude
        self.longitude = longitude
        self.tel = tel
        self.lineIntro = lineIntro
        self.intro = intro
        self.homepage = homepage
        self.petAccess = petAccess
        self.operatingPeriod = operatingPeriod
        self.operatingDay = operatingDay
        self.toiletCount = toiletCount
        self.showerCount = showerCount
        self.facility = facility
        self.inDuty = inDuty
        self.prmisnDe = prmisnDe
        self.insurance = insurance
        self.imageURL = imageURL
        self.isLiked = isLiked
    }
}

class Review: Object {
    // 재방문 의사, 시설 만족도, 접근성, 서비스 만족도
    // 콘텐츠 제목, 내용
    // (opt) 사진
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var facilitySatisfaction: Int
    @Persisted var serviceSatisfaction: Int
    @Persisted var accessibility: Int
    @Persisted var revisitWill: Int
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var regDate: Date
    
    convenience init(facilitySatisfaction: Int, serviceSatisfaction: Int, accessibility: Int, revisitWill: Int, title: String, content: String, regDate: Date) {
        self.init()
        self.facilitySatisfaction = facilitySatisfaction
        self.serviceSatisfaction = serviceSatisfaction
        self.accessibility = accessibility
        self.revisitWill = revisitWill
        self.title = title
        self.content = content
        self.regDate = regDate
    }
}

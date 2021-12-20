//
//  PlaceModel.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/19.
//

import Foundation
import SwiftUI

struct WeatherInfo {
    let date: Int
    let minTemp: Double
    let maxTemp: Double
    let weatherIcon: String
    let weather: String
}

struct SocialMediaInfo {
    let type: String
    let title: String
    let link: String
    let description: String
}

struct AttractionInfo {
    let contentTypeId: Int
    let contentId: Int
    let title: String
    let thumbImgUrl: String
    let distance: Int
}

struct CommonInfo {
    let address: String
    let title: String
    let tel: String
    let homepage: String
    let overview: String
}

struct Tourist{
    let accomcount: String
    let chkbabycarriage: String
    let chkcreditcard: String
    let chkpet: String
    let expagerange: String
    let expguide: String
    let infocenter: String
    let parking: String
    let restdate: String
    let useseason: String
    let usetime: String
}

struct CulturalFacility {
    let accomcountculture: String
    let chkbabycarriageculture: String
    let chkcreditcardculture: String
    let chkpetculture: String
    let discountinfo: String
    let infocenterculture: String
    let parkingculture: String
    let parkingfee: String
    let restdateculture: String
    let usefee: String
    let usetimeculture: String
    let spendtime: String
}

struct Festival {
    let agelimit: String
    let bookingplace: String
    let discountinfofestival: String
    let eventenddate: String
    let eventhomepage: String
    let eventplace: String
    let eventstartdate: String
    let placeinfo: String
    let playtime: String
    let program: String
    let spendtimefestival: String
    let sponsor1: String
    let sponsor1tel: String
    let subevent: String
    let usetimefestival: String
}

struct Leisure {
    let accomcountleports: String
    let chkbabycarriageleports: String
    let chkcreditcardleports: String
    let chkpetleports: String
    let expagerangeleports: String
    let infocenterleports: String
    let openperiod: String
    let parkingfeeleports: String
    let parkingleports: String
    let reservation: String
    let restdateleports: String
    let usefeeleports: String
    let usetimeleports: String
}

struct Shopping {
    let chkbabycarriageshopping: String
    let chkcreditcardshopping: String
    let chkpetshopping: String
    let culturecenter: String
    let fairday: String
    let infocentershopping: String
    let opendateshopping: String
    let opentime: String
    let parkingshopping: String
    let restdateshopping: String
    let restroom: String
    let saleitem: String
    let saleitemcost: String
    let scaleshopping: String
    let shopguide: String
}

struct Restaurant {
    let chkcreditcardfood: String
    let discountinfofood: String
    let firstmenu: String
    let infocenterfood: String
    let kidsfacility: String
    let opentimefood: String
    let packing: String
    let parkingfood: String
    let reservationfood: String
    let restdatefood: String
    let seat: String
    let smoking: String
    let treatmenu: String
}

// items
struct DetailInfo {
    let infoname: String
    let infotext: String
}



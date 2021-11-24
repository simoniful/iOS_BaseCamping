//
//  Constant.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/19.
//

import Foundation

struct APIKey {
    static let weather = "10a92bf3718f5bb3f66bfcf3f0381435"
    static let goCamping = "VhQyqmJBTI5OHaBSbycNhPjv08lRiZsXpooOaou5AXJR%2F9lcCfqnGuYzsja6C9XuSkUUPRBH7ghkRPn5gSL9Yw%3D%3D"
    static let navetBlogId = "wE5Nze7qwvLYACNQw8FX"
    static let naverBlogSecret = "tebcgxqL8e"
    static let youtube = "AIzaSyAwPMjR_6Hv-5fb8cSYBAMGuEE78h9T0a0"
}

struct Endpoint {
    static let weatherURL = "https://api.openweathermap.org/data/2.5/onecall"
    // ?lat=37.57150480578691&lon=126.96624778295205&exclude=current,minutely,hourly,alerts&appid=\(APIKey.weather)&units=metric&lang=kr"
    static let weatherIconURL = "https://openweathermap.org/img/wn"
    /* /02d@2x.png */
    static let goCampingBasedURL = "http://api.visitkorea.or.kr/openapi/service/rest/GoCamping/basedList"
    // ?ServiceKey=\(APIKey.goCamping)&MobileOS=IOS&MobileApp=BaseCamping&numOfRows=3000&pageNo=1&_type=json"
    static let goCampingLocationBasedURL = "http://api.visitkorea.or.kr/openapi/service/rest/GoCamping/locationBasedList"
    // ?serviceKey=\(APIKey.goCamping)&pageNo=1&numOfRows=10&MobileOS=IOS&MobileApp=BaseCamping&mapX=128.6142847&mapY=36.0345423&radius=2000
    // 기상관측소 별 위도/경도 활용
    static let goCampingSearchURL = "http://api.visitkorea.or.kr/openapi/service/rest/GoCamping/searchList"
    // ?serviceKey=\(APIKey.goCamping)&pageNo=1&numOfRows=10&MobileOS=IOS&MobileApp=BaseCamping&keyword=%EC%95%BC%EC%98%81%EC%9E%A5"
    static let goCampingImageURL = "http://api.visitkorea.or.kr/openapi/service/rest/GoCamping/imageList"
    // ?serviceKey=\(APIKey.goCamping)&MobileOS=IOS&MobileApp=BaseCamping&contentId=3429"
    static let naverBlogURL = "https://openapi.naver.com/v1/search/blog.json"
    // ?query=북한산 캠핑장&display=5
    static let youtubeURL = "https://www.googleapis.com/youtube/v3/search"
    // ?part=snippet&key=AIzaSyAwPMjR_6Hv-5fb8cSYBAMGuEE78h9T0a0&q=%EB%B6%81%ED%95%9C%EC%82%B0%20%EC%BA%A0%ED%95%91%EC%9E%A5&maxResults=5&type=video&videoEmbeddable=true
}

struct WeatherStation {
    static let locationDic : [String : [Double]] = [
        "서울특별시" : [37.57142, 126.9658],
        "경기도" : [37.26399, 127.48421],
        "인천광역시": [37.47772, 126.6249],
        "강원도" : [37.90262, 127.7357],
        "대전광역시" : [36.37198, 127.37211],
        "세종특별자치시" : [36.48522, 127.24438],
        "광주광역시" : [35.17294, 126.89156],
        "대구광역시" : [35.87797, 128.65295],
        "부산광역시" : [35.10468, 129.03203],
        "울산광역시" : [35.58237, 129.33469],
        "제주특별자치도" : [33.51411, 126.52969],
        "충청북도" : [36.97045, 127.9525],
        "충청남도" : [36.76217, 127.29282],
        "경상북도" : [36.03201, 129.38002],
        "경상남도" : [35.16378, 128.04004],
        "전라북도" : [35.84092, 127.11718],
        "전라남도" : [34.81732, 126.38151]
    ]
}

struct Region {
    var regionDic : [String : [String]] = [
        "서울특별시" : ["전체", "종로구", "중구", "용산구", "성동구", "광진구", "동대문구", "중량구", "성북구", "강북구", "도봉구", "노원구", "은평구", "서대문구", "마포구", "양천구", "강서구", "구로구", "금천구", "영등포구", "동작구", "관악구", "서초구", "강남구", "송파구", "강동구" ],
        "경기도" : [ "전체", "수원시", "성남시", "의정부시", "안양시", "부천시", "광명시", "동두천시", "평택시", "안산시", "고양시", "과천시", "구리시", "남양주시", " 오산시", "시흥시", "군포시", "의왕시", "하남시", "용인시", "파주시", "이천시", "안성시", "김포시", "화성시", "광주시", "양주시", "포천시", "여주시", "연천군", "가평군", "양평군" ],
        "인천광역시" : [ "전체", "중구", "동구", "미추홀구", "연수구", "남동구", "부평구", "계양구", "서구", "강화군", "옹진군" ],
        "강원도" : [ "전체", "춘천시", "원주시", "강릉시", "동해시", "태백시", "속초시", "삼척시", "홍천군", "횡성군", "영월군", "평창군", "정선군", "철원군", "화천군", "양구군", "인제군", "고성군","양양군" ],
        "대전광역시" : [ "전체", "동구", "중구", "서구", "유성구", "대덕구" ],
        "세종특별자치시": [ "전체" ],
        "광주광역시" : [ "전체", "동구", "서구", "남구", "북구", "광산구" ],
        "대구광역시" : [ "전체", "중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "달성군" ],
        "부산광역시" : [ "전체", "중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구", "강서구", "해운대구", "사하구", "금정구", "연제구", "수영구", "사상구", "기장군" ],
        "울산광역시" : [ "전체", "중구", "남구", "동구", "북구", "울주군" ],
        "제주특별자치도" : [ "전체", "제주시", "서귀포시" ],
        "충청북도" : [ "전체", "청주시", "충주시", "제천시", "보은군", "옥천군", "영동군", "증평군", "진천군", "괴산군", "음성군", "단양군" ],
        "충청남도" : [ "전체", "천안시", "공주시", "보령시", "아산시", "서산시", "논산시", "계룡시", "당진시", "금산군", "부여군", "서천군", "청양군", "홍성군", "예산군", "태안군" ],
        "경상북도" : [ "전체", "포항시", "경주시", "김천시", "안동시", "구미시", "영주시", "영천시", "상주시", "문경시", "경산시", "군위군", "의성군", "청송군", "영양군", "영덕군", "청도군", "고령군", "성주군", "칠곡군", "예천군", "봉화군", "울진군", "울릉군" ],
        "경상남도" : [ "전체", "창원시", "진주시", "통영시", "사천시", "김해시", "밀양시", "거제시", "양산시", "의령군", "함안군", "창녕군", "고성군", "남해군", "하동군", "산청군", "함양군", "거창군", "합천군" ],
        "전라북도" : [ "전체", "전주시", "군산시", "익산시", "정읍시", "남원시", "김제시", "완주군", "진안군", "무주군", "장수군", "임실군", "순창군", "고창군", "부안군" ],
        "전라남도" : [ "전체", "목포시", "여수시", "순천시", "나주시", "광양시", "담양군", "곡성군", "구례군", "고흥군", "보성군", "화순군", "장흥군", "강진군", "해남군", "영암군", "무안군", "함평군", "영광군", "장성군", "완도군", "진도군", "신안군" ]
    ]
}

//
//  AttractionDetailViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/12/13.
//

import UIKit
import Alamofire
import SwiftyJSON
import FSPagerView

class AttractionDetailViewController: UIViewController {
    
    var attractionInfo: AttractionInfo?
    var typeName: String?
    var commonData: CommonInfo?
    var introData: Any?
    var introString: String = ""
    var imagesString: [String] = [] {
        didSet {
            if imagesString.count == 0 {
                pagerView.isHidden = true
                bannerPlaceholderImageView.isHidden = false
            } else {
                pagerView.isHidden = false
                bannerPlaceholderImageView.isHidden = true
            }
            pagerView.reloadData()
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            self.pagerView.isInfinite = true
            self.pagerView.automaticSlidingInterval = 6.0
        }
    }
    @IBOutlet weak var bannerPlaceholderImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: BasePaddingLabel!
    @IBOutlet weak var telTextView: UITextView!
    @IBOutlet weak var homepageTextView: UITextView!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var infoTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        telTextView.textContainerInset = UIEdgeInsets(top: 6, left: 3, bottom: 4, right: 4)
        homepageTextView.textContainerInset = UIEdgeInsets(top: 6, left: 3, bottom: 4, right: 4)
        pagerView.delegate = self
        pagerView.dataSource = self
        pageControl.hidesForSinglePage = true
        pageControl.contentHorizontalAlignment = .right
        fetchImagesData {
            self.fetchCommonData {
                self.titleLabel.text = self.commonData?.title
                self.addressLabel.text = self.commonData?.address
                self.telTextView.text = self.commonData?.tel == "" ? "검색필요" : self.commonData?.tel
                self.homepageTextView.text = self.commonData?.homepage == "" ? "검색필요" : self.commonData?.homepage
                self.overviewTextView.text = self.commonData?.overview
                self.fetchIntroData {
                    guard let indtroData = self.introData else { return }
                    let mirror = Mirror(reflecting: indtroData)
                    for child in mirror.children  {
                        if child.value as! String != "" {
                            switch self.typeName {
                            case "축제/행사":
                                self.introString = self.introString + "\(AttractionType.IntroFestivalDic [child.label!]!): \(child.value) \n"
                            case "관광지":
                                self.introString = self.introString + "\(AttractionType.IntroTouristDic [child.label!]!): \(child.value) \n"
                            case "문화시설":
                                self.introString = self.introString + "\(AttractionType.IntroCulturalFacilityDic [child.label!]!): \(child.value) \n"
                            case "레져":
                                self.introString = self.introString + "\(AttractionType.IntroLeisureDic [child.label!]!): \(child.value) \n"
                            case "맛집":
                                self.introString = self.introString + "\(AttractionType.IntroRestaurantDic [child.label!]!): \(child.value) \n"
                            case "쇼핑":
                                self.introString = self.introString + "\(AttractionType.IntroShoppingDic [child.label!]!): \(child.value) \n"
                            default:
                                print("허용되지 않은 데이터")
                            }
                        }
                    }
                    self.infoTextView.text = self.introString
                    self.fetchPlusData { list in
                        if list != nil {
                            guard let list = list else { return }
                            for item in list {
                                self.introString = self.introString + "\(item[0]): \(item[1])\n"
                            }
                            self.infoTextView.text = self.introString
                        }
                    }
                }
            }
            print(self.introString)
        }
    }
    

    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func fetchCommonData(completionHandler: @escaping () -> ()) {
        guard let attractionInfo = attractionInfo else { return }
        let url = "\(Endpoint.attractionDetailCommonURL)?serviceKey=\(APIKey.attraction)&numOfRows=1&pageNo=1&MobileOS=IOS&MobileApp=BaseCamping&contentId=\(attractionInfo.contentId)&defaultYN=Y&firstImageYN=Y&areacodeYN=N&catcodeYN=N&addrinfoYN=Y&mapinfoYN=N&overviewYN=Y&_type=json"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["response"]["body"]["items"]["item"]
                self.commonData = CommonInfo(address: data["addr1"].stringValue, title: data["title"].stringValue, tel: data["tel"].stringValue, homepage: data["homepage"].stringValue.htmlEscaped, overview: data["overview"].stringValue.htmlEscaped)
                completionHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchIntroData(completionHandler: @escaping () -> ()) {
        guard let attractionInfo = attractionInfo else { return }
        guard let typeName = typeName else { return }
        let url =
        "\(Endpoint.attractionDetailIntroURL)?serviceKey=\(APIKey.attraction)&numOfRows=1&pageNo=1&MobileOS=IOS&MobileApp=BaseCamping&contentId=\(attractionInfo.contentId)&contentTypeId=\(attractionInfo.contentTypeId)&_type=json"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["response"]["body"]["items"]["item"]
                switch typeName {
                case "관광지":
                    self.introData = Tourist(accomcount: data["accomcount"].stringValue, chkbabycarriage: data["accomcount"].stringValue, chkcreditcard: data["chkcreditcard"].stringValue, chkpet: data["chkpet"].stringValue, expagerange: data["expagerange"].stringValue, expguide: data["expguide"].stringValue.htmlEscaped, infocenter: data["infocenter"].stringValue, parking: data["parking"].stringValue.htmlEscaped, restdate: data["restdate"].stringValue, useseason: data["useseason"].stringValue, usetime: data["usetime"].stringValue.htmlEscaped)
                case "문화시설":
                    self.introData = CulturalFacility(accomcountculture: data["accomcountculture"].stringValue, chkbabycarriageculture: data["chkbabycarriageculture"].stringValue, chkcreditcardculture: data["chkcreditcardculture"].stringValue, chkpetculture: data["chkpetculture"].stringValue, discountinfo: data["discountinfo"].stringValue.htmlEscaped, infocenterculture: data["infocenterculture"].stringValue, parkingculture: data["parkingculture"].stringValue.htmlEscaped, parkingfee: data["parkingfee"].stringValue.htmlEscaped, restdateculture: data["restdateculture"].stringValue.htmlEscaped, usefee: data["usefee"].stringValue.htmlEscaped, usetimeculture: data["usetimeculture"].stringValue.htmlEscaped, spendtime: data["spendtime"].stringValue.htmlEscaped)
                    
                case "축제/행사":
                    self.introData = Festival(agelimit: data["agelimit"].stringValue, bookingplace: data["bookingplace"].stringValue.htmlEscaped, discountinfofestival: data["discountinfofestival"].stringValue, eventenddate: data["eventenddate"].stringValue, eventhomepage: data["eventhomepage"].stringValue, eventplace: data["eventplace"].stringValue, eventstartdate: data["eventstartdate"].stringValue, placeinfo: data["placeinfo"].stringValue.htmlEscaped, playtime: data["playtime"].stringValue, program: data["program"].stringValue, spendtimefestival: data["spendtimefestival"].stringValue, sponsor1: data["sponsor1"].stringValue, sponsor1tel: data["sponsor1tel"].stringValue, subevent: data["subevent"].stringValue, usetimefestival: data["usetimefestival"].stringValue.htmlEscaped)
                case "레져":
                    self.introData = Leisure(accomcountleports: data["accomcountleports"].stringValue, chkbabycarriageleports: data["chkbabycarriageleports"].stringValue, chkcreditcardleports: data["chkcreditcardleports"].stringValue, chkpetleports: data["chkpetleports"].stringValue, expagerangeleports: data["expagerangeleports"].stringValue, infocenterleports: data["infocenterleports"].stringValue, openperiod: data["openperiod"].stringValue, parkingfeeleports: data["parkingfeeleports"].stringValue, parkingleports: data["parkingleports"].stringValue, reservation: data["reservation"].stringValue.htmlEscaped, restdateleports: data["restdateleports"].stringValue, usefeeleports: data["usefeeleports"].stringValue, usetimeleports: data["usetimeleports"].stringValue)
                case "맛집":
                    self.introData = Restaurant(chkcreditcardfood: data["chkcreditcardfood"].stringValue, discountinfofood: data["discountinfofood"].stringValue, firstmenu: data["firstmenu"].stringValue, infocenterfood: data["infocenterfood"].stringValue, kidsfacility: data["kidsfacility"].stringValue == "0" ? "X" : "O", opentimefood: data["opentimefood"].stringValue, packing: data["packing"].stringValue, parkingfood: data["parkingfood"].stringValue, reservationfood: data["reservationfood"].stringValue, restdatefood: data["restdatefood"].stringValue, seat: data["seat"].stringValue, smoking: data["smoking"].stringValue, treatmenu: data["treatmenu"].stringValue)
                case "쇼핑":
                    self.introData = Shopping(chkbabycarriageshopping: data["chkbabycarriageshopping"].stringValue, chkcreditcardshopping: data["chkcreditcardshopping"].stringValue, chkpetshopping: data["chkpetshopping"].stringValue, culturecenter: data["culturecenter"].stringValue, fairday: data["fairday"].stringValue, infocentershopping: data["infocentershopping"].stringValue, opendateshopping: data["opendateshopping"].stringValue, opentime: data["opentime"].stringValue, parkingshopping: data["parkingshopping"].stringValue, restdateshopping: data["restdateshopping"].stringValue, restroom: data["restroom"].stringValue, saleitem: data["saleitem"].stringValue, saleitemcost: data["saleitemcost"].stringValue, scaleshopping: data["scaleshopping"].stringValue, shopguide: data["shopguide"].stringValue)
                default:
                    print("해당하는 데이터가 없네요")
                }
                completionHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchPlusData(completionHandler:  @escaping (_ list: [[String]]?) -> ()) {
        guard let attractionInfo = attractionInfo else { return }
        let url =
        "\(Endpoint.attractionDetailPlusURL)?serviceKey=\(APIKey.attraction)&numOfRows=10&pageNo=1&MobileOS=IOS&MobileApp=BaseCamping&contentId=\(attractionInfo.contentId)&contentTypeId=\(attractionInfo.contentTypeId)&_type=json"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["response"]["body"]["totalCount"].intValue > 1 {
                    let data = json["response"]["body"]["items"]["item"].arrayValue.map {
                        [$0["infoname"].stringValue, $0["infotext"].stringValue.htmlEscaped]
                    }
                    completionHandler(data)
                } else if json["response"]["body"]["totalCount"].intValue == 1{
                    let data = [[json["response"]["body"]["items"]["item"]["infoname"].stringValue, json["response"]["body"]["items"]["item"]["infotext"].stringValue.htmlEscaped]]
                    completionHandler(data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchImagesData(completionHandler: @escaping () -> ()) {
        guard let attractionInfo = attractionInfo else { return }
        let url = "\(Endpoint.attractionImagesURL)?serviceKey=\(APIKey.attraction)&numOfRows=12&pageNo=1&MobileOS=IOS&MobileApp=BaseCamping&contentId=\(attractionInfo.contentId)&imageYN=Y&subImageYN=Y&_type=json"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["response"]["body"]["items"]["item"].arrayValue.map {
                    $0["originimgurl"].stringValue
                }
                self.imagesString = self.imagesString + data
                
                completionHandler()
               
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AttractionDetailViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        pageControl.numberOfPages = imagesString.count
        return imagesString.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let item =  imagesString[index]
        let url = URL(string: item)
        cell.imageView?.kf.setImage(with: url)
        cell.imageView?.contentMode = .scaleAspectFill
        pageControl.currentPage = index
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(page)
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let item =  imagesString[index]
        let url = URL(string: item)
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ZoomPictureViewController") as! ZoomPictureViewController
        vc.pictureURL = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

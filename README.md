# BaseCamping - 쉽고 빠른 캠핑장 검색

## About BaseCamping

<div align = "center">        
    <img src = "" width=200>
</div>

+ [👉🏻 AppStore link]()
+ 캠핑에 대한 수요가 높아지는 환경 속에서 전국 각지에 있는 캠핑장에 대한 정보 접근의 편의성이 필요
+ 지역별 / 관심 키워드 / 근처 캠핑장 등 다양한 검색 여건을 통하여 편리하게 캠핑장 정보 제공
+ 캠핑장에 대해서 평가할 수 있는 리뷰 작성 및 찜 기능을 통해 사용자 편의성 증진
+ Blog, Youtube, 근처 가볼만한 장소 등 부가적인 정보 제공

---

## Video

<div align = "center">
    <a href = "">
      <img src = "">
    </a>
</div>

---

# Framework, Library
- UIKit
- Alamofire(https://github.com/Alamofire/Alamofire)
- Kingfisher(https://github.com/onevcat/Kingfisher)
- Realm-cocoa(https://github.com/realm/realm-cocoa)
- Tabman(https://github.com/uias/Tabman)

---

# Project Plan & Log

- [기획 및 개발 기록](https://five-pedestrian-462.notion.site/BaseCamping-SSAC-2a055849447947d49ce0e2c6cf66f433)

---

# Issues
### 1. IndexTab 기반의 UI 구성 
- 첫 번째 시도: Scroll View를 활용한 X축 변경 
  => 도 단위 구분을 했을 때 총 16번의 Api 호출의 발생, 각자 16개의 뷰 컨트롤러를 만들면서 어지러워진 나의 파일들
- 두 번째 시도: PageView를 활용한 구성
  => Api 호출을 줄일 수 있었지만, 자연스럽지 않은 UI 구성 및 애니메이션, ContainerView 구성의 첫 경험
- 마지막 시도: Tabman 라이브러리 활용
  => 원하던 스크롤링 애니메이션 뷰 구성, 해당 라이브러리 커스텀 방식에 대한 학습
### 2. UIScrollView의 정적인 높이로 인한 제한
- UIScrollView를 처음 사용하게되면서 겪은 문제, 각 View의 높이를 직접 계산
- 스토리보드 기반으로 UIScrollView의 활용 방식을 학습하는 것을 목표로 진행
- UITableView의 동적 높이를 구현할 수 있는 방법으로 구현했을 때와 UIScroll뷰의 차이점을 확실하게 인지
- 해결책: 재귀를 통한 View 값의 높이를 계산하여 Height 제약을 업데이트 하는 것 / 기준이 되는 Content를 하나 정하여 레이아웃을 구성하는 것
  => 고정된 높이 값에 대한 계산과 분기 처리로 모두 계산하여 적용
### 3. 다양한 API 호출의 문제 
- 한 화면에서 사진 및 정보 관련한 다양한 API를 호출
- 해결책: DispatchGroup을 활용하여 데이터 패칭을 우선적으로 수행하고 뷰 그리기(CGD 및 비동기 관련 개념에 대한 학습 전)
  => 사용자의 관점에서 가장 먼저보여지는 데이터부터 우선적으로 불러오고, 이 후 completionHandler를 사용하여 동기적으로 데이터 패칭    
### 4. UITabbarController, UINavigationController
- 
- 

### 5. Realm의 활용

### 6. 업데이트 심사거절
- 유튜브 연결과 관련된 내부 콘텐츠가 연령과 맞지 않을 수 있기에 이에 대한 연령 재설정으로 심사 거절

---

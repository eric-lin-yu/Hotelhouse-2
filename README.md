# HotelhouseV2
hotelhouse-V2，為資策會結業作品「寶島旅社」的升級版
補齊前版不足處，並嘗試使用實務所學經驗，加以應用

- 套件使用 SPM 安裝

# 資料來源
與前版相同使用 [政府公開平台 - 旅館民宿-觀光資訊資料庫](https://data.gov.tw/dataset/7780) API 串接。
>fix: 於 2023-06-16 18:10 資料庫更新異動，架構與舊版差異極大，影響 APP API 解析\
>避免影響，先暫時存於 APP 內以 .JSON 檔案，來做使用。


# 首頁 (FrontPageViewController)
tableView 為底層使用，搭配 cell 顯示對應 UI\
上方客製 navigation 功能區，主要為開啟搜尋 view、進入 map 搜尋模式

## 旅店介紹頁 (HotelDetailViewController)
tableView 為底層使用，搭配 cell 顯示對應 UI\
cell 主要有 5 個，以 enum HotelDetailType 來做區分使用
hotelMap cell 可以點選，進入 HotelDetailMapViewController 頁查詢旅店位置
```swift
enum HotelDetailType: Int {
    case hotelImage = 0
    case hotelDetails
    case hotelDescription
    case hotelExtra
    case hotelMap
}
```
## 地圖搜尋頁 (MapSearchViewController)
- 抓取 user 定位後，使用 circleOverlay 展示紅圈\
並僅顯示紅圈範圍內的旅店。
- 使用 touch Callout 面板，點選進入 HotelDetailViewController 頁

>TODO: 整合 HotelDetailMapViewController 與 MapSearchViewController ，共用同一頁的 map 就好

# 收藏 (CollectionsViewController)
TODO: 待開發


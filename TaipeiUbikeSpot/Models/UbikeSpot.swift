//
//  UbikeSpot.swift
//  TaipeiUbikeSpot
//
//  Created by Vickcoo on 2023/11/24.
//

import Foundation

struct UbikeSpot: Codable {
    var country: String // 縣市
    var sno: String //站點編號
    var sna: String //站點名稱
    var tot: Int //站點總停車格數
    var sbi: Int //目前車輛數
    var sarea: String //行政區 ex.大安區、中山區
    var mday: String //微笑單車各場站來源資料更新時間
    var lat: Double //緯度
    var lng: Double //經度
    var ar: String //地址
    var sareaen: String //英文行政區 ex.大安區、中山區
    var snaen: String //英文站點名稱
    var aren: String //英文地址
    var bemp: Int //空位數量
    var act: String //站點目前是否禁用 ex."0"禁用中 "1"啟用中
    var srcUpdateTime: String //微笑單車系統發布資料更新的時間
    var updateTime: String //北市府交通局數據平台經過處理後將資料存入DB的時間
    var infoTime: String //微笑單車各場站來源資料更新時間
    var infoDate: String //微笑單車各場站來源資料更新時間
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // MARK: Hardcode country
        self.country = String(localized: "臺北市")
        self.sno = try container.decode(String.self, forKey: .sno)
        self.sna = try container.decode(String.self, forKey: .sna)
        
        // MARK: Remove spot prefix string
        self.sna = sna.replacingOccurrences(of: "YouBike2.0_", with: "")
        self.tot = try container.decode(Int.self, forKey: .tot)
        self.sbi = try container.decode(Int.self, forKey: .sbi)
        self.sarea = try container.decode(String.self, forKey: .sarea)
        self.mday = try container.decode(String.self, forKey: .mday)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lng = try container.decode(Double.self, forKey: .lng)
        self.ar = try container.decode(String.self, forKey: .ar)
        self.sareaen = try container.decode(String.self, forKey: .sareaen)
        self.snaen = try container.decode(String.self, forKey: .snaen)
        self.aren = try container.decode(String.self, forKey: .aren)
        self.bemp = try container.decode(Int.self, forKey: .bemp)
        self.act = try container.decode(String.self, forKey: .act)
        self.srcUpdateTime = try container.decode(String.self, forKey: .srcUpdateTime)
        self.updateTime = try container.decode(String.self, forKey: .updateTime)
        self.infoTime = try container.decode(String.self, forKey: .infoTime)
        self.infoDate = try container.decode(String.self, forKey: .infoDate)
    }
}

//
//  Movie.swift
//  MovieApp
//
//  Created by 김범석 on 2024/07/08.
//


import Foundation
// 영화 Get -> https://itunes.apple.com/search?media=movie&term=movie
// MARK: - Welcome
struct MovieData: Codable {
    let resultCount: Int
    let results: [Movie]
}


// 첫번째 페이지 -> 영화 이름(MovieName) , 트랙 네임(장르, trackName) , 감독(일단 감독 이름까지 넣어보고, artistName) , 날짜(releaseDate)
// 두번째 영화 상세페이지 -> 영화 이름 , 날짜 , 시간 , 몇세 관람가 , 밑에 내용 설명
// MARK: - Result
struct Movie: Codable {
    //let artistName: String?
    let movieName: String?
    let trackName: String?
   // let previewURL: String? // 영화 예고편 !
    //let collectionPrice : Double // 관람 비용
    let imageUrl: String? // 이미지
    private let releaseDate: String?
    //let primaryGenreName: PrimaryGenreName // 아이들 관람
    let shortDescription: String? // 설명
    //let longDescription: String?

    enum CodingKeys: String, CodingKey {
        //case artistName
        case movieName = "collectionName"
        case trackName
        //case previewURL = "previewUrl"
        case imageUrl = "artworkUrl100"
        //case collectionPrice
        case releaseDate
        //case primaryGenreName
        case shortDescription
        //case longDescription
    }
    
    // 출시 정보에 대한 날짜를 계산하기 위해서 계산 속성으로
    var releaseDateString: String? {
        guard let isoDate = ISO8601DateFormatter().date(from: releaseDate ?? "")
        else {
            return ""
        }
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = myFormatter.string(from: isoDate)
        return dateString
    }
}

//enum PrimaryGenreName: String, Codable {
//    case actionAdventure = "Action & Adventure"
//    case comedy = "Comedy"
//    case drama = "Drama"
//    case kidsFamily = "Kids & Family"
//    case romance = "Romance"
//    case sciFiFantasy = "Sci-Fi & Fantasy"
//}


//
//  Constants.swift
//  MovieApp
//
//  Created by 김범석 on 2024/07/18.
//

import UIKit

// MARK: - Name space 만들기


public enum MovieApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaType = "media=movie"
}

public struct Cell {
    static let movieCellIdentifier = "MyMovieCell"
    static let movieCollectionViewCellIdentifier = "MovieCollectionViewCell"
    private init() {}
}

public struct CVCell {
    static let spacingWitdh: CGFloat = 1
    static let cellColumns: CGFloat = 3
    private init() {}
}








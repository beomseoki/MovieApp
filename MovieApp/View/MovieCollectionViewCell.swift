//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by 김범석 on 2024/08/08.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    // 이미지 URL 전달받는 속성
    var imageURL: String? {
        didSet {
            loadImage()
        }
    }
    
    
    // URL -> 이미지를 셋팅하는 메서드
    func loadImage() {
        guard let urlString = self.imageURL, let url = URL(string: urlString) else { return }
        
        // 오래걸리는 작업을 동시성 처리
        DispatchQueue.global().async {
            // URL을 가지고 데이터를 만드는 메서드 (오래걸리는데 동기적인 실행)
            guard let data = try? Data(contentsOf: url) else { return }
            
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
            guard self.imageURL! == url.absoluteString else { return }
            
            // 작업의 결과물을 바로 보여지는 작업이기 때문에 메인 큐에서 작업
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해 실행
        self.mainImageView.image = nil
    }
    
}

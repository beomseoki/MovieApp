//
//  MyMoiveCell.swift
//  MovieApp
//
//  Created by 김범석 on 2024/07/18.
//

import UIKit

class MyMovieCell: UITableViewCell {

    // 첫번째 페이지 -> 영화 이름(MovieName) , 트랙 네임(장르, trackName) , 짧은 설명(shortDescription) , 날짜(releaseDate)
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var trackName: UILabel! 
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    // 이미지 URL을 전달받는 속성
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이비지가 바뀌는 것처럼 보이는 현상을 없애기 위해 실행
        self.mainImageView.image = nil
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainImageView.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            
            guard let data = try? Data(contentsOf: url) else { return }
            
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
}

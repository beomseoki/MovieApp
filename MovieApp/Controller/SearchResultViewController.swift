//
//  SearchResultViewController.swift
//  MovieApp
//
//  Created by 김범석 on 2024/08/08.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    
    // 컬렉션 뷰
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 컬렉션뷰의 레이아웃을 담당하는 객체
    let flowLayout = UICollectionViewFlowLayout()
    
    // 네트워크 매니저 싱글톤
    let networkManager = NetworkManager.shared
    
    // 빈 배열로 시작
    var movieArrays: [Movie] = []
    
    // 검색을 위한 단어를 담는 변수 (전 화면에서 전달받음)
    var searchTerm: String? {
        didSet {
            setupDatas()
        }
    }
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCollectionView()

    }
    
    func setupCollectionView() {
        // 컬렉션뷰의 레이아웃을 담당하는 객체
        
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        // 컬렉션뷰의 스크롤 방향 설정
        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWitdh * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        

        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        // 아이템 간격 설정
        flowLayout.minimumInteritemSpacing = CVCell.spacingWitdh
        
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
        
        // 컬렉션뷰의 속성에 할당
        collectionView.collectionViewLayout = flowLayout
    }
    
    
    // 데이터 셋업
    func setupDatas() {
        
        
        guard let term = searchTerm else { return }
        print("네트워킹 시작 단어 \(term)")
        
        // 네트워킹 시작전에 빈배열로
        self.movieArrays = []
        
        // 네트워킹 시작
        networkManager.fetchMovie(searchTerm: term) { result in
            switch result {
            case .success(let movieDatas):
                // 검색한 결과를 배열에 담고
                self.movieArrays = movieDatas
                // 만든 결과에 대해서 화면에 보여야하니깐
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }


}


extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.movieCollectionViewCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.imageURL = movieArrays[indexPath.item].imageUrl
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArrays.count
    }
}

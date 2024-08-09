//
//  ViewController.swift
//  MovieApp
//
//  Created by 김범석 on 2024/07/08.
//

import UIKit

class ViewController: UIViewController {

    
    //let searchController = UISearchController()
    
    // 서치 Result 컨트롤러
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)

    @IBOutlet weak var tableView: UITableView!
    
    // 네트워크 매니저 (싱글톤)
    var networkManager = NetworkManager.shared
    
    // (영화 데이터를 다루기 위한) 빈 배열로 시작
    var movieArrays: [Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        setupDatas()
        
        // Do any additional setup after loading the view.
    }
    
    // 서치바 셋팅
    func setupSearchBar() {
        self.title = "Movie Search"
        navigationItem.searchController = searchController
        
        // 서치바 기본 사용
        //searchController.searchBar.delegate = self
        
        // 서치(결과)컨트롤러의 사용 , 새로운 화면을 보여주기
        searchController.searchResultsUpdater = self
        
        // 첫글자 대문자 없애기
        searchController.searchBar.autocapitalizationType = .none
    }
    
    // 테이블 뷰 셋팅
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // nib 파일 설정을 위한 등록
        let nib = UINib(nibName: Cell.movieCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Cell.movieCellIdentifier)
    }
    
    // 데이터 셋업 -> 네트워킹 시작
    func setupDatas() {
        networkManager.fetchMovie(searchTerm: "movie") { result in
            switch result {
            case Result.success(let movieData):
                self.movieArrays = movieData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }
                
                
            case Result.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
    
    
    

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.movieCellIdentifier, for: indexPath) as! MyMovieCell
        
        cell.imageUrl = movieArrays[indexPath.row].imageUrl
        cell.movieName.text = movieArrays[indexPath.row].movieName
        cell.trackName.text = movieArrays[indexPath.row].trackName
        cell.shortDescription.text = movieArrays[indexPath.row].shortDescription
        cell.releaseDate.text = movieArrays[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - 기본 서치바 적용


//extension ViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//
//        // 검색하는 데이터 빈 배열로 만들기
//        self.movieArrays = []
//
//        //네트워킹 시작
//        networkManager.fetchMovie(searchTerm: searchText) { result in
//            switch result {
//            case .success(let movieDatas):
//                self.movieArrays = movieDatas
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//
//}


// MARK: - 검색하는 동안 복잡한 내용 구현하기

extension ViewController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메소드 ==> 다른 화면을 보여주기 위해 구현
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchResultViewController
        // 컬렉션 뷰에 찾으려는 단어 전달
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}




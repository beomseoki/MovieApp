//
//  NetworkManager.swift
//  MovieApp
//
//  Created by 김범석 on 2024/07/18.
//

import Foundation

// MARK: - 네트워크에서 발생할 수 있는 에러 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

// MARK: - 서버와 통신하는 모델


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    

    
    
    typealias NetworkCompletion = (Result<[Movie], NetworkError>) -> Void
    
    
    
    // 네트워킹 요청하는 함수
    func fetchMovie(searchTerm: String, completion: @escaping NetworkCompletion) {
        //let baseURL = "https://itunes.apple.com/search"
        //let mediaType = "movie"
        //let urlString = "\(baseURL)?media=\(mediaType)&term=\(searchTerm)"
        let urlString = "\(MovieApi.requestUrl)\(MovieApi.mediaType)&term=\(searchTerm)"
        print(urlString)
        
        perfomRequest(with: urlString) { result in
            completion(result)
        }
        
    }
        
    
    // 실제 요청하는 함수
    private func perfomRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else { return }
        
        // URL요청 생성
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, resposne, error in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            
            // 메서드 실행하여 , 결과를 받음
            if let movies = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(movies))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 데이터 분석하는 함수
    private func parseJSON(_ movieData: Data) -> [Movie]? {
        
        // 성공
        do {
            //JSON데이터 -> MovieData 구조체
            let movieData = try JSONDecoder().decode(MovieData.self, from: movieData)
            return movieData.results
        
            // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

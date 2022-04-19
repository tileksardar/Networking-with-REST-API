//
//  Service.swift
//  Network
//
//  Created by Tilek on 11/4/22.
//

import Foundation

// MARK: - SERVICE SINGLETON
class Service: NSObject{
    static let shared = Service()
  
    //MARK: - FETCH POSTS
   func fetchPosts(completion: @escaping (Result<[Post], Error>) -> ()){
        guard let url = URL(string: "http://localhost:1337/posts") else{return}
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            DispatchQueue.main.async {
                if let err = err{
                    print("Failed to fetch posts: ", err)
                    return
                }
                
                guard let data = data else {return}
                
                do{
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))

                }catch {
                    completion(.failure(error))
                }
                }
                }.resume()
                }
    
    
    
    //MARK: - CREATE POST
    
    
        func createPost(title: String, body: String, completion: @escaping(Error?) -> ()){
        guard let url = URL(string: "http://localhost:1337/post") else{return}

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        let params = ["title": title, "postBody": body]
        do{
        let data = try JSONSerialization.data(withJSONObject: params, options: .init())

            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")

            URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
                guard let data = data else {return}

                completion(nil)
                print(String(data: data, encoding: .utf8) ?? "")

            }.resume()
           }
        catch{
            completion(error)
        }
    }
    
    //MARK: - DELETE POST

    func deletePost(id: Int, completion: @escaping(Error?) -> ()){
        guard let url = URL(string: "http://localhost:1337/post/\(id)") else{return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
            DispatchQueue.main.async {
                //check error
                if let err = err{
                    completion(err)
                    return
                }
                if let resp = resp as? HTTPURLResponse, resp.statusCode != 200{
                    let errorString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                   completion(NSError(domain: "", code: resp.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString]))
                    return
                }
                completion(nil)
            }
            

        }.resume()
    }
}

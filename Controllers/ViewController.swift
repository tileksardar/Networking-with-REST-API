//
//  ViewController.swift
//  Network
//
//  Created by Tilek on 10/4/22.
//

import UIKit



//MARK: - POST MODEL

struct Post: Decodable{
    let id: Int
    let title, body: String
    }


//MARK: - ViewController
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let refreshControl = UIRefreshControl()

    

    
    
   fileprivate func fetchPosts(){
       Service.shared.fetchPosts { (res) in
           switch res {
           case .failure(let err):
               print("Failed to fetch posts: ", err)
           case .success(let posts):
              // print(posts)
               self.posts = posts
               self.tableView.reloadData()
               
           }
        }
    }


    //MARK: - TABLEVIEW CREATION

    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()

 
    
    //MARK: - VIEWDIDLOAD

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl)
        
        view.backgroundColor = .white
        
        setupNavBar()
        fetchPosts()

        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
    }
    //MARK: - TABLEVIEW REFRESH
    
    @objc func refresh(_ sender: AnyObject) {
            fetchPosts()
            refreshControl.endRefreshing()
    }
    //MARK: - TABLEVIEW setup
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    
    
    var posts = [Post]()

  
    
    //MARK: - TABLEVIEW DATASOURCES

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return posts.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
      
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("Deleting post")
            let post = self.posts[indexPath.row]
            Service.shared.deletePost(id: post.id) { (err) in
                if let err = err{
                    print("Failed to delete: ", err)
                    return
                }
                print("Successfully deleted post from server")
                self.posts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)            }
        }
    }
    //MARK: - SETUP NAV BAR
    
    func setupNavBar(){
        
    navigationItem.title = "Posts"


    let addingIcon = UIImage(systemName: "plus")!.withTintColor(.black, renderingMode: .alwaysOriginal)
    
    navigationItem.rightBarButtonItem = .init(image: addingIcon, style: .plain, target: self, action: #selector(toAddVC(sender:)))

    }
    
    //MARK: - TRANSITION TO ADDVC METHOD

        @objc fileprivate func toAddVC(sender: AnyObject){
           let addingVC = AddViewController()
       
            navigationItem.backButtonTitle = "Назад"
            navigationController?.navigationBar.tintColor = .black
            addingVC.addPostDelegate = self
     
           navigationController?.pushViewController(addingVC, animated: true)

            
        
       
        }



    }
extension ViewController: AddViewControllerDelegate{
    func updatePosts() {
        fetchPosts()
    }
    
    
}


//
//  AddViewController.swift
//  Network
//
//  Created by Tilek on 13/4/22.
//

import UIKit

protocol AddViewControllerDelegate: AnyObject {
    func updatePosts()
}
class AddViewController: UIViewController  {
    

    var firstVC = ViewController()

    weak var addPostDelegate: AddViewControllerDelegate?

    weak var postBodyTxtFd: UITextField!
    weak var postTitleTxtFd: UITextField!
    weak var containerView: UIView!
    weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        title = "Adding"
        
        setupTextFields()
        
    }
    
    
        //MARK: - SETUP TEXTFIELDS method
    
          func setupTextFields(){
       
        //MARK: - setup postTitle txtfd
        
        let postTitleField = UITextField()
        
        postTitleField.placeholder = "Title"
        postTitleField.borderStyle = .roundedRect
        postTitleField.backgroundColor = .lightGray
        postTitleField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postTitleField)
        
        
        
        NSLayoutConstraint.activate([postTitleField.heightAnchor.constraint(equalToConstant: 34),
                                     postTitleField.widthAnchor.constraint(equalToConstant: 280),
                                     postTitleField.topAnchor.constraint(equalTo: view.topAnchor, constant: 270),
                                     postTitleField.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        postTitleTxtFd = postTitleField
        
        
        
        //MARK: - setup postBody txtfd
        
        
        
        let postBodyField = UITextField()
        
        postBodyField.placeholder = "Body"
        postBodyField.borderStyle = .roundedRect
        postBodyField.backgroundColor = .lightGray
        postBodyField.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(postBodyField)
        
        
        NSLayoutConstraint.activate([postBodyField.heightAnchor.constraint(equalToConstant: 34),
                                     postBodyField.widthAnchor.constraint(equalToConstant: 280),
                                     postBodyField.topAnchor.constraint(equalTo: postTitleField.bottomAnchor, constant: 20),
                                     postBodyField.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        postBodyTxtFd = postBodyField
        
        
    //MARK: - setup UIView for Spinner
              
              let container4Spinner = UIView()

              container4Spinner.backgroundColor = .white
              container4Spinner.translatesAutoresizingMaskIntoConstraints = false
              view.addSubview(container4Spinner)
                  NSLayoutConstraint.activate([container4Spinner.widthAnchor.constraint(equalToConstant: 30),
                                               container4Spinner.heightAnchor.constraint(equalToConstant: 30),
                                               container4Spinner.topAnchor.constraint(equalTo: postBodyField.bottomAnchor, constant: 10),
                                               container4Spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor )])
          
              containerView = container4Spinner
              
   //MARK: - setup activityIndicator
              
              let activitySpinner = UIActivityIndicatorView(style: .medium)
              activitySpinner.translatesAutoresizingMaskIntoConstraints = false
              
              view.addSubview(activitySpinner)
              
              container4Spinner.addSubview(activitySpinner)
              
              activitySpinner.centerXAnchor.constraint(equalTo: container4Spinner.centerXAnchor).isActive = true
              activitySpinner.centerYAnchor.constraint(equalTo: container4Spinner.centerYAnchor).isActive = true
              
              activityIndicator = activitySpinner
              
              
              
              
              
    //MARK: - setup SEND Button
              
              
        let sendBtn = UIButton()
        sendBtn.backgroundColor = .lightGray

        sendBtn.setTitle("Send", for: .normal)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.addTarget(self, action: #selector(sendPostMethod), for: .touchUpInside)
        view.addSubview(sendBtn)
        NSLayoutConstraint.activate([sendBtn.heightAnchor.constraint(equalToConstant: 35),
                                     sendBtn.widthAnchor.constraint(equalToConstant: 75),
                                     sendBtn.topAnchor.constraint(equalTo: container4Spinner.bottomAnchor, constant: 10),
                                     sendBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        }
    
    
    
    //MARK: - Activity Show

        func showActivityIndicatory() {

             activityIndicator.startAnimating()
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [self] t in
                self.activityIndicator.stopAnimating()
                 self.addPostDelegate?.updatePosts()
            }
            
        }
    
    //MARK: - Sending Method
    
    @objc func sendPostMethod() {
        
        let successAlert = UIAlertController(title: "Успешно добавлено!", message: "", preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "Закрыть", style: .default) { (action) in
            self.dismis()
        }
        
        let failedAlert = UIAlertController(title: "Что-то пошло не так :(", message: "", preferredStyle: .alert)
        let secAction = UIAlertAction(title: "Закрыть", style: .default, handler: nil)
        
        
  
        
    Service.shared.createPost(title: postTitleTxtFd.text! , body: postBodyTxtFd.text!) { (err) in
            if let err = err {
                failedAlert.addAction(secAction)
                self.present(failedAlert, animated: true, completion: nil)
                print("Failed to create post", err)
                
            }
        DispatchQueue.main.async {
            self.showActivityIndicatory()
            successAlert.addAction(firstAction)
            self.present(successAlert, animated: true, completion: nil)
        }
        
        print("Finished creating a post")
        }
        
    }
    func dismis(){
        navigationController?.popViewController(animated: true)
        
    }
    
}


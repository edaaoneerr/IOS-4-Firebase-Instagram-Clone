//
//  FeedViewController.swift
//  instagram-clone
//
//  Created by Edanur Oner on 11.04.2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        getData()

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.likeCountLabel.text = String(likeArray[indexPath.row])
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]), placeholderImage: UIImage(named: "heading.png"))
        cell.documentIDLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    func getData() {
        
       
        let database = Firestore.firestore()
        database.collection("Posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    
                    self.likeArray.removeAll(keepingCapacity: false)
                    
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String
                         {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl")  as?  String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    

}

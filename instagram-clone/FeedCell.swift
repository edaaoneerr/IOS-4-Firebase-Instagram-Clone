//
//  FeedCell.swift
//  instagram-clone
//
//  Created by Edanur Oner on 15.04.2023.
//

import UIKit
import FirebaseFirestore

class FeedCell: UITableViewCell {
    
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    @IBOutlet weak var documentIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeClicked(_ sender: Any) {
        let database = Firestore.firestore()
        
        
        
        if let likeCount = Int(likeCountLabel.text!){
            let like = ["likes": likeCount + 1] as [String: Any]
            
            database.collection("Posts").document(documentIDLabel.text!)
                .setData(like, merge: true)
        }
    }
    
}

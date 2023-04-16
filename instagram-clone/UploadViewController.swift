//
//  UploadViewController.swift
//  instagram-clone
//
//  Created by Edanur Oner on 11.04.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.isUserInteractionEnabled = true
        let keyboardRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(keyboardRecognizer)
        

        let imageTapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(selectImage)
        )
        uploadImageView.addGestureRecognizer(imageTapRecognizer)
    }
    

    
    
    @IBAction func postClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) {
                (metadata, error) in
                if error != nil {
                    self.makeAlert(title: "Error", error: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { url, error in
                        if error != nil {
                            print(error?.localizedDescription ?? "Error")
                        }
                        else {
                            let imageUrl = url?.absoluteString
                            
                            let database = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil
                            
                            var post = ["imageUrl" : imageUrl!,
                                        "postedBy": Auth.auth().currentUser!.email!,
                                        "postComment": self.commentText.text!,
                                        "date": FieldValue.serverTimestamp(),
                                        "likes": 0] as [String: Any]
                            
                            firestoreReference = database.collection("Posts")
                                .addDocument(data: post, completion: {
                                    (error) in
                                    if error != nil {
                                        self.makeAlert(title: "Error", error: error?.localizedDescription ?? "Error")
                                    }
                                    else {
                                        self.commentText.text = ""
                                        self.uploadImageView.image = UIImage(named: "heading.png")
                                        self.tabBarController?.selectedIndex = 0
                                    }
                            })
                            
                        }
                    }
                }
            }
            
        }
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

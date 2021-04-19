//
//  BaseImageController.swift
//  FuelSrv
//
//  Created by PBS9 on 06/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class BaseImageController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    func openOptions(){
        let alert = UIAlertController(title: "Choose Image", message: "Pick Image From :", preferredStyle: .alert)
        let galleryAction = UIAlertAction(title: "Gallery", style: .default,handler: {
            btn in
            self.imagePicker.sourceType = .photoLibrary
            self.openPicker()
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .default,handler: {
            btn in
            
            self.imagePicker.sourceType = .camera
            self.openPicker()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive,handler: nil)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectedImage(choosenImage: UIImage){
       
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        let choosenImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImage(choosenImage: choosenImage)
        dismiss(animated: true, completion: nil)
        
//        imageData = UIImagePNGRepresentation(image)! as NSData
//        imageString = "data:image/png;base64,\(imageData.base64EncodedString(options: .lineLength64Characters))"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func openPicker(){
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
}

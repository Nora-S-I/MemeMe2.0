//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Norah Al Ibrahim on 11/14/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    //connecting sotryboard controllers to the code
    @IBOutlet weak var shareActivityToolbar: UIToolbar!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var imageToolbar: UIToolbar!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var albumButtonItem: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //enumration to specify the status of image view image
    enum ImageSelection : Int {
        case selected = 0
        case notSelected = 1
        case error = 2
    }
    
    //variable to specify image selection status
    var imageStatus : Int = ImageSelection.notSelected.rawValue
    //constant to set the textfields with default value
    let defaultText = "Click Here to add Text"
    //variable to save the identifiner of the textfield when begin editing
    var textfieldIdentifiner: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the delegation
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setUIView(imageStatus)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    //Action to display the activity view controller to the user
    @IBAction func shareButton(_ sender: Any) {
        
        //create an instance from Meme Struct
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        //display the activity controller
        let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        //information source of following code: https://seanwernimont.weebly.com/blog/december-02nd-2015
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success && error == nil){
                //display error messgae to the user
                let alert = UIAlertController(title: "Congrats", message: "Your meme has been saved in your photos", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
                self.present(alert,animated: true, completion: nil)
                // self.dismiss(animated: true, completion: nil)
            }
            else if (error != nil){
                
                //display error messgae to the user
                let alert = UIAlertController(title: "Erorr", message: "Saving image faild", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
                self.present(alert,animated: true, completion: nil)
            }
        }
    }
    //action to dismiss the meme editor and go back the recent memes
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //action to open the camera for the user in order to take a photo
    @IBAction func cameraButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //action to open the photo album for the user in order to choose a photo
    @IBAction func albumButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //function to set the text style of the textfields
    func setTextStyle(textField: UITextField)  {
        
        let memeTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.strokeWidth : -5.0, NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    
    //function to set the meme editor view controller based on the image selection status
    func  setUIView(_ imageStatus: Int) {
        //variable to reflect the image selection status
        var isImageSelected: Bool
        
        //set textfields value based on the image selection status
        switch imageStatus {
            
        case ImageSelection.selected.rawValue:
            topTextField.text = defaultText
            bottomTextField.text = defaultText
            isImageSelected = true
            
        case ImageSelection.notSelected.rawValue:
            topTextField.text = "Take a picture or select one from Album!"
            bottomTextField.text = ""
            isImageSelected = false
            
        case ImageSelection.error.rawValue:
            topTextField.text = "An error occured while selecting the image"
            bottomTextField.text = ""
            isImageSelected = false
            
        default:
            isImageSelected = false
        }
        //set textfield style
        setTextStyle(textField: topTextField)
        setTextStyle(textField: bottomTextField)
        //enable or disable the take picture option based on the camera availablity in the device
        cameraButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //enable or disable share and cancel buttons based on the image selection state
        shareButtonItem.isEnabled = isImageSelected
        //clear the image view controller if there is no image selected
        if !isImageSelected {
            imageView.image = nil
            self.imageStatus = ImageSelection.notSelected.rawValue
        }
    }
    
    func subscribeToKeyboardNotifications() {
        
        //subsecribe to keyboard will show notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //subsecribe to keyboard will hide notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        //unsubsecribe from keyboard will show notification
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //unsubsecribe from keyboard will hide notification
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //function to define the action when the keyboard is going to show
    @objc func keyboardWillShow(_ notification:Notification) {
        
        //check if the user is editing the bottom textfield text and the view is not slided up
        if view.frame.origin.y == 0 && textfieldIdentifiner == bottomTextField.accessibilityIdentifier {
            
            //slide up the view based on the keyboard size
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //function to define the action when the keyboard is going to hide
    @objc func keyboardWillHide(_ notification:Notification) {
        //check if the user is editing the bottom textfield text and the view is  slided up
        if view.frame.origin.y != 0 && textfieldIdentifiner == bottomTextField.accessibilityIdentifier {
            
            //slide down the veiw based on the keyboard size
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //function to get the keyboard hight
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //function to generate a memed image from the selected image and texts set by the user
    func generateMemedImage() -> UIImage {
        
        //hide toolbars
        setToolbars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbars
        setToolbars(false)
        
        return memedImage
    }
    
    //function to hide or show the toolbars
    func setToolbars(_ isHidden: Bool)  {
        shareActivityToolbar.isHidden = isHidden
        imageToolbar.isHidden = isHidden
    }
    
    
}

//extension to define the UITextFieldDelegate protocol functions
extension MemeEditorViewController: UITextFieldDelegate{
    
    //function to be called when the user tab on the textfield to start typing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //check if the user has selectd an image and the textfield text is the default text
        if imageStatus == ImageSelection.selected.rawValue && textField.text == defaultText{
            //clear the textfield text
            textField.text = ""
        }
        //save the identifier of the textfield
        textfieldIdentifiner = textField.accessibilityIdentifier!
    }
    
    //function to be called when the user hit return button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //hide the keyboard
        textField.resignFirstResponder()
        return true
    }
}

//extension to define the UIImagePickerControllerDelegate protocol functions
extension MemeEditorViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //function to be called when a an image is selected from the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //assign the selected image to the image view controller
        if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            imageView.image = image
            self.imageStatus = ImageSelection.selected.rawValue
            
        } else{
            //set image selection status to error
            self.imageStatus = ImageSelection.error.rawValue
        }
        dismiss(animated: true, completion: nil)
    }
    
    //function to be called when a the cancel button on the image picker controller is selected
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //close the image picker controller
        dismiss(animated: true, completion: nil)
    }
}



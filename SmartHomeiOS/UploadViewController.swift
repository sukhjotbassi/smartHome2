/*
 * Copyright 2010-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import UIKit
import AWSS3
import AWSCore
import UserNotifications

var userName: String = "Default"

class UploadViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var Emoji: UILabel!
    
    @IBOutlet weak var Name: UITextField!
    //@IBOutlet weak var field: UITextField!
//    var userName: String = Name.text;
    
    
    
    @IBAction func Enter(_ sender: Any) {
        
        Name.resignFirstResponder()
        userName = Name.text!
        let alertController = UIAlertController(title: "Saved", message: "Please click on 'Take Selfie' Below.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true, completion: nil)
        //self.view.endEditing(true)
    }


  
 
    
    

   
    
    

    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    
    let imagePicker = UIImagePickerController()
    let transferUtility = AWSS3TransferUtility.default()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        //getName()
        self.progressView.progress = 0.0;
        self.statusLabel.text = "Ready"
        self.imagePicker.delegate = self

        
        
        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                self.progressView.progress = Float(progress.fractionCompleted)
                self.statusLabel.text = "Uploading..."
            })
            
        }

        
        self.completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    self.statusLabel.text = "Failed"
                }
                else if(self.progressView.progress != 1.0) {
                    self.statusLabel.text = "Failed"
                    NSLog("Error: Failed - Likely due to invalid region / filename")
                }
                else{
                    self.statusLabel.text = "Success"
                    E_Count = E_Count + 1;
                    
                        if E_Count == 1 {
                            self.Emoji.text = "😡"
                        }
                        else if E_Count == 2 {
                            self.Emoji.text = "😳"
                        }
                        else if E_Count == 3 {
                            self.Emoji.text = "☹️"
                        }
                        else if E_Count == 4 {
                            self.Emoji.text = "😬"
                        }
                        else if E_Count == 5 {
                            self.Emoji.text = "😉"
                        }
                    
                }})
        }
    }
    
    
//    func getName(){
//        //1. Create the alert controller.
//        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
//        
//        //2. Add the text field. You can configure it however you need.
//        alert.addTextField { (textField) in
//            textField.text = "Some default text"
//        }
//        
//        // 3. Grab the value from the text field, and print it when the user clicks OK.
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
//            print("Text field: \(String(describing: textField?.text))")
//        }))
//        
//        // 4. Present the alert.
//        self.present(alert, animated: true, completion: nil)
//        
//
//    }
    
    
    
    
 
    
    
    
    
    @IBAction func selectAndUpload(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        //imagePicker.sourceType = .photoLibrary
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadImage(with data: Data) {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock

        print(userName);
        //var c = 100;
        //defaults.set(Counter, forKey: "counter")
        
       //var c = defaults.integer(forKey: "counter")
       // var userName: String = Name.text!;

        transferUtility.uploadData(
            data,
            bucket: S3BucketName,
            key: "\(userName)Image\(Counter)",
            contentType: "image/jpeg",
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject! in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    self.statusLabel.text = "Failed"
                }
                
                if let _ = task.result {
                    self.statusLabel.text = "Generating Upload File"
                    Counter = Counter + 1;
                    defaults.set(Counter, forKey: "counter")
                    
                    print("Upload Starting!")
                    // Do something with uploadTask.
                }
                
                return nil;
        }
    }
}
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UploadViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if "public.image" == info[UIImagePickerControllerMediaType] as? String {
            let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let myThumb1 = image.resized(withPercentage: 0.1)

            
            self.uploadImage(with: UIImagePNGRepresentation(myThumb1!)!)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

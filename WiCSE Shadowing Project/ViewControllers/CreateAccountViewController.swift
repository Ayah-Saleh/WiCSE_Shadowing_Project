//
//  CreateAccountViewController.swift
//  WiCSE Shadowing Project
//
//  Created by Ayah Saleh on 2/1/23.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        // hide the error label
        errorLabel.alpha = 0
        
    }
    
    // check the fields and validate that the data is correct. if correct, returns nil, otherwise, returns error message
    func validateFields() -> String? {
        // check all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        let error = validateFields()
        if error != nil{
            showError("Oops! Looks like you forgot something :/")
        }
        
        else{
            // create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // create the user
            Auth.auth().createUser(withEmail:email, password:password) {(result, err) in
                
                if err != nil{
                    //there was an error creating the user
                    self.showError("Error creating user!")
                }
                
                else{
                    //user was created successfully ~ store first & last name
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["first_name": firstName, "last_name": lastName, "uid": result!.user.uid]){(error) in
                        
                        if error != nil{
                            // show error message
                            self.showError("Error saving user data...")
                        }
                        
                    }
                    // transition to home screen
                    self.transitionToHome()
                }
            }
        
        }

    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        //go to dashboard
        self.performSegue(withIdentifier: "createToDashboard", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  uploadWorkoutViewController.swift
//  WiCSE Shadowing Project
//
//  Created by Ayah Saleh on 3/29/23.
//

import DropDown
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class uploadWorkoutViewController: UIViewController {
    
    
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var userGoal: UIButton!
    @IBOutlet weak var userMuscleGroup: UIButton!
    @IBOutlet weak var userSkill: UIButton!
    @IBOutlet weak var userWorkoutType: UIButton!
    @IBOutlet weak var workoutDescription: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    // check the fields and validate that the data is correct. if correct, returns nil, otherwise, returns error message
    func validateFields() -> String? {
        // check all fields are filled in
        if workoutName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in workout name."
        }
        if userGoal.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "Select goal" {
            return "Please select a goal."
        }
        if userMuscleGroup.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "Select muscle group" {
            return "Please select a muscle group."
        }
        if userSkill.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "Select skill level" {
            return "Please select a skill level."
        }
        if userWorkoutType.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "Select workout type" {
            return "Please select a workout type."
        }
        if workoutDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in workout description."
        }
        
        return nil
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        let error = validateFields()
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        if error != nil{
            showError("Oops! Looks like you forgot something :/")
        }
        else {
            // create cleaned versions of data
            guard let muscle_group = userMuscleGroup.titleLabel?.text,
                  let workout_type = userWorkoutType.titleLabel?.text,
                  let user_skill = userSkill.titleLabel?.text,
                  let user_goal = userGoal.titleLabel?.text,
                  let workout_name = workoutName.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let workout_description = workoutDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                showError("Invalid data")
                return
            }
            
            if let user = user {
                // upload data to Firebase Realtime Database
                ref.child("Users").child(user.uid).child("Workouts").childByAutoId().setValue(["goal": user_goal, "muscle_group": muscle_group, "name": workout_name, "skill_level": user_skill, "type": workout_type, "workout_description": workout_description])
                
                // upload data to Firestore
                let db = Firestore.firestore()
                db.collection("Workouts").addDocument(data: ["goal": user_goal, "muscle_group": muscle_group, "name": workout_name, "skill_level": user_skill, "type": workout_type, "workout_description": workout_description, "uid": user.uid])
                
                transitionToExplore()
            } else {
                showError("User not logged in.")
            }
        }
        func transitionToExplore(){
            // go to dashboard
            self.performSegue(withIdentifier: "uploadToExplore", sender: self)
        }
        
        func showError(_ message:String){
            errorLabel.text = message
            errorLabel.alpha = 1
        }
    }
    
    func setUpElements(){
        // hide the error label
        errorLabel.alpha = 0
        
        let userGoalDropDown = DropDown()
        userGoalDropDown.anchorView = userGoal
        userGoalDropDown.dataSource = ["Build Muscle", "Tone", "Strength Train"]
        userGoalDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userGoal.setTitle(item, for: .normal)
        }
        
        let muscleGroupDropDown = DropDown()
        muscleGroupDropDown.anchorView = userMuscleGroup
        muscleGroupDropDown.dataSource = ["Chest", "Back", "Legs", "Shoulders", "Arms", "Abs", "Glutes", "Calves"]
        muscleGroupDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userMuscleGroup.setTitle(item, for: .normal)
        }
        
        let skillDropDown = DropDown()
        skillDropDown.anchorView = userSkill
        skillDropDown.dataSource = ["Beginner", "Intermediate", "Expert"]
        skillDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userSkill.setTitle(item, for: .normal)
        }
        
        let workoutTypeDropDown = DropDown()
        workoutTypeDropDown.anchorView = userWorkoutType
        workoutTypeDropDown.dataSource = ["Plyometrics", "Powerlifting", "Strength", "Stretching", "Strongman"]
        workoutTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userSkill.setTitle(item, for: .normal)
        }
        
    }
    
}

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
    
    @IBOutlet var typeCollection: [UIButton]!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var skillDropDown = DropDown()
    var workoutTypeDropDown = DropDown()
    let muscleGroupDropDown = DropDown()
    let userGoalDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    @IBAction func skillPressed(_ sender: UIButton) {
        
        skillDropDown.show()
        
    }
    @IBAction func goalPressed(_ sender: UIButton) {
        userGoalDropDown.show()
    }
    
    
    @IBAction func musclePressed(_ sender: UIButton) {
        muscleGroupDropDown.show()
    }
    
    @IBAction func typePressed(_ sender: UIButton) {
        workoutTypeDropDown.show()
    }
    
    @IBAction func selectedSkill(_ sender: UIButton) {
        if let btnLabel = sender.titleLabel?.text{
            print(skillDropDown.selectedItem!)
        }
    }
    @IBAction func selectedGoal(_ sender: UIButton) {
        if let btnLabel = sender.titleLabel?.text{ //wrong connection switch w one belwo
            print(btnLabel)
        }
    }
    
    @IBAction func selectedMuscle(_ sender: UIButton) {
        if let btnLabel = sender.titleLabel?.text{
            print(btnLabel)
        }
    }
    
    
    
    @IBAction func selectedType(_ sender: UIButton) {
        if let btnLabel = sender.titleLabel?.text{
            print(btnLabel)
        }
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
        // let ref = Database.database().reference()
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
                  let workout_description = workoutDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let uid = user?.uid else {
                showError("Invalid data")
                return
            }
            
            // upload data to Firebase Realtime Database
            let ref = Database.database().reference()
            ref.child("Users").child(uid).child("Workouts").childByAutoId().setValue([
                "goal": user_goal,
                "muscle_group": muscle_group,
                "name": workout_name,
                "skill_level": user_skill,
                "type": workout_type,
                "workout_description": workout_description
            ])
            
            // upload data to Firestore
            db.collection("Workouts").addDocument(data: [
                "goal": user_goal,
                "muscle_group": muscle_group,
                "name": workout_name,
                "skill_level": user_skill,
                "type": workout_type,
                "workout_description": workout_description,
                "uid": uid
            ]) { error in
                if let error = error {
                    showError("Error saving workout: \(error.localizedDescription)")
                } else {
                    transitionToExplore()
                }
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
        
        skillDropDown.anchorView = userSkill
        skillDropDown.bottomOffset = CGPoint(x: 0, y:(skillDropDown.anchorView?.plainView.bounds.height)! + 5)
        skillDropDown.dataSource = ["beginner", "intermediate", "expert"]
        skillDropDown.width = 105
        DropDown.appearance().setupCornerRadius(8) // available since v2.3.6
        
        skillDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userSkill.setTitle(item, for: .normal)
        }
        
        
        
        userGoalDropDown.anchorView = userGoal
        userGoalDropDown.bottomOffset = CGPoint(x: 0, y:(userGoalDropDown.anchorView?.plainView.bounds.height)! + 5)
        
        userGoalDropDown.dataSource = ["build muscle", "tone", "strength train"]
        userGoalDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userGoal.setTitle(item, for: .normal)
        }
        
        muscleGroupDropDown.anchorView = userMuscleGroup
        muscleGroupDropDown.bottomOffset = CGPoint(x: 0, y:(muscleGroupDropDown.anchorView?.plainView.bounds.height)! + 5)
        
        muscleGroupDropDown.dataSource = ["chest", "back", "legs", "shoulders", "arms", "abs", "glutes", "calves"]
        muscleGroupDropDown.width = 90
        muscleGroupDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userMuscleGroup.setTitle(item, for: .normal)
        }
        
    
        workoutTypeDropDown.anchorView = userSkill
        workoutTypeDropDown.bottomOffset = CGPoint(x: userWorkoutType.frame.origin.x, y:(workoutTypeDropDown.anchorView?.plainView.bounds.height)! + 5)
        
        workoutTypeDropDown.dataSource = ["plyometrics", "power lifting", "strength", "stretch"]
        workoutTypeDropDown.width = 105
        workoutTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userWorkoutType.setTitle(item, for: .normal)
        }
        
    }
    
}

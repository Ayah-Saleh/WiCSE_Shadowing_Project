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
    @IBOutlet weak var skillStackView: UIStackView!
    @IBOutlet weak var goalStackView: UIStackView!
    @IBOutlet weak var muscleStackView: UIStackView!
    @IBOutlet weak var typeStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        skillStackView.isHidden = true
        goalStackView.isHidden = true
        muscleStackView.isHidden = true
        typeStackView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tappedLocation = sender.location(in: view)

        // Check if the tap occurred on any of the buttons that show the stack views
        if userGoal.frame.contains(tappedLocation) {
            toggleVisibility(of: goalStackView)
        } else if userMuscleGroup.frame.contains(tappedLocation) {
            toggleVisibility(of: muscleStackView)
        } else if userSkill.frame.contains(tappedLocation) {
            toggleVisibility(of: skillStackView)
        } else if userWorkoutType.frame.contains(tappedLocation) {
            toggleVisibility(of: typeStackView)
        } else {
            hideAllStackViews()
        }
    }

    private func toggleVisibility(of stackView: UIStackView) {
        UIView.animate(withDuration: 0.3) {
            stackView.isHidden = !stackView.isHidden
        }
    }

    private func hideAllStackViews() {
        UIView.animate(withDuration: 0.3) { [self] in
            self.skillStackView.isHidden = true
            self.goalStackView.isHidden = true
            self.muscleStackView.isHidden = true
            self.typeStackView.isHidden = true
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
        userGoalDropDown.dataSource = ["build muscle", "tone", "strength train"]
        userGoalDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userGoal.setTitle(item, for: .normal)
        }
        
        let muscleGroupDropDown = DropDown()
        muscleGroupDropDown.anchorView = userMuscleGroup
        muscleGroupDropDown.dataSource = ["chest", "back", "legs", "shoulders", "arms", "abs", "glutes", "calves"]
        muscleGroupDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userMuscleGroup.setTitle(item, for: .normal)
        }
        
        let skillDropDown = DropDown()
        skillDropDown.anchorView = userSkill
        skillDropDown.dataSource = ["beginner", "intermediate", "expert"]
        skillDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userSkill.setTitle(item, for: .normal)
        }
        
        let workoutTypeDropDown = DropDown()
        workoutTypeDropDown.anchorView = userWorkoutType
        workoutTypeDropDown.dataSource = ["plyometrics", "power lifting", "strength", "stretch"]
        workoutTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.userSkill.setTitle(item, for: .normal)
        }
        
    }
    
}

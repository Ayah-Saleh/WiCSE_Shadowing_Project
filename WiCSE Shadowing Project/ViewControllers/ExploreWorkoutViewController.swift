//
//  ViewController.swift
//  WiCSE Shadowing Project
//
//  Created by Ayah Saleh on 3/7/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class ExploreWorkoutViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var workoutStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWorkouts()
    }
    
    func fetchWorkouts() {
        db.collection("Workouts").getDocuments { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents, error == nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            for document in documents {
                let workout = document.data()
                let name = workout["name"] as? String ?? ""
                let muscleGroup = workout["muscle_group"] as? String ?? ""
                let workoutType = workout["type"] as? String ?? ""
                let skillLevel = workout["skill_level"] as? String ?? ""
                let goal = workout["goal"] as? String ?? ""
                let description = workout["workout_description"] as? String ?? ""
                
                let workoutView = UIView()
                workoutView.backgroundColor = .green
                workoutView.layer.cornerRadius = 10
                workoutView.layer.masksToBounds = true
                
                let workoutName = UILabel()
                workoutName.text = name
                workoutName.font = UIFont.boldSystemFont(ofSize: 18)
                workoutName.numberOfLines = 0
                
                let workoutDetails = UILabel()
                workoutDetails.text = "\(muscleGroup) | \(workoutType) | \(skillLevel) | \(goal)"
                workoutDetails.font = UIFont.systemFont(ofSize: 14)
                workoutDetails.textColor = .white
                workoutDetails.numberOfLines = 0
                
                let workoutDescription = UILabel()
                workoutDescription.text = description
                workoutDescription.font = UIFont.systemFont(ofSize: 14)
                workoutDescription.numberOfLines = 0
                
                workoutView.addSubview(workoutName)
                workoutName.translatesAutoresizingMaskIntoConstraints = false
                workoutName.topAnchor.constraint(equalTo: workoutView.topAnchor, constant: 10).isActive = true
                workoutName.leadingAnchor.constraint(equalTo: workoutView.leadingAnchor, constant: 10).isActive = true
                workoutName.trailingAnchor.constraint(equalTo: workoutView.trailingAnchor, constant: -10).isActive = true
                
                workoutView.addSubview(workoutDetails)
                workoutDetails.translatesAutoresizingMaskIntoConstraints = false
                workoutDetails.topAnchor.constraint(equalTo: workoutName.bottomAnchor, constant: 5).isActive = true
                workoutDetails.leadingAnchor.constraint(equalTo: workoutView.leadingAnchor, constant: 10).isActive = true
                workoutDetails.trailingAnchor.constraint(equalTo: workoutView.trailingAnchor, constant: -10).isActive = true
                
                workoutView.addSubview(workoutDescription)
                workoutDescription.translatesAutoresizingMaskIntoConstraints = false
                workoutDescription.topAnchor.constraint(equalTo: workoutDetails.bottomAnchor, constant: 5).isActive = true
                workoutDescription.leadingAnchor.constraint(equalTo: workoutView.leadingAnchor, constant: 10).isActive = true
                workoutDescription.trailingAnchor.constraint(equalTo: workoutView.trailingAnchor, constant: -10).isActive = true
                workoutDescription.bottomAnchor.constraint(equalTo: workoutView.bottomAnchor, constant: -10).isActive = true
                
                self?.workoutStackView.addArrangedSubview(workoutView)
                workoutView.translatesAutoresizingMaskIntoConstraints = false
                workoutView.leadingAnchor.constraint(equalTo: self!.workoutStackView.leadingAnchor, constant: 10).isActive = true
                workoutView.trailingAnchor.constraint(equalTo: self!.workoutStackView.trailingAnchor, constant: -10).isActive = true
            }
        }
    }
    
}

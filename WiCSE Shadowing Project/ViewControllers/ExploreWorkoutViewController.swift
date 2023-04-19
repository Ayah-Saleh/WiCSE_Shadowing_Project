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
    var workoutsArr: [AnyObject] = []
    
    @IBOutlet weak var workoutStackView: UIStackView!
    @IBOutlet weak var aTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWorkouts()
    }
    
    func fetchWorkouts() {
        db.collection("Workouts").getDocuments { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents, error == nil  else {
                print("Error fetching documents: \(error!)")
                return
            }
            self!.workoutsArr = documents
            self?.aTableView.reloadData()
        }
    }
    
}
extension ExploreWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreCell", for: indexPath) as! ExploreCell
        
        let workout = self.workoutsArr[indexPath.row].data()
        cell.nameLbl.text = workout!["name"] as? String ?? ""
        
        let workoutType = workout!["type"] as? String ?? ""
        let skillLevel = workout!["skill_level"] as? String ?? ""
        let muscleGroup = workout!["muscle_group"] as? String ?? ""
        let goal = workout!["goal"] as? String ?? ""
        
        
        //
        cell.mergeLbl.text = "\(muscleGroup) | \(workoutType) | \(skillLevel) | \(goal)"
        cell.descLbl.text = workout!["workout_description"] as? String ?? ""
        
        return cell
        
    }
}

class ExploreCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mergeLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
}

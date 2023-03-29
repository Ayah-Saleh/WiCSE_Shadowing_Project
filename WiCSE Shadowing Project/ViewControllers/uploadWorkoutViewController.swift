//
//  uploadWorkoutViewController.swift
//  WiCSE Shadowing Project
//
//  Created by Ayah Saleh on 3/29/23.
//

import DropDown;
import UIKit

class uploadWorkoutViewController: UIViewController {
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
        "Item1",
        "Item2",
        "Item3",
        "Item4",
        "Item5",
        ]
        return menu
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let myView = UIView(frame: navigationController?.navigationBar.frame ?? .zero)
        navigationController?.navigationBar.topItem?.titleView = myView
        guard let topView = navigationController?.navigationBar.topItem?.titleView else{
            return
        }
        
        menu.anchorView = topView
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        topView.addGestureRecognizer(gesture)
        
        menu.selectionAction = {index, title in
            print("index \(index) and \(title)")
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapTopItem(){
        menu.show()
        
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

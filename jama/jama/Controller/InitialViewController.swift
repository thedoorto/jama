//
//  InitialViewController.swift
//  jama
//
//  Created by Mark Brightman on 09/03/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBAction func launchButtonTouched(_ sender: Any) {
        let loginNav = LoginNavigator(navigationController: self.navigationController!)
        let loginVC = LoginViewController(navigator: loginNav)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

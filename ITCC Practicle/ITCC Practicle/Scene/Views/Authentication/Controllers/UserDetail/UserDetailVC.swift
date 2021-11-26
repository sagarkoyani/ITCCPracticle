//
//  UserDetailVC.swift
//  ITCC Practicle
//
//  Created by MAC on 25/11/21.
//

import UIKit

class UserDetailVC: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    
    //MARK:- Class Variable
    var userDetail:UserProfileDataModel?
    private let viewModel = UserDetailVCViewModel()
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("USERdetailHome")
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
      
        lblFirstName.text = userDetail?.firstName
        lblLastName.text = userDetail?.lastName
        lblDOB.text = userDetail?.dob
        lblEmail.text = userDetail?.email
        lblRole.text = userDetail?.roleName
        lblGender.text = userDetail?.gender
        
    }
    
    
    //MARK:- Action Method
    
    @IBAction func onClickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//
//  LoginVC.swift
//  ITCC Practicle
//
//  Created by MAC on 25/11/21.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var lblSignUp: UILabel!
    
    
    //MARK:- Class Variable
    
    private var viewModel = LoginVCViewModel()
    
    
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    
    
    //MARK:- Action Method
    
    @IBAction func onClickLogin(_ sender: Any) {
        if txtEmail.text!.isEmpty {
            self.view.makeToast(ALERTEMAIL)
            return
        }else if txtPassword.text!.isEmpty {
            self.view.makeToast(ALERTPASS)
            return
        }
        self.viewModel.apiLogin(email: txtEmail.text!, password: txtPassword.text!)
    }
    
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.navigationController?.isNavigationBarHidden = true
        btnLogIn.cornerRadius(cornerRadius: 10.0)
        configStyle()
        
        lblSignUp.addTapGestureRecognizer(action: {
            self.navigateToSignUp()
        })
        
    }
    private func setupViewModelObserver() {
        //Login Observer
        self.viewModel.onLoginResponse.bind { (response) in
            switch response!.result
            {
            case.success(let Json):
                
                let responseJSON = JSON(Json)
                let message = responseJSON["message"].stringValue
                let status = responseJSON["status"].boolValue
                if status {
                    AUTHORIZATION_TOKEN = responseJSON["token"].stringValue
                    self.viewModel.apiGetProfile()
                }else{
                    self.view.makeToast(message)
                }
                
            case.failure( _):
                print("API Failure")
                self.view.makeToast(ALERTMSG)
                HIDE_CUSTOM_LOADER()
            }
        }
        
        //Get profile Api Observer
        self.viewModel.onGetProfileResponse.bind { (response) in
            switch response!.result
            {
            
            case.success(let Json):
                
                let responseJSON = JSON(Json)
                let message = responseJSON["message"].stringValue
                let status = responseJSON["status"].boolValue
                
                if status {
                    
                    let userData = UserProfileDataModel(fromJson:JSON(responseJSON["item"].object))
                    //Save to database
                    self.view.makeToast(message)
                    
                    // Save User profile Data to database
                    _ = DatabaseManager.getInstance().saveData(userData)
                    
                    //Retrive All User profile Data From database
                    _ = DatabaseManager.getInstance().getAllUsers()
                    
                    self.navigateToHome(userDetail: userData)
                    
                }else{
                    self.view.makeToast(message)
                }
                
            case.failure( _):
                HIDE_CUSTOM_LOADER()
                self.view.makeToast(ALERTMSG)
            }
        }
        
        
    }
    /**
     Configuration of UIControls
     */
    func configStyle(){
        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0),.foregroundColor: UIColor.colorFromHex(hex: 0x282B40)]
        let secondAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14.0),.foregroundColor: UIColor.colorFromHex(hex: 0x37C2CF)]
        
        let firstString = NSMutableAttributedString(string: "Don't have an account? ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Sign Up", attributes: secondAttributes)
        
        firstString.append(secondString)
        lblSignUp.attributedText = firstString
        
    }
    
    
    
    
    func navigateToHome(userDetail:UserProfileDataModel){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let userDetailViewController = storyBoard.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        userDetailViewController.userDetail = userDetail
        self.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
    
    func navigateToSignUp(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
}



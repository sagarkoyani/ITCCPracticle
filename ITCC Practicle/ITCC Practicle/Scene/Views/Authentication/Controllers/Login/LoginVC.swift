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
    
    private var viewModel: LoginVCViewModel!
    
    
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView() 
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
        callLoginApi()
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
    
    func callLoginApi(){
        if txtEmail.text!.isEmpty {
            self.view.makeToast(ALERTEMAIL)
           return
        }else if txtPassword.text!.isEmpty {
            self.view.makeToast(ALERTPASS)
            return
         }
        let body = ["email":txtEmail.text!,
                    "password":txtPassword.text!,
                    "platform":"iOS",
                    "os_version":"iOS 14.3",
                    "application_version":"V1",
                    "model":"iPhone",
                    "type":"Gmail",
                    "uid":"xyz"]
        
        SHOW_CUSTOM_LOADER()
        
        AF.request(APILOGINURL, method:.post, parameters:  body as [String : AnyObject]).responseJSON { (response) in
            
            HIDE_CUSTOM_LOADER()
            
            switch response.result
            {
            case.success(let Json):
                
                
                let dictJson = Json as! NSDictionary
                let message = dictJson.value(forKey: "message") as! String
                if (dictJson.value(forKey: "status") as! Bool == true){
                    AUTHORIZATION_TOKEN = dictJson.value(forKey: "token") as! String
                    self.callGetProfileApi()
                }else{
                    self.view.makeToast(message)
                }
                
            case.failure( _):
                print("API Failure")
                HIDE_CUSTOM_LOADER()
                
            }
        }
    }
    
    func callGetProfileApi(){
        SHOW_CUSTOM_LOADER()
        
        var httpHeader:HTTPHeaders = HTTPHeaders()
        httpHeader.add(name: "Authorization", value: "Bearer \(AUTHORIZATION_TOKEN)")
        AF.request(APIGETPROFILEURL, method:.get, parameters:nil,headers:httpHeader).responseJSON { (response) in
            
            HIDE_CUSTOM_LOADER()
            
            switch response.result
            {
            case.success(let Json):
                
                let dictJson = Json as! NSDictionary
                let message = dictJson.value(forKey: "message") as! String
                if (dictJson.value(forKey: "status") as! Bool == true){
                    
                    if let temp_arr = dictJson.value(forKey: "item")
                    {
                        let userData = UserProfileDataModel(fromJson:JSON(temp_arr))
                        //Save to database
                        self.view.makeToast(message)
                        
                        // Save User profile Data to database
                        _ = DatabaseManager.getInstance().saveData(userData)
                        
                        //Retrive All User profile Data From database
                        _ = DatabaseManager.getInstance().getAllUsers()
                        
                        self.navigateToHome(userDetail: userData)
                    }
                }else{
                    self.view.makeToast(message)
                }
                
            case.failure( _):
                HIDE_CUSTOM_LOADER()
                self.view.makeToast("Please Try after sometime.")
            }
        }
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



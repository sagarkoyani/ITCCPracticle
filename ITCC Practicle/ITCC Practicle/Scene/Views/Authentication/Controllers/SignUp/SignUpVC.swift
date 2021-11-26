//
//  SignUpVC.swift
//  ITCC Practicle
//
//  Created by MAC on 25/11/21.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown
class SignUpVC: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtUserType: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var btnTnC: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnPassHide: UIButton!
    @IBOutlet weak var btnCPassHide: UIButton!
    
    
    
    //------------------------------------------------------
    
    
    //MARK:- Class Variable
    private let viewModel = SignUpVCViewModel()
    let genderDropDown = DropDown()
    let userTypeDropDown = DropDown()
    var isAcceptTnC:Bool = false
    var pickerToolbar: UIToolbar?
    var datePicker = UIDatePicker()
    
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        btnSignUp.cornerRadius(cornerRadius: 10.0)
        
        
        // Drop Downs for Gender and User Type
        genderDropDown.anchorView = txtGender
        genderDropDown.dataSource = viewModel.arrGenders
        genderDropDown.bottomOffset = CGPoint(x: 0, y:(genderDropDown.anchorView?.plainView.bounds.height)!)
        genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            txtGender.text = item
        }
        
        userTypeDropDown.anchorView = txtUserType
        userTypeDropDown.dataSource = viewModel.arrUserType
        userTypeDropDown.bottomOffset = CGPoint(x: 0, y:(userTypeDropDown.anchorView?.plainView.bounds.height)!)
        userTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            txtUserType.text = item
        }
        
        
        // Date Picker for Date of Birth
        createUIToolBar()
        datePicker.datePickerMode = .date
        txtDOB.inputAccessoryView = pickerToolbar
        txtDOB.inputView = datePicker
    }
    
    
    //MARK:- Action Method
    
    @IBAction func onTickTnC(_ sender: UIButton) {
        self.btnTnC.isSelected.toggle()
    }
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        
    }
    
    @IBAction func onClickGender(_ sender: UIButton) {
        txtDOB.resignFirstResponder()
        genderDropDown.show()
    }
    
    @IBAction func onClickUsertype(_ sender: UIButton) {
        txtDOB.resignFirstResponder()
        userTypeDropDown.show()
    }
    
    @IBAction func onClickEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender {
        case btnPassHide:
            txtPassword.isSecureTextEntry.toggle()
        case btnCPassHide:
            txtCPassword.isSecureTextEntry.toggle()
        default:
            print("default")
        }
    }
    @IBAction func onClickBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
}

//MARK:- Date Picker
extension SignUpVC{
    func createUIToolBar() {
        
        pickerToolbar = UIToolbar()
        pickerToolbar?.autoresizingMask = .flexibleHeight
        
        //customize the toolbar
        pickerToolbar?.barStyle = .default
        pickerToolbar?.barTintColor = UIColor.gray
        pickerToolbar?.backgroundColor = UIColor.white
        pickerToolbar?.isTranslucent = false
        
        //add buttons
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:
                                            #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                            #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor.white
        
        //add the items to the toolbar
        pickerToolbar?.items = [cancelButton, flexSpace, doneButton]
        
    }
    
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        txtDOB.resignFirstResponder()
    }
    
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        txtDOB.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        txtDOB.text = formatter.string(from: datePicker.date)
    }
    
}

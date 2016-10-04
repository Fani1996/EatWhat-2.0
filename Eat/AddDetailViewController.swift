//
//  AddDetailViewController.swift
//  Eat
//
//  Created by Fan on 16/9/6.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class AddDetailViewController: UIViewController, UITextFieldDelegate {

   var detailAddButtonTouched = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let theSegue = segue.destination as! ViewController
        theSegue.isdetailAddButtonTouched = detailAddButtonTouched
        theSegue.textAdded = textField.text!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAdd.layer.cornerRadius = 25
        buttonAdd.layer.shadowColor = buttonAdd.layer.backgroundColor
        buttonAdd.layer.shadowOpacity = 0.4
        buttonAdd.layer.shadowOffset = CGSize(width: 1, height: 3)

        
        //TextField Settings
        textField.delegate = self
        textField.textColor = UIColor.black
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.keyboardAppearance = UIKeyboardAppearance.alert
        
    }
    
    
    @IBOutlet weak var buttonAdd: UIButton!
    
    @IBAction func detailAdd(_ sender: UIButton) {
        detailAddButtonTouched = true
    }
    
    @IBOutlet weak var textField: UITextField!
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        //Return The Keyboard
        textField.resignFirstResponder()
        return true;
    }
    
    
}

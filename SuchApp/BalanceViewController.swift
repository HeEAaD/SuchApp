//
//  FirstViewController.swift
//  SuchApp
//
//  Created by Steffen on 03.06.14.
//  Copyright (c) 2014 Steffen. All rights reserved.
//

import UIKit
import LocalAuthentication

class BalanceViewController: UIViewController {
                            
    @IBOutlet var balanceLabel : UILabel
    @IBOutlet var errorTextView : UITextView
    @IBOutlet var loadActivityIndicator : UIActivityIndicatorView

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        errorTextView.text = ""

        authenticate()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func authenticate() {

        var policyError:NSErrorPointer?

        let authContext = LAContext()
        let authPolicy = LAPolicy.DeviceOwnerAuthenticationWithBiometrics

        if(authContext.canEvaluatePolicy(authPolicy, error: policyError!)) {
            authContext.evaluatePolicy(authPolicy, localizedReason: "Paw plz!") { success, error in

                dispatch_async(dispatch_get_main_queue()) {
                    if (success) {
                        self.updateBalance()
                        self.errorTextView.text = ""
                    } else {
                        self.balanceLabel.text = "little success :("
                        self.errorTextView.text = error.localizedDescription
                    }
                }

            }
        } else {
            println("can't use touchID")
            balanceLabel.text = "less TouchID"
        }

    }

    @IBAction func reloadTouched(sender : AnyObject) {
        authenticate()
    }

    func updateBalance() {

        balanceLabel.text = "Loading..."
        loadActivityIndicator.startAnimating()

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        APIWrapper().loadAccountBalanceWithCompetionHandler() {
            self.balanceLabel.text = String($0) + " Ɖ"
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.loadActivityIndicator.stopAnimating()
        }
    }
}


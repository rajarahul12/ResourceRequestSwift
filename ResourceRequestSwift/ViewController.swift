/**
* Copyright 2016 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit
import IBMMobileFoundationSwift

class ViewController: UIViewController {

    @IBOutlet weak var inputFirstName: UITextField!
    @IBOutlet weak var inputMiddleName: UITextField!
    @IBOutlet weak var inputLastName: UITextField!
    @IBOutlet weak var inputAge: UITextField!
    @IBOutlet weak var inputHeight: UITextField!
    @IBOutlet weak var inputDate: UITextField!
    @IBOutlet weak var outputText: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func submit(_ sender: UIButton) {

        //@PathParam
        let url = URL(string: "/adapters/JavaAdapter/users/"
                                + self.inputFirstName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                + "/"
                                + self.inputMiddleName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                + "/"
            + self.inputLastName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))

        //Using POST
        let request = WLResourceRequestSwift(url: url!, method: WLResourceRequestSwift.WLHttpMethodPost)

        //@QueryParam
        request.setQueryParameterValue(parameterValue: self.inputAge.text!, forName: "age")

        //@HeaderParam("Date")
        request.setHeaderValue(value: self.inputDate.text! as NSObject, forName: "birthdate")

        //@FormParam("height")
        let formParams = ["height":self.inputHeight.text!]

        //Sending the request with Form parameters
        request.send(withFormParameters: formParams) { (response, error) -> Void in
            if(error == nil){
                print((response?.responseText)!)
                var resultText = ""
                resultText += "Name = "
                resultText += (response?.responseJSON!["first"] as! String) + " " + (response?.responseJSON!["middle"] as! String) + " " + (response?.responseJSON!["last"] as! String) + "\n"
                resultText += "Age = " + (String(response?.responseJSON!["age"] as! Int)) + "\n"
                resultText += "Height = " + (response?.responseJSON!["height"] as! String) + "\n"
                resultText += "Birthdate = " + (response?.responseJSON!["birthdate"] as! String) + "\n"

                self.outputText.text=resultText
            }
            else{
                print(error.debugDescription);
                self.outputText.text = error.debugDescription
            }
        }
    }

}

//
//  ViewController.swift
//  Dad Jokes
//
//  Created by Eros Gonzalez on 5/21/19.
//  Copyright © 2019 Eros Gonzalez. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var jokeLabel: UILabel!
    let url = URL(string: "https://icanhazdadjoke.com/")!
    let headers = [
        "Accept": "application/json"
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onJoke(_ sender: Any) {
        print (Alamofire.request(url))
        Alamofire.request(url, headers: headers).responseJSON{ response in
            // check for errors
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET")
                print(response.result.error!)
                return
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value as? [String: Any] else {
                print("didn't get todo object as JSON from API")
                if let error = response.result.error {
                    print("Error: \(error)")
                }
                return
            }
            // get and print the title
            guard let todoTitle = json["joke"] as? String else {
                print("Could not get todo title from JSON")
                return
            }
            print(todoTitle)
        }
            // check for errors
            
        
    }
    


}


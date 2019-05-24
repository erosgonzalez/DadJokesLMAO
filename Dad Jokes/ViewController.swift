//
//  ViewController.swift
//  Dad Jokes
//
//  Created by Eros Gonzalez on 5/21/19.
//  Copyright © 2019 Eros Gonzalez. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var jokeLabel: UILabel!
    let url = URL(string: "https://icanhazdadjoke.com/")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onJoke(_ sender: Any) {
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            print (data)
            print (response)
            //let joke = try! JSONSerialization.jsonObject(with: data)
            //print(joke)
            //print(response)
        }
        task.resume()
    }
    


}


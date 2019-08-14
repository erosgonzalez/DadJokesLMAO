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
import PromiseKit

class ViewController: UIViewController {
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var jokeButton: UIButton!
    @IBOutlet weak var lastJoke: UIButton!
    var jokeCount = 0
    
    var prevJokes = [String]()
    
    let url = URL(string: "https://icanhazdadjoke.com/")!
    let headers = [
        "Accept": "application/json"
    ]
    
    //var jokeQueue = Queue<String>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelFrame = CGRect(x: 40, y: 50, width: 300, height: 500)
        jokeLabel.frame = labelFrame
        
        jokeLabel.textAlignment = NSTextAlignment.center
        jokeLabel.numberOfLines = 0
        jokeLabel.sizeToFit()
        jokeLabel.adjustsFontSizeToFitWidth = true
        
        var myFrame = jokeLabel.frame
        myFrame = CGRect(x: myFrame.origin.x, y: myFrame.origin.y, width: 300, height: 500 )
        jokeLabel.frame = myFrame
        
        lastJoke.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        // Do any additional setup after loading the view, typically from a nib.
         //getJoke().done {(final: String) -> Void in self.jokeLabel.text = final}
    }
    
    override func viewDidAppear(_ animated: Bool) {
       getJoke().done {(final: String) -> Void in self.jokeLabel.text = final
            self.prevJokes.append(final)
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func onJoke(_ sender: Any) {
        if jokeCount != prevJokes.count{
            jokeCount += 1
            self.jokeLabel.text = prevJokes[jokeCount-1]
        }
        else{
            getJoke().done {(final: String) -> Void in self.jokeLabel.text = final
                self.prevJokes.append(final)
                self.jokeCount += 1
            }
        }
        
        //jokeQueue.enqueue(jokeLabel.text!)
    }
    
    @IBAction func onLastJoke(_ sender: Any) {
        if prevJokes.isEmpty || jokeCount == 0{
            print("Empty")
            let alert = UIAlertController(title: "ERROR", message: "No more jokes beyond this point.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else{
            jokeCount -= 1
            
            self.jokeLabel.text = prevJokes[jokeCount]
        }
//        if jokeQueue.isEmpty{
//            let alert = UIAlertController(title: "ERROR", message: "No previous data loaded.", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
//
//            self.present(alert, animated: true)
//        }
//        else{
//            self.jokeLabel.text = jokeQueue.dequeue()
//        }
    }
    
    @IBAction func onLogo(_ sender: Any) {
        //Switch to credits page
        
        
    }
    
    
    func getJoke () -> Promise<String> {
        var jokeIsFound = false
        var finalJoke = ""
        return Promise { final in
                Alamofire.request(url, headers: headers).responseJSON{ response in
                repeat {
                    
                    if response.result.value != nil{
                        let json = response.result.value as? [String: Any]
                        
                        if let jokeJSON = json?["joke"] as? String{
                            jokeIsFound = true
                            finalJoke = jokeJSON
                        } else{
                            jokeIsFound = false
                            //final.reject(response.result.error!)
                        }
                    }
                    
                } while jokeIsFound == false
                    final.fulfill(finalJoke)
            }
        }
    }
}

public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50{
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}



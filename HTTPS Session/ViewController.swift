//
//  ViewController.swift
//  HTTPS Session
//
//  Created by Николай Никитин on 09.01.2022.
//

import UIKit

class ViewController: UIViewController {

  //MARK: - Properties
  let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!

  //MARK - Outlets
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var descriptionLabel: UILabel!

  //MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    loadReguest()
  }

  //MARK: - Methods
  func loadReguest(){
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else {
        print (#function, #line, error?.localizedDescription ?? "no description")
        return
      }
      

      let decoder = JSONDecoder()
      guard let photoInfo = try? decoder.decode(PhotoInfo.self, from: data) else {
        print ("Can't decode as PhotoInfo")
        guard let stringData = String(data: data, encoding: .utf8) else {
          print (#line, #function, "ERROR: can't decode \(data)")
          return
        }
        print (stringData)
        return
      }
      print(photoInfo)
    }
    task.resume()
  }

}


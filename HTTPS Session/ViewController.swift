//
//  ViewController.swift
//  HTTPS Session
//
//  Created by Николай Никитин on 09.01.2022.
//

import UIKit

class ViewController: UIViewController {

  //MARK: - Properties

  var date = Date()

  //MARK - Outlets
  @IBOutlet var prevDayButton: UIBarButtonItem!
  @IBOutlet var nextDayButton: UIBarButtonItem!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var descriptionLabel: UILabel!

  //MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    nextDayButton.isEnabled = false
    loadReguest(date: date)
  }

  //MARK: - Methods
  func loadReguest(date: Date){
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    let stringDate = formatter.string(from: date)

    let query: [String: String] = [
      "api_key": "DEMO_KEY",
      "date": stringDate,
    ]

    let baseUrl = URL(string: "https://api.nasa.gov/planetary/apod")!

    navigationItem.title = "Loading... \(stringDate)"

    let url = baseUrl.withQueries(query)!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else {
        print (#function, #line, error?.localizedDescription ?? "no description")
        return
      }
      let decoder = JSONDecoder()
      guard let photoInfo = try? decoder.decode(PhotoInfo.self, from: data) else {
        guard let stringData = String(data: data, encoding: .utf8) else {
          print (#line, #function, "ERROR: can't decode \(data) as UTF8")
          return
        }
        print ("Can't decode data from \(stringData)")
        return
      }

      OperationQueue.main.addOperation {
        self.imageView.image = nil
      }

      URLSession.shared.dataTask(with: photoInfo.url) { imageData, _, _ in
        guard let imageData = imageData else { return }
        OperationQueue.main.addOperation {
          self.imageView.image = UIImage(data: imageData)
        }
      }.resume()
      DispatchQueue.main.async {
        self.navigationItem.title = photoInfo.title
        self.descriptionLabel.text = photoInfo.description
      }
    }
    task.resume()
  }

  //MARK: - Actions
  @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
    switch sender {
    case prevDayButton:
      date = date.addingTimeInterval(-24 * 60 * 60)
      loadReguest(date: date)
      nextDayButton.isEnabled = true
    case nextDayButton:
      let tomorrow = date.addingTimeInterval(24 * 60 * 60)
      let afterTomorrow = tomorrow.addingTimeInterval(24 * 60 * 60)
      nextDayButton.isEnabled = afterTomorrow <= Date()
      guard tomorrow <= Date() else { return }
date = tomorrow
    default:
      return
    }
    loadReguest(date: date)
  }
}


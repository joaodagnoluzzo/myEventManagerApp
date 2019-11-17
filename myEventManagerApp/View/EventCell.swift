//
//  EventCell.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 15/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    
    var imagePath: String? {
        didSet {
            guard let imagePath = imagePath else { return }
//            self.imageView?.alpha = 0
            
            guard let url = URL(string: imagePath) else { return }
            self.eventImage?.load(url: url)
            self.eventImage?.contentMode = .scaleToFill
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupImageView()
        setupCellTitle()
    }
    
    func configureWithEvent(event: Event){
        self.eventName.text = event.title
        self.imagePath = event.image
    }
    
    func setupCellTitle(){
//        self.eventName.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        self.eventName.adjustsFontForContentSizeCategory = true
    }
    
    func setupImageView(){
        self.eventImage.layer.cornerRadius = self.eventImage.frame.size.height / 2.0
        self.eventImage.layer.masksToBounds = true
        self.eventImage.layer.borderWidth = 2
        self.eventImage.layer.borderColor = UIColor.gray.cgColor
    }

}

extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
//                        for view in self.superview!.subviews{
//                            if let spinnerView = view as? UIActivityIndicatorView{
//                                spinnerView.stopAnimating()
//                                break
//                            }
//                        }
                        self.image = image
//                        UIView.animate(withDuration: 0.5) {
//                            self.alpha = 1
//                        }
                    }
                }
            } else {
               print("Could not retrieve image")
                
            // handle error
           }
        }
    }
}

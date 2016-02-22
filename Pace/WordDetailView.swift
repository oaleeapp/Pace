//
//  WordDetailView.swift
//  Pace
//
//  Created by lee on 2/16/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

@IBDesignable
class WordDetailView: UIView {

    var view: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var syllablesLabel: UILabel!
    @IBOutlet weak var pronunciationLabel: UILabel!
    @IBOutlet weak var downloadButton: DownloadWordButton!

    let nibName = "WordDetailView"

    var viewModel: WordDetailViewModel! {
        didSet{
            viewModel.delegate = self
        }
    }

    func setUpWithWord(word: MOWord) {

        wordLabel.text = word.word
        syllablesLabel.text = word.syllables
        pronunciationLabel.text = word.pronunciation

        downloadButton.downloadState = word.downloadState
        downloadButton.rank = word.rank

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        xibSetUp()
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        xibSetUp()
    }

    func xibSetUp() {
        // setup the view from .xib
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        // grabs the appropriate bundle
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView

        return view
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        wordLabel.text = "describe"
        syllablesLabel.text = "de-scribe"
        pronunciationLabel.text = "/dI'skraIab/"
        
        
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


extension WordDetailView: WordDetailViewModelDelegate {

    func wordWillChange(word: MOWord) {

    }

    func wordDidChange(word: MOWord) {
        setUpWithWord(word)
    }
}
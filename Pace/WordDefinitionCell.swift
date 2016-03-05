//
//  WordDefinitionCell.swift
//  Pace
//
//  Created by lee on 1/4/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class WordDefinitionCell: UICollectionViewCell {

    @IBOutlet weak var definitionLabel: UILabel!

    @IBOutlet weak var partOfSpeechIndicateView: UIView!

    @IBOutlet weak var levelView: PaceLevelView!

    @IBOutlet weak var cardifyButton: UIButton!



    let nibName = "WordDefinitionCell"
    var view : UIView!

    var viewModel: WordDefinitionCellViewModel! {
        didSet{
            viewModel.delegate = self
            setUpWithDefinition(viewModel.definition)
        }
    }

    func setUpWithDefinition(definition: MODefinition){
        definitionLabel.text = definition.definition
        partOfSpeechIndicateView.backgroundColor = UIColor(hexString: definition.colorHexString!)
        cardifyButton.selected = definition.needsShow

        levelView.level = definition.level

        view.backgroundColor = definition.needsShow ? UIColor(themeColor: .LightCardBackgroundColor) : UIColor(themeColor: .LightDescribeColor)
        levelView.alpha = definition.needsShow ? 1.0 : 0.7
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetUp()
    }

    func xibSetUp() {
        // setup the view from .xib
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        view.layer.cornerRadius = 15.0
    }

    func loadViewFromNib() -> UIView {
        // grabs the appropriate bundle
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView

        return view
    }


    @IBAction func cardifyDefinition(sender: UIButton) {
        let needsShow = !sender.selected
        viewModel.setNeedsShow(needsShow)
    }

}


extension WordDefinitionCell : WordDefinitionCellViewModelDelegate {

    func definitionWillChange(definition: MODefinition) {

    }

    func definitionDidChange(definition: MODefinition) {
        setUpWithDefinition(definition)
    }
}
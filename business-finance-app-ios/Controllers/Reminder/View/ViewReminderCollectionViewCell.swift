//
//  ViewReminderCollectionViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/7/12.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class ViewReminderCollectionViewCell: UICollectionViewCell {
    public var lab: UILabel = UILabel()
    public var bgView: UIView = UIView()
    let spaceBtnCell = 4 * AutoSizeScaleX
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.App.TableView.grayBackground
        
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        let bgView: UIView = UIView()
        bgView.backgroundColor = UIColor.App.TableView.grayBackground
        bgView.layer.cornerRadius = 6 * AutoSizeScaleX
        bgView.layer.borderWidth = 1 * AutoSizeScaleX
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowOpacity = 0.12
        bgView.layer.shadowRadius = 3
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(spaceBtnCell * AutoSizeScaleX)
            make.bottom.equalTo(-spaceBtnCell * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(spaceBtnCell * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-spaceBtnCell * AutoSizeScaleX)
        }
        
        let lab: UILabel = UILabel()
        lab.textColor = UIColor(hexString: "#2B395C")
        lab.textAlignment = .center
        lab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        bgView.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(bgView)
        }
        self.lab = lab
    }
}

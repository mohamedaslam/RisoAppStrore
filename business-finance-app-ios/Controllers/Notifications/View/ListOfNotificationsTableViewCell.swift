//
//  ListOfNotificationsTableViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/10/8.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class ListOfNotificationsTableViewCell: UITableViewCell {
    var currentIndex: IndexPath?
    
    var benefitNotificationNameLab: UILabel = UILabel()
    var reminderDay: UILabel = UILabel()
    var benefitNotificationTimeLab: UILabel = UILabel()
    var benefitNotificationDateLab: UILabel = UILabel()
    var benefitNotificationLetterLab: UILabel = UILabel()
    var benefitNotificationSubTitleLab : UILabel = UILabel()
    var bgView: UIView = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        
        let bgView: UIView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 2 * AutoSizeScaleX
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowRadius = 4
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(134 * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-20 * AutoSizeScaleX)
        }
      
        let benefitNotificationLetterLab: UILabel = UILabel()
        benefitNotificationLetterLab.textColor = .white
        benefitNotificationLetterLab.textAlignment = .center
        benefitNotificationLetterLab.text = "M"
        benefitNotificationLetterLab.font = UIFont.appFont(ofSize: 20, weight: .bold)
        benefitNotificationLetterLab.backgroundColor = UIColor(hexString: "#3868F6")
        benefitNotificationLetterLab.layer.cornerRadius = 25 * AutoSizeScaleX
        benefitNotificationLetterLab.layer.masksToBounds = true
        bgView.addSubview(benefitNotificationLetterLab)
        benefitNotificationLetterLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16 * AutoSizeScaleX)
            make.centerY.equalTo(bgView)
            make.width.height.equalTo(50 * AutoSizeScaleX)
        }
        self.benefitNotificationLetterLab = benefitNotificationLetterLab
        
        let benefitNotificationTime: UILabel = UILabel()
        benefitNotificationTime.setContentHuggingPriority(.required, for: .horizontal)
        benefitNotificationTime.setContentCompressionResistancePriority(.required, for: .horizontal)
        benefitNotificationTime.textColor = .lightGray
        benefitNotificationTime.textAlignment = .right
        benefitNotificationTime.text = ""
        benefitNotificationTime.textColor = UIColor(hexString: "#3868F6")
        benefitNotificationTime.font = UIFont.appFont(ofSize: 13, weight: .regular)
        bgView.addSubview(benefitNotificationTime)
        benefitNotificationTime.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-14 * AutoSizeScaleX)
            make.top.equalTo(bgView).offset(14 * AutoSizeScaleX)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.width.equalTo(56 * AutoSizeScaleX)
        }
        self.benefitNotificationTimeLab = benefitNotificationTime
        
        let benefitNotificationDateLab: UILabel = UILabel()
        benefitNotificationDateLab.setContentHuggingPriority(.required, for: .horizontal)
        benefitNotificationDateLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        benefitNotificationDateLab.textColor = .lightGray
        benefitNotificationDateLab.textAlignment = .right
        benefitNotificationDateLab.text = ""
        benefitNotificationDateLab.textColor = UIColor(hexString: "#3868F6")
        benefitNotificationDateLab.font = UIFont.appFont(ofSize: 13, weight: .regular)
        bgView.addSubview(benefitNotificationDateLab)
        benefitNotificationDateLab.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-14 * AutoSizeScaleX)
            make.top.equalTo(benefitNotificationTime.snp_bottom).offset(4 * AutoSizeScaleX)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.width.equalTo(56 * AutoSizeScaleX)
        }
        self.benefitNotificationDateLab = benefitNotificationDateLab
        
        let benefitNotificationNameLab: UILabel = UILabel()
        benefitNotificationNameLab.setContentHuggingPriority(.required, for: .horizontal)
        benefitNotificationNameLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        benefitNotificationNameLab.textAlignment = .left
        benefitNotificationNameLab.text = ""
        benefitNotificationNameLab.lineBreakMode = .byWordWrapping
        benefitNotificationNameLab.numberOfLines = 0
        benefitNotificationNameLab.font = UIFont.appFont(ofSize: 17, weight: .bold)
        benefitNotificationNameLab.textColor = UIColor(hexString: "#2B395C")
        bgView.addSubview(benefitNotificationNameLab)
        benefitNotificationNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(benefitNotificationLetterLab.snp_right).offset(12 * AutoSizeScaleX)
            make.right.equalTo(benefitNotificationTime.snp_leftMargin)
            make.top.equalTo(benefitNotificationTime)
            make.height.equalTo(42 * AutoSizeScaleX)
        }
        self.benefitNotificationNameLab = benefitNotificationNameLab
        
        let benefitNotificationSubTitleLab: UILabel = UILabel()
        benefitNotificationSubTitleLab.setContentHuggingPriority(.required, for: .horizontal)
        benefitNotificationSubTitleLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        benefitNotificationSubTitleLab.textColor = UIColor(hexString: "#2B395C").alpha(0.4)
        benefitNotificationSubTitleLab.textAlignment = .left
        benefitNotificationSubTitleLab.lineBreakMode = .byWordWrapping
        benefitNotificationSubTitleLab.numberOfLines = 0
        benefitNotificationSubTitleLab.text = " "
        benefitNotificationSubTitleLab.font = UIFont.appFont(ofSize: 13 * AutoSizeScaleX, weight: .regular)
        bgView.addSubview(benefitNotificationSubTitleLab)
        benefitNotificationSubTitleLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(benefitNotificationNameLab)
            make.top.equalTo(benefitNotificationNameLab.snp_bottom).offset(4 * AutoSizeScaleX)
            make.bottom.equalTo(bgView).offset(-4 * AutoSizeScaleX)
        }
        self.benefitNotificationSubTitleLab = benefitNotificationSubTitleLab
        
    }
    

}

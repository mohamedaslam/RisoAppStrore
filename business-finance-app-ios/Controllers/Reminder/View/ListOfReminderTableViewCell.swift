//
//  ListOfReminderTableViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/7/18.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class ListOfReminderTableViewCell: UITableViewCell {
    var currentIndex: IndexPath?
    
    var reminderNameLab: UILabel = UILabel()
    var reminderDay: UILabel = UILabel()
    var reminderTime: UILabel = UILabel()
    var reminderSubTitleLab : UILabel = UILabel()
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
        bgView.layer.shadowOpacity = 0.12
        bgView.layer.shadowRadius = 3
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(74 * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-20 * AutoSizeScaleX)
        }
        
     
        let reminderTime: UILabel = UILabel()
        reminderTime.setContentHuggingPriority(.required, for: .horizontal)
        reminderTime.setContentCompressionResistancePriority(.required, for: .horizontal)
        reminderTime.textColor = .lightGray
        reminderTime.textAlignment = .right
        reminderTime.text = "13:20"
        reminderTime.font = UIFont.appFont(ofSize: 14, weight: .regular)
        bgView.addSubview(reminderTime)
        reminderTime.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-14 * AutoSizeScaleX)
            make.top.equalTo(bgView).offset(10 * AutoSizeScaleX)
            make.height.equalTo(30 * AutoSizeScaleX)
            make.width.equalTo(80 * AutoSizeScaleX)
        }
        self.reminderTime = reminderTime
        
        let reminderNameLab: UILabel = UILabel()
        reminderNameLab.setContentHuggingPriority(.required, for: .horizontal)
        reminderNameLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        reminderNameLab.textAlignment = .left
        reminderNameLab.text = "Internet"
        reminderNameLab.font = UIFont.appFont(ofSize: 18, weight: .bold)
        reminderNameLab.textColor = UIColor(hexString: "#2B395C")
        bgView.addSubview(reminderNameLab)
        reminderNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16 * AutoSizeScaleX)
            make.right.equalTo(reminderTime.snp_leftMargin)
            make.top.height.equalTo(reminderTime)
        }
        self.reminderNameLab = reminderNameLab
        
        let reminderSubTitleLab: UILabel = UILabel()
        reminderSubTitleLab.setContentHuggingPriority(.required, for: .horizontal)
        reminderSubTitleLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        reminderSubTitleLab.textColor = .lightGray
        reminderSubTitleLab.textAlignment = .left
        reminderSubTitleLab.lineBreakMode = .byWordWrapping
        reminderSubTitleLab.numberOfLines = 0
        reminderSubTitleLab.text = "Upload Internet bill Dont forget mohammed aslam shaik"
        reminderSubTitleLab.font = UIFont.appFont(ofSize: 12 * AutoSizeScaleX, weight: .regular)
        bgView.addSubview(reminderSubTitleLab)
        reminderSubTitleLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(reminderNameLab)
            make.top.equalTo(reminderNameLab.snp_bottomMargin).offset(4 * AutoSizeScaleX)
            make.height.equalTo(40 * AutoSizeScaleX)
        }
        self.reminderSubTitleLab = reminderSubTitleLab
        
        let reminderDay: UILabel = UILabel()
        reminderDay.setContentHuggingPriority(.required, for: .horizontal)
        reminderDay.setContentCompressionResistancePriority(.required, for: .horizontal)
        reminderDay.textColor = .lightGray
        reminderDay.textAlignment = .right
        reminderDay.text = "Weekly"
        reminderDay.font = UIFont.appFont(ofSize: 12 * AutoSizeScaleX, weight: .semibold)
        bgView.addSubview(reminderDay)
        reminderDay.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(reminderTime)
            make.top.equalTo(reminderNameLab.snp_bottomMargin).offset(4 * AutoSizeScaleX)
        }
        self.reminderDay = reminderDay
    }
    

}

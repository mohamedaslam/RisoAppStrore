//
//  CreateReminderTableViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/6/28.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class CreateReminderTableViewCell: UITableViewCell{
    var currentIndex: IndexPath?
    
    var reminderNameLab: UILabel = UILabel()
    var reminderDay: UILabel = UILabel()
    var reminderTime: UILabel = UILabel()
    var reminderSubTitleLab : UILabel = UILabel()
    var textField : UITextField = UITextField()
    var descriptionTF1 : UITextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .green
        
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
        bgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(70 * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-20 * AutoSizeScaleX)
        }
        
        let nameTF: UITextField = UITextField()
        nameTF.clearButtonMode = UITextField.ViewMode.always
        bgView.addSubview(nameTF)
        textField = nameTF
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(bgView).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(bgView).offset(4 * AutoSizeScaleX)
            make.height.equalTo(30 * AutoSizeScaleX)
        }
        
        let descriptionTF: UITextField = UITextField()
        descriptionTF.clearButtonMode = UITextField.ViewMode.always
        bgView.addSubview(descriptionTF)
        descriptionTF1 = descriptionTF
        descriptionTF.snp.makeConstraints { (make) in
            make.height.left.right.equalTo(nameTF)
            make.top.equalTo(nameTF.snp_bottom)
        }
    }
    

}

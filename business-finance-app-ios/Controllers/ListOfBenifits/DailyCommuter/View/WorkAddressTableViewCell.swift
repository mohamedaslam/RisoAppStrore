//
//  WorkAddressTableViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/9/6.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class WorkAddressTableViewCell: UITableViewCell {
    var currentIndex: IndexPath?
    
    var addressLab: UILabel = UILabel()
    var selectImgView: UIImageView = UIImageView()
    var bgView: UIView = UIView()
    var editBGBtn : UIButton = UIButton()
    var addNewBtn : UIButton = UIButton()
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
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
        }
        
        let separateLine: UIView = UIView()
        separateLine.backgroundColor = .lightGray
        bgView.addSubview(separateLine)
        separateLine.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(1)
            make.height.equalTo(0.7 * AutoSizeScaleX)
            make.left.equalTo(bgView)
            make.right.equalTo(bgView)
        }
        
        let editBGBtn: UIButton = UIButton(type: .custom)
        editBGBtn.layer.cornerRadius = 15 * AutoSizeScaleX
        editBGBtn.backgroundColor = UIColor(hexString: "#3868F6")
        editBGBtn.setImage(UIImage(named:"editUser"), for: .normal)
        bgView.addSubview(editBGBtn)
        self.editBGBtn = editBGBtn
        editBGBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-10 * AutoSizeScaleX)
            make.centerY.equalTo(bgView)
            make.height.width.equalTo(30 * AutoSizeScaleX)
        }
        
        let titleLab: UILabel = UILabel()
        titleLab.setContentHuggingPriority(.required, for: .horizontal)
        titleLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLab.textColor = UIColor(hexString: "#2B395C")
        titleLab.numberOfLines = 0
        titleLab.textAlignment = .left
        titleLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        bgView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16 * AutoSizeScaleX)
            make.centerY.height.equalTo(bgView)
            make.right.equalTo(editBGBtn.snp_left)
            make.height.equalTo(40 * AutoSizeScaleX)
        }
        self.addressLab = titleLab
                

        
        let addNewBtn: UIButton = UIButton(type: .custom)
        addNewBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        addNewBtn.setTitle( "Add new address", for: .normal)
        addNewBtn.titleLabel?.font = UIFont.appFont(ofSize: 14, weight: .regular)
        addNewBtn.titleLabel?.textAlignment = .left
        addNewBtn.contentHorizontalAlignment = .left
        bgView.addSubview(addNewBtn)
        self.addNewBtn = addNewBtn
        addNewBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(bgView).offset(20 * AutoSizeScaleX)
            make.centerY.equalTo(bgView)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let addAddressImgView: UIImageView = UIImageView()
        addAddressImgView.image = UIImage.init(named: "addAddress")
        addAddressImgView.contentMode = .scaleAspectFit
        addNewBtn.addSubview(addAddressImgView)
        addAddressImgView.snp.makeConstraints { (make) in
            make.right.equalTo(addNewBtn).offset(-10 * AutoSizeScaleX)
            make.centerY.equalTo(addNewBtn)
            make.width.height.equalTo(24 * AutoSizeScaleX)
        }
    }
}

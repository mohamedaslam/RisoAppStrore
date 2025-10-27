//
//  DailyCommuterTypeTableViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/8/26.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class DailyCommuterTypeTableViewCell: UITableViewCell {
    var currentIndex: IndexPath?
    
    var titleLab: UILabel = UILabel()
    var selectImgView: UIImageView = UIImageView()
    var bgView: UIView = UIView()
    var selectBtn : UIButton = UIButton()
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
            make.height.equalTo(44 * AutoSizeScaleX)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
        }
        
        let titleLab: UILabel = UILabel()
        titleLab.setContentHuggingPriority(.required, for: .horizontal)
        titleLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLab.textColor = UIColor(hexString: "#2B395C")
        titleLab.textAlignment = .left
        titleLab.text = "KINDERGARTEN"
        titleLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        bgView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16 * AutoSizeScaleX)
            make.centerY.height.equalTo(bgView)
            make.width.equalTo(200 * AutoSizeScaleX)
        }
        self.titleLab = titleLab
                
        let selectImgView: UIImageView = UIImageView()
        selectImgView.image = UIImage.init(named: "typeUnCheck")
        selectImgView.contentMode = .scaleAspectFit
        bgView.addSubview(selectImgView)
        self.selectImgView = selectImgView
        selectImgView.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-20 * AutoSizeScaleX)
            make.centerY.equalTo(bgView)
            make.width.height.equalTo(24 * AutoSizeScaleX)
        }

        
        let separateLine: UILabel = UILabel()
        separateLine.backgroundColor = .lightGray
        bgView.addSubview(separateLine)
        separateLine.snp.makeConstraints { (make) in
            make.right.equalTo(bgView)
            make.left.equalTo(bgView).offset(16 * AutoSizeScaleX)
            make.bottom.equalTo(bgView)
            make.height.equalTo(1 * AutoSizeScaleX)
        }
        
    }
}

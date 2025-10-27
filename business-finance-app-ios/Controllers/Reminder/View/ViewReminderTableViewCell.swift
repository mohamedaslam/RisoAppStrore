//
//  ViewReminderTableViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/7/12.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
let cellHeight: CGFloat = AutoSizeScale(80)

class ViewReminderTableViewCell: UITableViewCell {
    var currentIndex: IndexPath?
    
    var reminderNameLab: UILabel = UILabel()
    var reminderDay: UILabel = UILabel()
    var reminderTime: UILabel = UILabel()
    var reminderSubTitleLab : UILabel = UILabel()
    var cellHeight: CGFloat = 0
    var textBtn : UIButton = UIButton()
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
        bgView.backgroundColor = UIColor.App.TableView.grayBackground
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(self.contentView)
        }
        let list = [["Tue", "Wed","Fri","Mon","Wed"],["Wed","Tue"]]
        var groups = [UIStackView]()
        for i in list {
            let group = createButtons(named: i)
            let subStackView = UIStackView(arrangedSubviews: group)
                subStackView.axis = .horizontal
            subStackView.distribution = UIStackView.Distribution.fillEqually
            subStackView.alignment = UIStackView.Alignment.fill
                subStackView.spacing = 14 * AutoSizeScaleX
                groups.append(subStackView)
            }
        
        let stackView = UIStackView(arrangedSubviews: groups)
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.backgroundColor = UIColor.App.TableView.grayBackground
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(stackView)
                stackView.snp.makeConstraints { (make) in
                    make.left.equalTo(bgView).offset(4 * AutoSizeScaleX)
                    make.right.equalTo(bgView).offset(-4 * AutoSizeScaleX)
                    make.top.equalTo(bgView).offset(10 * AutoSizeScaleX)
                    if(list.count == 0){
                        self.cellHeight = 50
                    }else if(list.count == 1){
                        self.cellHeight = 70

                    }else if(list.count == 2){
                        self.cellHeight = 100
                    }
                    make.height.equalTo(self.cellHeight * AutoSizeScaleX)
            }

        
        let reminderLabel: UILabel = UILabel()
        reminderLabel.setContentHuggingPriority(.required, for: .horizontal)
        reminderLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        reminderLabel.textColor = .lightGray
        reminderLabel.textAlignment = .left
        reminderLabel.numberOfLines = 0
        reminderLabel.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .semibold)
        bgView.addSubview(reminderLabel)
        reminderLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.height.equalTo(40 * AutoSizeScaleX)
            make.top.equalTo(stackView.snp_bottom).offset(6 * AutoSizeScaleX)
        }
    }
    
    func createButtons(named: [String]) -> [UIButton]{
       return named.map { letter in
         let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitle(letter, for: .normal)
           button.backgroundColor = UIColor.App.TableView.grayBackground
           button.setTitleColor(.black, for: .normal)
           button.layer.cornerRadius = 6 * AutoSizeScaleX
           button.layer.borderWidth = 1 * AutoSizeScaleX
           button.layer.borderColor = UIColor.white.cgColor
           button.layer.shadowColor = UIColor.black.cgColor
           button.layer.shadowOffset = CGSize.zero
           button.layer.shadowOpacity = 0.12
           button.layer.shadowRadius = 3
           button.layer.borderColor = UIColor(hexString: "#1E4199").cgColor
           button.snp.makeConstraints { (make) in
               make.width.equalTo(60 * AutoSizeScaleX)
          }
         return button
       }
    }
}

//
//  abstractCell.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/11.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface abstractCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLable;
//@property (weak, nonatomic) IBOutlet UILabel *synopsisLable;
@property (weak, nonatomic) IBOutlet UIWebView *synopsisWebView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@end

//
//  costCell.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/11.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface costCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@property (weak, nonatomic) IBOutlet UIWebView *includeWeb;

@property (weak, nonatomic) IBOutlet UIWebView *notIncludeWeb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *includeCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notIncludeCons;
@end

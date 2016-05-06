//
//  detailsCell.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/11.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *contentWeb;
@property (weak, nonatomic) IBOutlet UIWebView *HarvestWeb;

@property (weak, nonatomic) IBOutlet UIWebView *RequirementWeb;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *requirentCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *harvestCons;
@end

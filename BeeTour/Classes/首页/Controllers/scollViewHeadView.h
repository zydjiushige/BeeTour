//
//  scollViewHeadView.h
//  HomeOfWatch
//
//  Created by 赵雍丹 on 15/9/15.
//  Copyright (c) 2015年 赵雍丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scollViewHeadView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property(nonatomic,strong)UIPageControl *pageCon;
@property(nonatomic,strong)UILabel *titleLable;

@end

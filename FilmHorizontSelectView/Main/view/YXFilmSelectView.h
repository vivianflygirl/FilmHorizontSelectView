//
//  YXFilmSelectView.h
//
//  Created by vivian on 16/9/5
//  Copyright (c) 2016 vivian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXFilmSelectViewDelegate <NSObject>

-(void)itemSelected:(NSInteger)index;

@end

@interface YXFilmSelectView : UIView

@property (nonatomic, weak) id<YXFilmSelectViewDelegate> delegate;

-(instancetype)initViewWithImageArray:(NSArray *)imageArray;

@property(nonatomic)NSInteger isClick;

@end

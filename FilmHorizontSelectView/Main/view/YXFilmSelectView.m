//
//  YXFilmSelectView.m
//
//  Created by vivian on 16/9/5
//  Copyright (c) 2016 vivian. All rights reserved.
//

#import "YXFilmSelectView.h"
#import "UIView+Positioning.h"
#import "UIImageView+WebCache.h"

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
//#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height

#define NORMAL_VIEW_WIDTH 65  //不选中大小
#define NORMAL_VIEW_HEIGHT 89

#define SELECT_VIEW_WIDTH 74  //选中大小
#define SELECT_VIEW_HEIGHT 101

#define ITEM_SPACE 14  //间隔
#define LEFT_SPACE (SCREEN_WIDTH/2-NORMAL_VIEW_WIDTH/2)

@interface YXFilmSelectView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) UIImageView *imArror;

@end

@implementation YXFilmSelectView

-(instancetype)initViewWithImageArray:(NSArray *)imageArray{
    if (!imageArray) {
        return nil;
    }
    if (imageArray.count<1) {
        return nil;
    }

    NSInteger totalNum = imageArray.count;
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 128)];
    if (self) {
        _scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollview.backgroundColor = [UIColor clearColor];
        _scrollview.contentSize = CGSizeMake(LEFT_SPACE*2+SELECT_VIEW_WIDTH+(totalNum-1)*NORMAL_VIEW_WIDTH+(totalNum-1)*ITEM_SPACE, 128);
        _scrollview.delegate = self;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.decelerationRate = UIScrollViewDecelerationRateFast;
        [self addSubview:_scrollview];
        
        self.imArror.frame = CGRectMake(_scrollview.frame.size.width/2-10, _scrollview.frame.size.height-10, 20, 10);
        [self addSubview:self.imArror];

        _imageViewArray = [NSMutableArray array];
        _viewArray = [NSMutableArray array];

        CGFloat offsetX = LEFT_SPACE;
        for (int i=0; i<totalNum; i++) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(offsetX, _scrollview.height-NORMAL_VIEW_HEIGHT-55, NORMAL_VIEW_WIDTH, self.height)];
            view.backgroundColor = [UIColor clearColor];
            [_scrollview addSubview:view];
            [_viewArray addObject:view];
            offsetX += NORMAL_VIEW_WIDTH+ITEM_SPACE;
            
            
            CGRect rect;
            rect = CGRectMake(0, _scrollview.height-NORMAL_VIEW_HEIGHT, NORMAL_VIEW_WIDTH, NORMAL_VIEW_HEIGHT);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
            [imageView addGestureRecognizer:tap];
            [view addSubview:imageView];
            [_imageViewArray addObject:imageView];
        }

    }
    return self;
}

-(void)setIsClick:(NSInteger)isClick
{
    NSLog(@"%ld", isClick);
    UIImageView *imageView = _imageViewArray[isClick];
    imageView.frame = CGRectMake(-(SELECT_VIEW_WIDTH-NORMAL_VIEW_WIDTH)/2, _scrollview.height-SELECT_VIEW_HEIGHT, SELECT_VIEW_WIDTH, SELECT_VIEW_HEIGHT);
    
    UIView *containerView = _viewArray[isClick];
    CGFloat offsetX = CGRectGetMidX(containerView.frame)-SCREEN_WIDTH/2;
    [_scrollview scrollRectToVisible:CGRectMake(offsetX, 0, SCREEN_WIDTH, 120) animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(itemSelected:)]) {
        [_delegate itemSelected:isClick];
    }
}

-(void)clickImage:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger tag = imageView.tag;
    UIView *containerView = _viewArray[tag];
    CGFloat offsetX = CGRectGetMidX(containerView.frame)-SCREEN_WIDTH/2;
    [_scrollview scrollRectToVisible:CGRectMake(offsetX, 0, SCREEN_WIDTH, 120) animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(itemSelected:)]) {
        [_delegate itemSelected:tag];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentIndex = scrollView.contentOffset.x/(NORMAL_VIEW_WIDTH+ITEM_SPACE);
    if (currentIndex>_imageViewArray.count-2||currentIndex<0) {
        return;
    }
    int rightIndex = currentIndex+1;
    UIImageView *currentImageView = _imageViewArray[currentIndex];
    UIImageView *rightImageView = _imageViewArray[rightIndex];
    
    
    CGFloat scale =  (scrollView.contentOffset.x-currentIndex*(NORMAL_VIEW_WIDTH+ITEM_SPACE))/(NORMAL_VIEW_WIDTH+ITEM_SPACE);
    
    CGFloat width = SELECT_VIEW_WIDTH-scale*(SELECT_VIEW_WIDTH-NORMAL_VIEW_WIDTH);
    CGFloat height = SELECT_VIEW_HEIGHT-scale*(SELECT_VIEW_HEIGHT-NORMAL_VIEW_HEIGHT);
    if (width<NORMAL_VIEW_WIDTH) {
        width = NORMAL_VIEW_WIDTH;
    }
    if (height<NORMAL_VIEW_HEIGHT) {
        height = NORMAL_VIEW_HEIGHT;
    }
    if (width>SELECT_VIEW_WIDTH) {
        width = SELECT_VIEW_WIDTH;
    }
    if (height>SELECT_VIEW_HEIGHT) {
        height = SELECT_VIEW_HEIGHT;
    }
    CGRect rect = CGRectMake(-(width-NORMAL_VIEW_WIDTH)/2, _scrollview.height-height, width, height);
    currentImageView.frame = rect;
    
    width = NORMAL_VIEW_WIDTH+scale*(SELECT_VIEW_WIDTH-NORMAL_VIEW_WIDTH);
    height = NORMAL_VIEW_HEIGHT+scale*(SELECT_VIEW_HEIGHT-NORMAL_VIEW_HEIGHT);
    if (width<NORMAL_VIEW_WIDTH) {
        width = NORMAL_VIEW_WIDTH;
    }
    if (height<NORMAL_VIEW_HEIGHT) {
        height = NORMAL_VIEW_HEIGHT;
    }
    if (width>SELECT_VIEW_WIDTH) {
        width = SELECT_VIEW_WIDTH;
    }
    if (height>SELECT_VIEW_HEIGHT) {
        height = SELECT_VIEW_HEIGHT;
    }
    rect = CGRectMake(-(width-NORMAL_VIEW_WIDTH)/2, _scrollview.height-height, width, height);
    rightImageView.frame = rect;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        int currentIndex = roundf(scrollView.contentOffset.x/(NORMAL_VIEW_WIDTH+ITEM_SPACE));
        UIView *containerView = _viewArray[currentIndex];
        CGFloat offsetX = CGRectGetMidX(containerView.frame)-SCREEN_WIDTH/2;
        [_scrollview scrollRectToVisible:CGRectMake(offsetX, 0, SCREEN_WIDTH, 120) animated:YES];
        if (_delegate && [_delegate respondsToSelector:@selector(itemSelected:)]) {
            [_delegate itemSelected:currentIndex];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentIndex = roundf(scrollView.contentOffset.x/(NORMAL_VIEW_WIDTH+ITEM_SPACE));
    UIView *containerView = _viewArray[currentIndex];
    CGFloat offsetX = CGRectGetMidX(containerView.frame)-SCREEN_WIDTH/2;
    [_scrollview scrollRectToVisible:CGRectMake(offsetX, 0, SCREEN_WIDTH, 120) animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(itemSelected:)]) {
        [_delegate itemSelected:currentIndex];
    }
}

-(UIImageView*)imArror
{
    if (!_imArror) {
        _imArror = [[UIImageView alloc]init];
        _imArror.image = [UIImage imageNamed:@"Rectangle97"];
    }
    return _imArror;
}



@end

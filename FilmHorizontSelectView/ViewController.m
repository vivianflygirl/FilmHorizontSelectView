//
//  ViewController.m
//  FilmHorizontSelectView
//
//  Created by vivian on 16/9/28.
//  Copyright © 2016年 vivian. All rights reserved.
//

#import "ViewController.h"
#import "YXFilmSelectView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+LBBlurredImage.h"

@interface ViewController ()<YXFilmSelectViewDelegate>
@property(nonatomic,strong)YXFilmSelectView *filmSelectView;
@property(nonatomic,strong) UIVisualEffectView *effectView;
@property(nonatomic,strong) NSArray *imageNames;
@property(nonatomic,strong) UIImageView  *bgImgV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"电影图片滚动";
    [self.view addSubview:self.bgImgV];
    
    self.imageNames = [NSArray arrayWithObjects:@"http://img2.ixingmei.com/uploads/131125/3-13112516355NY_n.jpg",@"http://img2.ixingmei.com/uploads/151217/2-15121G04R0251_n.jpg",@"http://img2.ixingmei.com/uploads/140320/3-14032009592K10_n.jpg",@"http://img2.ixingmei.com/uploads/140430/3-140430144Q01L_n.jpg",@"http://img2.ixingmei.com/uploads/140708/2-140FQ40101405_n.jpg",@"http://img2.ixingmei.com/uploads/allimg/131217/3-13121G116360-L_n.jpg", nil];
    
    self.filmSelectView = [[YXFilmSelectView alloc] initViewWithImageArray:self.imageNames];
    self.filmSelectView.frame = CGRectMake(0, 64, self.view.frame.size.width, 128);
    self.filmSelectView.delegate = self;
    self.filmSelectView.isClick = 2;
    [self.view addSubview:self.filmSelectView];
    
}

#pragma mark -- 处理事件，将选择电影tag返回vc
- (void)itemSelected:(NSInteger)index {
    //中间选中的图片作为模糊背景
    
//    [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:self.imageNames[index]] placeholderImage:nil];
    UIImageView *blurImageView = [[UIImageView alloc] init];
    SDWebImageDownloader *downLoader = [SDWebImageDownloader sharedDownloader];
    [downLoader downloadImageWithURL:[NSURL URLWithString:self.imageNames[index]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished) {
            [blurImageView setImageToBlur:image blurRadius:20 backImageCompletionBlock:^(UIImage *BlurImage) {
               
                self.bgImgV.image = BlurImage;
            }];
        }
    }];

}

#pragma mark -- 懒加载
-(UIImageView*)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 128)];
        _bgImgV.backgroundColor = [UIColor whiteColor];
        _bgImgV.alpha = 0.5;
    }
    return _bgImgV;
}
//
//-(UIVisualEffectView*)effectView{
//    if (!_effectView) {
//        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        _effectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
//        _effectView.frame = self.view.bounds;
//        _effectView.hidden = NO;
//    }
//    return _effectView;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

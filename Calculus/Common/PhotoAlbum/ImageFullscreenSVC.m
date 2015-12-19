//
//  ImageFullscreenSVC.m
//  Wearable
//
//  Created by tracedeng on 15/3/13.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import "ImageFullscreenSVC.h"

@interface ImageFullscreenSVC  () {
    BOOL _isFirst;
}

@end

@interface ImageFullscreenSVC ()
//@property (weak, nonatomic) IBOutlet UIButton *checkStateButton;
@property (weak, nonatomic) IBOutlet UIScrollView *fullScreenScroller;

@property (nonatomic, assign) CGFloat pageWidth;    //每张图片宽度
@property (nonatomic, assign) CGFloat pageHeight;   //每张图片高度
@property (nonatomic, retain) NSMutableDictionary *photoAlbumImageViews;    //序号为索引
@end

@implementation ImageFullscreenSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = YES;
//    self.pageHeight = self.fullScreenScroller.frame.size.height;
//    self.pageWidth = self.fullScreenScroller.frame.size.width;
//    self.fullScreenScroller.contentSize = CGSizeMake(self.pageWidth * self.totalImageCount, self.pageHeight);
//    self.fullScreenScroller.contentOffset = CGPointZero;
    //self.fullScreenScroller.minimumZoomScale = 0.2;
    //self.fullScreenScroller.maximumZoomScale = 2;
    self.fullScreenScroller.delegate = self;

//    [self.checkStateButton.layer setBorderWidth:0.5];
}

/**
 *  约束在这时候才生效，才能得到正确的尺寸信息
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ((self.pageWidth == 0) || (self.pageHeight == 0)) {
        self.pageHeight = self.fullScreenScroller.frame.size.height;
        self.pageWidth = self.fullScreenScroller.frame.size.width;
        self.fullScreenScroller.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.totalImageCount, self.pageHeight);
    }
    
    if (nil == [self.photoAlbumImageViews objectForKey:[NSNumber numberWithInteger:self.currentImageCount]]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.photoAlbum fetchFullScreenAtIndex:(self.currentImageCount - 1)]];
        imageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * (self.currentImageCount - 1), 0, [UIScreen mainScreen].bounds.size.width, self.pageHeight);
        [self.photoAlbumImageViews setObject:imageView forKey:[NSNumber numberWithInteger:self.currentImageCount]];
        [self.fullScreenScroller addSubview:imageView];
        self.fullScreenScroller.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * (self.currentImageCount - 1), 0);
    }
}

/**
 *  防止导航栏back时coredump，神奇
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.fullScreenScroller.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置title显示的当前图片序号，并在UIScrollerView展示图片
 *
 *  @param currentImageCount <#currentImageCount description#>
 */
- (void)setCurrentImageCount:(NSInteger)currentImageCount {
    
    _currentImageCount = currentImageCount +1;
    NSLog(@"%ld",(long)_currentImageCount);
    
    self.title = [NSString stringWithFormat:@"%ld/%ld", (long)_currentImageCount, (long)self.totalImageCount];
    
    //prepareSegue时布局还未设定，所以在viewWillAppear重新设置一次
    if ((self.view.window) && (nil == [self.photoAlbumImageViews objectForKey:[NSNumber numberWithInteger:_currentImageCount]])) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.photoAlbum fetchFullScreenAtIndex:(_currentImageCount - 1)]];
        imageView.frame = CGRectMake(self.pageWidth * (_currentImageCount - 1), 0, self.pageWidth, self.pageHeight);
        [self.photoAlbumImageViews setObject:imageView forKey:[NSNumber numberWithInteger:_currentImageCount]];
        [self.fullScreenScroller addSubview:imageView];
//        self.fullScreenScroller.contentOffset = CGPointMake(self.pageWidth * (_currentImageCount - 1), 0);
    }
}

/**
 *  设置title显示总共有多少张照片
 *
 *  @param totalImageCount <#totalImageCount description#>
 */
- (void)setTotalImageCount:(NSInteger)totalImageCount {
    _totalImageCount = totalImageCount;
    self.title = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentImageCount, (long)_totalImageCount];
}



- (IBAction)switchCheckState:(UIButton *)sender {
    
}

#pragma mark - UIScrollViewDelegate
/**
 *  滑动页面时展示新图片
 *
 *  @param sender <#sender description#>
 */
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    NSLog(@"%f",sender.contentOffset.x);
    NSInteger page = (sender.contentOffset.x) / [UIScreen mainScreen].bounds.size.width;

    [self setCurrentImageCount:page];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"adc");
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self.photoAlbumImageViews objectForKey:[NSNumber numberWithInteger:_currentImageCount]];
}

@end

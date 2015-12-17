//
//  ImageListCVC.m
//  Wearable
//
//  Created by tracedeng on 15/3/12.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import "ImageListCVC.h"
#import "ImageCheckableCell.h"
#import "PhotoAlbum.h"
//#import "ImageFullscreenSVC.h"

#import "MWPhotoBrowser.h"

@interface ImageListCVC () <MWPhotoBrowserDelegate> {
    NSMutableArray *_imageArrs;
}
@property (nonatomic, retain) PhotoAlbum *photoAlbum;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonDone;

@property (nonatomic, retain) ImageCheckableCell *lastCell;     //单选时要用到上一次选择的照片
- (IBAction)switchCheckState:(UIButton *)sender;
@end

@implementation ImageListCVC

static NSString * const reuseIdentifier = @"ImageListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak ImageListCVC *_my = self;
    self.photoAlbum.afterEnumerateAssets = ^(){
        //遍历照片库完成则重新加载
        [_my.activityIndicator stopAnimating];
        _my.activityIndicator.hidden = YES;
        [_my.collectionView reloadData];
    };
    //开始遍历照片库
    [self.activityIndicator startAnimating];
    [self.photoAlbum enumerateAssets];
    
    self.rightBarButtonDone.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCheckedCount:(NSInteger)checkedCount {
    _checkedCount = checkedCount;
    if (_checkedCount <= self.checkableCount) {
        if (_checkedCount == 0) {
            self.rightBarButtonDone.enabled = NO;
            self.rightBarButtonDone.title = [NSString stringWithFormat:@"完成"];
        }else{
            self.rightBarButtonDone.enabled = YES;
            //单选时，不提示具体数量
            self.rightBarButtonDone.title = self.bMultiChecked ? [NSString stringWithFormat:@"完成(%ld/%ld)", (long)_checkedCount, (long)self.checkableCount] : [NSString stringWithFormat:@"完成"];
        }
    }
}

- (NSMutableArray *)currentCheckedImages {
    if (_currentCheckedImages == nil) {
        _currentCheckedImages = [[NSMutableArray alloc] init];
    }
    return  _currentCheckedImages;
}

- (PhotoAlbum *)photoAlbum {
    if (_photoAlbum == nil) {
        _photoAlbum = [[PhotoAlbum alloc] init];
    }
    return _photoAlbum;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"ShowFullscreen"]) {
//        if([segue.destinationViewController isKindOfClass:[ImageFullscreenSVC class]]) {
//            NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UICollectionViewCell *)sender];
//            ImageFullscreenSVC *fullscreenController = (ImageFullscreenSVC *)segue.destinationViewController;
//            fullscreenController.totalImageCount = [self.photoAlbum.photoAlbumImages count];
//            fullscreenController.currentImageCount = indexPath.row + 1; //row 从0开始
//            fullscreenController.photoAlbum = self.photoAlbum;
//        }
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoAlbum.photoAlbumImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCheckableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.assetImage = [self.photoAlbum fetchThumbnailAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _imageArrs = [NSMutableArray array];
    for (int i=0;i<_photoAlbum.photoAlbumImages.count;i++) {
        NSURL *url = [_photoAlbum fetchUrlScreenAtIndex:i];
        [_imageArrs  addObject:[MWPhoto photoWithURL:url]];
        
    }
    [self showImageWithImageArr:_imageArrs AndIndex:indexPath.row];
}


- (IBAction)switchCheckState:(UIButton *)sender {

    //找到button所在的UICollectionViewCell，恶心
    ImageCheckableCell * cell  = (ImageCheckableCell *)(sender.superview.superview);
    if (self.bMultiChecked && (self.checkedCount >= self.checkableCount) && !cell.bCheckState) {
        return;
    }
    [cell switchCheckState];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSDictionary *imageStat = [self.photoAlbum.photoAlbumImages objectAtIndex:indexPath.row];

    //更新选择图片数据信息
    if (cell.bCheckState) {
        //当前图片变成checked状态
        if (self.bMultiChecked) {
            //多选，将选择的项添加到数组尾部
//            [self.currentCheckedCells insertObject:cell atIndex:self.checkedCount];
            [self.currentCheckedImages insertObject:imageStat atIndex:self.checkedCount];
            self.checkedCount++;
        }else{
            //单选，选中数据只保存在index＝0中
            if (self.lastCell) {
                //将已经选择的取消选择
//                ImageCheckableCell *lastCell = [self.currentCheckedCells objectAtIndex:0];
                [self.lastCell switchCheckState];
            }
//            [self.currentCheckedCells setObject:cell atIndexedSubscript:0];
//            [self.currentCheckedImages insertObject:nil atIndex:0];
            
            [self.currentCheckedImages setObject:imageStat atIndexedSubscript:0];
            self.lastCell = cell;
            self.checkedCount = 1;
        }
    }else{
        //取消选择
        if (self.bMultiChecked) {
            //多选，取消选择一张照片
            [self.currentCheckedImages removeObject:imageStat];
            self.checkedCount--;
        }else{
            //单选，将已选中的取消选择，rightBarButton不可点击
            [self.currentCheckedImages removeAllObjects];
            self.lastCell = nil;
            self.checkedCount = 0;
        }
    }
}

#pragma mark - 图片点击事件回调

- (void)showImageWithImageArr:(NSArray *)imageArr AndIndex:(NSInteger)index {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayNavArrows = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageArrs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _imageArrs.count)
        return [_imageArrs objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _imageArrs.count)
        return [_imageArrs objectAtIndex:index];
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

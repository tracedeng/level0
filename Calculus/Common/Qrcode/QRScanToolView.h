//
//  QRScanToolView.h
//  QRCodeDemo
//
//  Created by tracedeng on 16/1/18.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef enum : NSUInteger {
//    ToolButtonTypeCancle = 100,
//    ToolButtonTypeFlash,
//} ToolButtonType;
//
//@class QRScanToolView;
//@protocol QRScanToolViewDelegate <NSObject>
//
//- (void)scanToolView:(QRScanToolView *)scanToolView btnDidClickWithTag:(ToolButtonType)tag;
//
//@end


@interface QRScanToolView : UIView
//@property (nonatomic, weak) id<QRScanToolViewDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@end

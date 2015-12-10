//
//  MKMapView+MapViewUtil.h
//  Wearable
//
//  Created by tracedeng on 15/10/15.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MapViewUtil)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end

//
//  NWmanager.h
//  FoursquareAroundLocation
//
//  Created by Sergey Dikarev on 2/5/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"
#import <CoreLocation/CoreLocation.h>

@interface NWmanager : NSObject


+(void)poisNearLocation:(CLLocationCoordinate2D)location completionBlock:(WPgetPOIsCompletionBlock)completionBlock;
@end

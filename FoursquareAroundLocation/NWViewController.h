//
//  NWViewController.h
//  FoursquareAroundLocation
//
//  Created by Sergey Dikarev on 2/5/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "IconDownloader.h"
@interface NWViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, IconDownloaderDelegate>

@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableArray *pois;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@end

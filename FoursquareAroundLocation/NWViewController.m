//
//  NWViewController.m
//  FoursquareAroundLocation
//
//  Created by Sergey Dikarev on 2/5/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//


#import "NWViewController.h"
#import "NWItem.h"
#import "IconDownloader.h"
#import "NWmanager.h"
@interface NWViewController ()

@end

@implementation NWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pois = [NSMutableArray new];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];

    _locationManager = [[CLLocationManager alloc] init];
	//_locationManager.distanceFilter = 5;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startIconDownload:(NWItem *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [_imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([_pois count] > 0)
    {
        NSArray *visiblePaths = [self.table indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {

            NWItem *appRecord = [_pois objectAtIndex:indexPath.row];
            
            if (!appRecord.appIcon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }

            
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        
        
        UIView *old = [cell.contentView viewWithTag:101];
        if(old)
        {
            [old removeFromSuperview];
        }
        UIImage* image = iconDownloader.appRecord.appIcon;;
        UIImageView * iv = [[UIImageView alloc] initWithImage:image];
        iv.frame = (CGRect){{10,10},{20,20}};
        iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.tag = 101;
        [cell.contentView addSubview:iv];
        
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [_imageDownloadsInProgress removeObjectForKey:indexPath];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)getLabelSize:(NSString *)text fontSize:(NSInteger)fontSize
{
    UIFont *cellFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
	CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
	CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.pois.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(_pois.count > 0)
    {
        NWItem *item = [_pois objectAtIndex:indexPath.row];
        
        
        return [self getLabelSize:item.itemName fontSize:16] + 20;
    }
   
    return 40;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    if(_pois.count > 0)
    {
        NWItem *item = [_pois objectAtIndex:indexPath.row];
        
        
        UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 280, [self getLabelSize:item.itemName fontSize:16])];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.text = item.itemName;
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        lblTitle.numberOfLines = 0;
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        
        [cell.contentView addSubview:lblTitle];
        
        
        if (!item.appIcon)
        {
            if (self.table.dragging == NO && self.table.decelerating == NO)
            {
                [self startIconDownload:item forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            UIImage* image = [UIImage imageNamed:@"Placeholder.png"];
            UIImageView * iv = [[UIImageView alloc] initWithImage:image];
            iv.frame = (CGRect){{10,10},{20,20}};
            iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv.tag = 101;
            [cell.contentView addSubview:iv];
        }
        else
        {
            UIView *old = [cell.contentView viewWithTag:101];
            if(old)
            {
                [old removeFromSuperview];
            }
            UIImage* image = item.appIcon;
            UIImageView * iv = [[UIImageView alloc] initWithImage:image];
            iv.frame = (CGRect){{10,10},{20,20}};
            iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv.tag = indexPath.row;
            [cell.contentView addSubview:iv];
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NWItem *item = [_pois objectAtIndex:indexPath.row];
    
    [NWmanager poisNearLocation:CLLocationCoordinate2DMake(item.itemLat, item.itemLng) completionBlock:^(NSArray *result, NSError *error) {
        if(!error)
        {
            
            NSLog(@"poisNearLocation");
            
            if(_pois)
               [_pois removeAllObjects];
            _pois = [NSMutableArray arrayWithArray:result];
            
            [self.table reloadData];
            
            [self loadImagesForOnscreenRows];
        }
    }];
}


#pragma mark - Location delegates

-(void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"Location updated to = %@",newLocation);
    
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    //NSLog(@"time: %f", locationAge);
    
    if (newLocation.horizontalAccuracy < 0) return;
    
	// Needed to filter cached and too old locations
    //NSLog(@"Location updated to = %@", newLocation);
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    double distance = [loc1 distanceFromLocation:loc2];
    _currentLocation = newLocation;

    if(distance > 10)
    {
        NSLog(@"SIGNIFICANTSHIFT");
        [_locationManager stopUpdatingLocation];
        
        [NWmanager poisNearLocation:_currentLocation.coordinate completionBlock:^(NSArray *result, NSError *error) {
            if(!error)
            {
                
                NSLog(@"poisNearLocation");
                if(_pois)
                    [_pois removeAllObjects];
                
                _pois = [NSMutableArray arrayWithArray:result];
                
                [self.table reloadData];
                
                [self loadImagesForOnscreenRows];
            }
        }];
    }
    
    
    
    
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}




@end

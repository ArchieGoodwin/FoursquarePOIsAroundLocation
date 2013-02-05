//
//  NWmanager.m
//  FoursquareAroundLocation
//
//  Created by Sergey Dikarev on 2/5/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWmanager.h"
#import "URLConnection.h"
#import <CoreLocation/CoreLocation.h>
#import "NWItem.h"
#import "Defines.h"



@implementation NWmanager





+(void)poisNearLocation:(CLLocationCoordinate2D)location completionBlock:(WPgetPOIsCompletionBlock)completionBlock
{
    
    WPgetPOIsCompletionBlock completeBlock = [completionBlock copy];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMdd"];
	NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *loc = [NSString stringWithFormat:@"%.10f,%.10f", location.latitude, location.longitude];
    
    
    NSString *connectionString = [NSString stringWithFormat:@"%@ll=%@&client_id=%@&client_secret=%@&v=%@&limit=%@&radius=%@", PATH_TO_4SERVER, loc, CLIENT_ID, CLIENT_SECRET, dateString, LIMIT, RADIUS];
    NSLog(@"connect to: %@",connectionString);
    
    [URLConnection asyncConnectionWithURLString:connectionString
                                completionBlock:^(NSData *data, NSURLResponse *response) {
                                    NSLog(@"Data length %d", [data length]);
                                    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                    NSLog(@"%@", json);
                                    NSMutableArray *pois = [[NSMutableArray alloc] init];
                                    
                                    //if([[json objectForKey:@"numResults"] integerValue] > 0)
                                    //{
                                    NSMutableArray *items = [[[[json objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
                                    for (NSMutableDictionary *dict in items) {
                                        NWItem *item = [[NWItem alloc] initWithDictionary:[dict objectForKey:@"venue"]];
                                        [pois addObject:item];
                                    }
                                    
                                    if(pois.count > 0)
                                    {
                                        
                                        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemDistance" ascending:YES];
                                        if(completeBlock)
                                        {
                                            completeBlock([pois sortedArrayUsingDescriptors:[NSMutableArray arrayWithObjects:sortDescriptor, nil]], nil);
                                            
                                        }
                                    }
                                    else
                                    {
                                        completeBlock(pois, nil);
                                    }
                                    
                                    
                                }
                                     errorBlock:^(NSError *error) {
                                         
                                         NSMutableDictionary* details = [NSMutableDictionary dictionary];
                                         [details setValue:[error description] forKey:NSLocalizedDescriptionKey];
                                         // populate the error object with the details
                                         NSError *err = [NSError errorWithDomain:@"world" code:200 userInfo:details];
                                         
                                         completeBlock(nil, err);
                                         
                                     }];
}


@end

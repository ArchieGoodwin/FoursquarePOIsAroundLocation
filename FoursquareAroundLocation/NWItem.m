//
//  WPItem.m
//  WP4square
//
//  Created by Sergey Dikarev on 8/17/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import "NWItem.h"

@implementation NWItem
@synthesize itemDistance, itemId, itemName, itemLat, itemLng, iconUrl, appIcon;

-(NWItem *)initWithDictionary:(NSMutableDictionary *)dict
{

        if(dict != nil)
        {
            
            @try {
                self.itemName = [dict  objectForKey:@"name"];
                self.itemId = [dict objectForKey:@"id"];
                NSString *url = [[[[dict objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"prefix"];
                NSString *ext = [[[[dict objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"suffix"];
                NSString *fullUrl = [NSString stringWithFormat:@"%@%@", [url substringToIndex:[url length]-1], ext];
                self.itemDistance = [[[dict objectForKey:@"location"] objectForKey:@"distance"] integerValue];
                self.iconUrl = fullUrl;
                self.itemLat = [[[dict objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                self.itemLng = [[[dict objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                
                return self;
            }
            @catch (NSException *exception) {
                NSLog(@"Error while creating NWItem %@", exception.description);
                return nil;
            }
            @finally {
                
            }
            
            
            
        }

    
    return nil;
}




@end

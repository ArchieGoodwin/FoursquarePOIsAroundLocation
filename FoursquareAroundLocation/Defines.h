#define CLIENT_ID @""
#define CLIENT_SECRET @""
#define PATH_TO_4SERVER @"https://api.foursquare.com/v2/venues/explore?"
#define LIMIT @"50"
#define RADIUS @"1000"
typedef void (^WPgetPOIsCompletionBlock)        (NSArray *result, NSError *error);
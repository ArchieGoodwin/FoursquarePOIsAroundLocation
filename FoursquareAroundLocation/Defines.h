#define CLIENT_ID @"4AI4XUE0BZQ2G1PFEIUITRMTNHQ45I353UMKWF30TPNLAVLK"
#define CLIENT_SECRET @"XJEEEUDB25ATGNQFHN04AGWTCTN0INXEXLBJOMOU25BRM20I"
#define PATH_TO_4SERVER @"https://api.foursquare.com/v2/venues/explore?"
#define LIMIT @"50"
#define RADIUS @"1000"
typedef void (^WPgetPOIsCompletionBlock)        (NSArray *result, NSError *error);
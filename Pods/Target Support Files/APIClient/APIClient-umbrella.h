#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "APIClient.h"
#import "APIClientConfiguration.h"
#import "APIHTTPClient.h"
#import "APIInflector.h"
#import "APIJSONSerializer.h"
#import "APIMapper.h"
#import "APIMappingProvider.h"
#import "APIResourceNamer.h"
#import "APIResponse.h"
#import "APIRouter.h"

FOUNDATION_EXPORT double APIClientVersionNumber;
FOUNDATION_EXPORT const unsigned char APIClientVersionString[];


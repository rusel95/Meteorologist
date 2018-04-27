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

#import "DCArrayMapping.h"
#import "DCAttributeSetter.h"
#import "DCCustomInitialize.h"
#import "DCCustomParser.h"
#import "DCDictionaryRearranger.h"
#import "DCDynamicAttribute.h"
#import "DCGenericConverter.h"
#import "DCKeyValueObjectMapping.h"
#import "DCMapping.h"
#import "DCNSArrayConverter.h"
#import "DCNSDateConverter.h"
#import "DCNSSetConverter.h"
#import "DCNSURLConverter.h"
#import "DCObjectMapping.h"
#import "DCParserConfiguration.h"
#import "DCPropertyAggregator.h"
#import "DCPropertyFinder.h"
#import "DCReferenceKeyParser.h"
#import "DCSimpleConverter.h"
#import "DCValueConverter.h"
#import "NSObject+DCKeyValueObjectMapping.h"

FOUNDATION_EXPORT double DCKeyValueObjectMappingVersionNumber;
FOUNDATION_EXPORT const unsigned char DCKeyValueObjectMappingVersionString[];


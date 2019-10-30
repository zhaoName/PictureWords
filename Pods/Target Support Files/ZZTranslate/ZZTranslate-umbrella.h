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

#import "PPHistoryTableViewController.h"
#import "CALayer+PPAnimation.h"
#import "LTPListenModel.h"
#import "LTPListenViewController.h"
#import "LTPMusicViewController.h"
#import "LTPPlayMusicHandle.h"
#import "PLTPPlayListenView.h"
#import "PPListenTableViewCell.h"
#import "PPTransDetailModel.h"
#import "PPTransDetailTableViewCell.h"
#import "PPTransDetailView.h"
#import "PPTransDetailViewController.h"
#import "PPTipsTableViewCell.h"
#import "PPTranslateTableViewCell.h"
#import "PPTranslateViewController.h"
#import "ZZTranslateTarget.h"

FOUNDATION_EXPORT double ZZTranslateVersionNumber;
FOUNDATION_EXPORT const unsigned char ZZTranslateVersionString[];


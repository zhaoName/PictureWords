//
//  PPTransDetailModel.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPTransDetailModel.h"
#import <MJExtension.h>

@implementation PPBasicModel

@end

@implementation PPTransDetailModel

- (PPBasicModel *)basic
{
    return [PPBasicModel mj_objectWithKeyValues:_basic];
}

@end

//
//  PPTransDetailModel.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBasicModel : NSObject

@property (nonatomic, strong) NSArray *explains;/**< */

@end

@interface PPTransDetailModel : NSObject

@property (nonatomic, copy) NSString *errorCode;/**< */
@property (nonatomic, copy) NSString *query;/**< 源语言*/
@property (nonatomic, copy) NSString *speakUrl;/**< 源语言发音地址*/
@property (nonatomic, copy) NSArray *translation;/**< */
@property (nonatomic, copy) NSString *tSpeakUrl;/**< 翻译结果发音地址*/

@property (nonatomic, strong) PPBasicModel *basic;/**< 基本词典,查词时才有*/

@end
NS_ASSUME_NONNULL_END

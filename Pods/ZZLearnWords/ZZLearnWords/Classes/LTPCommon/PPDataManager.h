//
//  PPDataManager.h
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface DataModel : NSObject
@property (nonatomic,copy) NSString *keywordEnglish ;
@property (nonatomic,copy) NSString *keywordChina ;
@property (nonatomic,copy) NSString *contentEnglish ;
@property (nonatomic,copy) NSString *contentChina ;
@property (nonatomic,copy) NSString *keywordStyle ;
@property (nonatomic,copy) NSString *keywordImageName ;
+ (DataModel *)modelWithDictionary:(NSDictionary *)dictionary ;
- (NSDictionary *)dictionaryWithModel:(DataModel *)model ;
@end


@class LTPLearnWordModel;
@interface PPDataManager : NSObject

+ (PPDataManager *)shareManager ;
@property (nonatomic,strong,readonly) NSArray *datasource ;
@property (nonatomic,strong,readonly) NSArray *suoyoudaanArr ;

/// add collection data
- (BOOL)ltp_addCollectionModel:(LTPLearnWordModel *)model;
/// remove collectioned data
- (BOOL)ltp_removeCollectionModel:(LTPLearnWordModel *)model;
/// collection or not
- (BOOL)ltp_isContainedModel:(LTPLearnWordModel *)model;

- (NSMutableDictionary *)ltp_allCollectionData;

@end

NS_ASSUME_NONNULL_END

//
//  PPTransDetailTableViewCell.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPTransDetailTableViewCell.h"
#import "PPTransDetailModel.h"

@interface PPTransDetailTableViewCell ()

@property (nonatomic, strong) PPTransDetailModel *model;/**< */

@end

@implementation PPTransDetailTableViewCell

- (void)ltp_showETFanTableViewCell:(PPTransDetailModel *)model
{
    self.model = model;
    self.fanLabel.text = model.query;
    if (model.translation.count != 0) {
        self.yiLabel.text = model.translation[0];
    }
}

- (IBAction)touchSoundBtn:(UIButton *)sender
{
    //[[ETMusicManager shareMusicTool] playerMusicWithName:@"fan" url:self.model.speakUrl];
}

- (IBAction)touchYiBtn:(id)sender
{
    //[[ETMusicManager shareMusicTool] playerMusicWithName:@"yi" url:self.model.tSpeakUrl];
}

- (IBAction)touchCloseBtn:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTouchColseBtn" object:nil];
}

@end

//
//  LTPReviewViewController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "LTPReviewViewController.h"
#import "LTPCollectionViewCell.h"
#import "LTPLearnWordModel.h"
#import "MJExtension.h"
#import "PPDataManager.h"

@interface LTPReviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *keywordShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightIimage;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *clickButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *isSelecteds;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *xuanxianglabels;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (nonatomic,strong) NSArray *datasource;
@property (nonatomic,strong) NSMutableArray *currentDaanArr ;
@property (nonatomic,strong) NSMutableArray *successDaanArr ;
@property (nonatomic,strong) NSMutableArray *makeResultTimuArr ;
@property (nonatomic,assign) NSInteger currentTimuIndex ;
@property (nonatomic,assign) __block BOOL noTip ;
@property (nonatomic,strong) UIView *resultView ;

@end

@implementation LTPReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xefefef"];
    self.navigationItem.title = @"测试";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ZZLearnWords" ofType:@"bundle"];
    path = [path stringByAppendingPathComponent:@"EnglishData.plist"];
    self.datasource = [[LTPLearnWordModel mj_objectArrayWithFile:path][self.showReviewIndex] mutableCopy];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(ltp_clickCommitItem)];
    
    self.noTip = NO;
    self.currentTimuIndex = 0;
    [self ltp_configDefaultData];
    [self ltp_setupTextContent];
}


- (void)ltp_configDefaultData
{
    self.datasource = [self gibberishArray:self.datasource];
    self.successDaanArr = [NSMutableArray array];
    [self.datasource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj ;
        NSString *name = [dic valueForKey:@"ch_name"];
        [self.successDaanArr addObject:name];
    }];
    self.makeResultTimuArr = [NSMutableArray array];
    NSMutableArray *daanItemArr = [NSMutableArray array];
    NSMutableArray *allHistoryDaanNameArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.successDaanArr.count; i++)
    {
        NSString *name = [self.successDaanArr objectAtIndex:i];
        NSInteger flag = 0 ;
        while (YES) {
            NSString *daan1 = [[PPDataManager shareManager].suoyoudaanArr objectAtIndex:flag];
            if (![allHistoryDaanNameArr containsObject:daan1]) {
                [allHistoryDaanNameArr addObject:daan1];
                [daanItemArr addObject:daan1];
                if (daanItemArr.count == 3) {
                    [daanItemArr addObject:name];
                    NSArray *newItemArr = [daanItemArr copy];
                    [self.makeResultTimuArr addObject: [self gibberishArray:newItemArr]];
                    [daanItemArr removeAllObjects];
                    break ;
                }
            }
            flag++;
        }
    }
}

//将一个数组元素顺序打乱
- (NSMutableArray *)gibberishArray:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray  arrayWithCapacity:array.count];
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:array];
    int count = (int)array.count;
    int randCount = 0;//索引
    int nowCount = 0;//当前数组的元素个数
    
    for (;count != 0; ) {
        nowCount = (int)tempArr.count;//当前数组的元素个数
        count = nowCount;
        if (nowCount != 0) {
            randCount = (arc4random() % nowCount);
            [arr addObject:tempArr[randCount]];
            tempArr[randCount] = tempArr.lastObject;
            [tempArr removeLastObject];
        }
    }
    return arr;
}

- (void)ltp_setupTextContent
{
    NSDictionary *dic = [self.datasource objectAtIndex:self.currentTimuIndex];
    DataModel *model = [DataModel modelWithDictionary:dic];
    
    self.imageview.hidden = YES ;
    self.heightIimage.constant = 67 ;
    
    self.keywordShow.text = model.keywordEnglish;
    UIImage *helpImage = [[ZZMediator defaultZZMediator] cat_imageWithName:[NSString stringWithFormat:@"%@.png", model.keywordImageName] atClass:UIImage.class bundleName:@"ZZLearnWords"];
    self.imageview.image = helpImage;
    NSArray *timuArr = [self.makeResultTimuArr objectAtIndex:self.currentTimuIndex];
    [self.xuanxianglabels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel *)obj;
        label.text = [timuArr objectAtIndex:idx];
    }];
    [self.isSelecteds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *label = (UIButton *)obj;
        label.selected = NO ;
    }];
}

- (IBAction)xiayiti:(id)sender
{
    if (self.noTip) {
        [self nextAction];
    }
    else {
        __weak typeof(self)weakSelf = self ;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击下一个问题后，您的答案无法修改，是否继续答题？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"下一题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf nextAction];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"我知道了,下一题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.noTip = YES ;
            [weakSelf nextAction];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)nextAction
{
    if (self.currentDaanArr.count-1 != self.currentTimuIndex) {//没做题，点击了下一
        [self.currentDaanArr addObject:@"no finish"];
    }
    if (self.currentTimuIndex >= self.datasource.count - 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜!" message:@"您已完成测试，请单击右上角的按钮提交答案并查看结果。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return ;
    }
    self.currentTimuIndex++;
    
    [self ltp_setupTextContent];
}

- (IBAction)help:(id)sender {
    self.heightIimage.constant = 134 ;
    self.imageview.hidden = NO ;
}

- (IBAction)clickxuanxiang:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ([self.clickButtons containsObject:btn])
    {
        NSInteger index = [self.clickButtons indexOfObject:btn];
        NSArray *itemArr = [self.makeResultTimuArr objectAtIndex:self.currentTimuIndex];
        NSString *curreentdaan = [itemArr objectAtIndex:index];
        [self.currentDaanArr addObject:curreentdaan];
        [self.isSelecteds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *label = (UIButton *)obj;
            if (idx == index) {
                label.selected = YES ;
            }else
            {
                label.selected = NO ;
            }
        }];
    }
}

- (void)ltp_clickCommitItem
{
    if (self.currentTimuIndex < self.datasource.count - 1) {
        __weak typeof(self)weakSelf = self ;
        NSString *message = [NSString stringWithFormat:@"总共%zd道题,您已完成%zd道题,确定要提交吗？",self.datasource.count, self.currentTimuIndex];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [weakSelf ltp_showResultview];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [self ltp_showResultview];
    }
}


- (void)ltp_showResultview
{
    __block NSInteger noFinishCount = 0 ;
    __block NSInteger successCount = 0 ;
    __block NSInteger failCount = 0 ;
    
    if (self.currentDaanArr.count < self.successDaanArr.count) {
        noFinishCount = self.successDaanArr.count - self.currentDaanArr.count ;
    }
    [self.successDaanArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *success = (NSString *)obj ;
        if ((idx > self.currentDaanArr.count-1) || self.currentDaanArr.count == 0) {
            *stop = YES ;
        }else
        {
            
            NSString *currentDaan = [self.currentDaanArr objectAtIndex:idx];
            if ([currentDaan isEqualToString:@"no finish"]) {
                noFinishCount ++ ;
            }else
            {
                if ([success isEqualToString:currentDaan]) {
                    successCount++;
                }else {
                    failCount++;
                }
            }
        }
    }];
    NSString *key = [NSString stringWithFormat:@"第 %zd 天测试结果", self.showReviewIndex+1];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:key forKey:@"name"];
    [dictionary setValue:[NSNumber numberWithInteger:successCount] forKey:@"successCount"];
    [dictionary setValue:[NSNumber numberWithInteger:failCount] forKey:@"failCount"];
    [dictionary setValue:[NSNumber numberWithInteger:noFinishCount] forKey:@"noFinishCount"];
    NSDictionary *allDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"我的错误"];
    
    if (allDic == nil||allDic.count == 0) {
        NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
        [dicM setValue:dictionary forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:dicM forKey:@"我的错误"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:allDic];
        [dicM setValue:dictionary forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:dicM forKey:@"我的错误"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"success--%zd\nfail--%zd,nofinish--%zd",successCount,failCount,noFinishCount);
    LTPCollectionViewCell *cell = [self.resultView viewWithTag:888];
    cell.nameLabel.text = key;
    cell.fenshuLabel.text = [NSString stringWithFormat:@"分数：%.1f",(float)(100.0 / (float)self.successDaanArr.count) * successCount];
    cell.zhengqueLabel.text = [NSString stringWithFormat:@"正确：%zd",successCount];
    cell.shibaiLabel.text = [NSString stringWithFormat:@"错误：%zd",failCount];
    cell.nofinishLabel.text = [NSString stringWithFormat:@"未完成：%zd",noFinishCount];
    self.resultView.hidden = NO;
    [self.navigationController.navigationBar setHidden:YES];
}

- (UIView *)resultView
{
    if (_resultView == nil) {
        _resultView = [[UIView alloc] initWithFrame:self.view.bounds];
        _resultView.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0x000000"];
        [self.view addSubview:_resultView];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ZZLearnWords" ofType:@"bundle"];
        LTPCollectionViewCell *cell = [[[NSBundle bundleWithPath:path] loadNibNamed:NSStringFromClass([LTPCollectionViewCell class]) owner:nil options:nil] lastObject];
        [_resultView addSubview:cell];
        cell.tag = 888 ;
        CGFloat w = CGRectGetWidth(_resultView.frame) * 314.0/375.0 * 0.8;
        CGFloat h = w * 416.0/314.0 ;
        CGFloat x = (CGRectGetWidth(_resultView.frame) - w) * 0.5 ;
        CGFloat y = (CGRectGetHeight(_resultView.frame) - h) * 0.5 ;
        cell.frame = CGRectMake(x, y, w, h);
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resultView addSubview:closeButton];
        [closeButton addTarget:self action:@selector(closeResultView) forControlEvents:UIControlEventTouchUpInside];
        UIImage *guanbiImage = [[ZZMediator defaultZZMediator] cat_imageWithName:@"guanbi" atClass:UIImage.class bundleName:@"ZZLearnWords"];
        [closeButton setImage:guanbiImage forState:UIControlStateNormal];
        [closeButton setImage:guanbiImage forState:UIControlStateSelected];
        [closeButton setImage:guanbiImage forState:UIControlStateHighlighted];
        [closeButton setImage:guanbiImage forState:UIControlStateDisabled];
        w = h = 40;
        y = CGRectGetMaxY(cell.frame) + 10;
        x = (CGRectGetWidth(_resultView.frame) - w) * 0.5 ;
        closeButton.frame = CGRectMake(x, y, w, h);
        _resultView.hidden = YES ;
    }
    return _resultView ;
}

- (void)closeResultView
{
    self.resultView.hidden = YES;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)currentDaanArr
{
    if (_currentDaanArr == nil) {
        _currentDaanArr = [NSMutableArray array];
    }
    return _currentDaanArr ;
}
@end

//
//  IMStrandsViewController.m
//  Ads Demo
//
//  Copyright © 2016 Inmobi. All rights reserved.
//

#define INMOBI_NATIVE_STRANDS   1466905009032

#import "IMStrandsViewController.h"
#import "IMNativeStrands.h"
#import "IMSimpleTableCell.h"
#import <MediaPlayer/MediaPlayer.h>  
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioSession.h>

#define kIMAdInsertionPosition 0
#define TableViewHegit self.view.frame.size.height*0.5922
@interface IMStrandsViewController() <IMNativeStrandsDelegate,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>
@property (nonatomic,strong) IMNativeStrands *nativeStrands;
@property (nonatomic) BOOL nativeStrandsLoaded,nativeStrandsRendered,nativeStrandsInserted;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *soundPlayView;
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) AVAudioPlayer* musicPlayer;
@property (nonatomic,assign) CGRect tableViewRect;
@property (nonatomic,assign) CGRect soundViewRect;
@property (nonatomic,strong) UISlider * slider;
@end
@implementation IMStrandsViewController
@synthesize customTitle;
@synthesize musicName;
@synthesize customKey;
/*
 *此内容从1.1.7版本开始废弃
 */
- (void)viewDidLoad {
    NSLog(@"IMStrandsViewController  ->%@,,,,,%@......%@",musicName,customTitle,customKey);
    self.tableData = [[NSMutableArray alloc] init];

    NSString* soundBG = @"playSoundBG";
    
    if ([customKey isEqual:@"fajr"] || [customKey isEqual:@"sunrise"] )
    {
        soundBG = @"fairPlaySoundBG";
    }
    else if ([customKey isEqual:@"dhuhr"])
    {
        soundBG = @"dhuhrPlaySoundBG";
    }
    else if ([customKey isEqual:@"ishaa"])
    {
        soundBG = @"ishaaPlaySoundBG";
    }
    
    UIImageView *soundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:soundBG]];
    soundImageView.frame = self.view.frame;
    [self.view addSubview:soundImageView];
    
    self.view.alpha = 0.0;
    
    [self.navigationController.navigationBar setHidden:YES];
    
    self.nativeStrands = [[IMNativeStrands alloc] initWithPlacementId:INMOBI_NATIVE_STRANDS];
    self.nativeStrands.delegate = self;
//    [self.nativeStrands load];
    
//    NSString* str = @"正在播放：";
//    customTitle=[str stringByAppendingString:customTitle];
    self.title = customTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableViewRect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, TableViewHegit+64);
    _soundViewRect = CGRectMake(self.view.frame.origin.x, TableViewHegit+64, self.view.frame.size.width, self.view.frame.size.height-TableViewHegit-64);
    
    self.tableView = [[UITableView alloc] initWithFrame:_tableViewRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    [self.tableView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:nil];
    
    self.tableView.hidden = YES;
    
    
    self.soundPlayView = [[UIView alloc] initWithFrame:_soundViewRect];
    self.soundPlayView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    [self.view addSubview:self.soundPlayView];
    
    
    NSString* imgaeName = @"Img_Sound";
    CGFloat soundViewHeight = self.view.frame.size.height-TableViewHegit-64;
    CGFloat offestY = soundViewHeight/4 - 25;
    CGRect soundImageRect;
    CGRect sliderRect;
    if([[[NSLocale preferredLanguages] firstObject] containsString:@"ar"])
    {
        soundImageRect = CGRectMake(self.view.frame.size.width-60, offestY, 30, 30);
        sliderRect = CGRectMake(30, offestY-10, self.view.frame.size.width-60-35, 50);
        imgaeName = @"Img_Sound_ar";
    }
    else
    {
        soundImageRect = CGRectMake(30, offestY, 30, 30);
        sliderRect = CGRectMake(30 + 35, offestY-10, self.view.frame.size.width-60-35, 50);
    }
    
//    UIImageView *soundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgaeName]];
//    soundImageView.frame = soundImageRect;
//    [self.soundPlayView addSubview:soundImageView];
    
    _slider = [[UISlider alloc]initWithFrame:sliderRect];
    [_slider addTarget:self action:@selector(touchSlide:) forControlEvents:UIControlEventValueChanged];
    [_slider setMinimumTrackTintColor:[UIColor blackColor]];
    [_slider setValue:[self returnSystemVolum]];
    [self.soundPlayView addSubview:_slider];
    
    UIButton *stopMusicBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-50)/2, soundViewHeight/2-25, 50, 50)];
    [stopMusicBtn setImage:[UIImage imageNamed:@"stopMusic"] forState:UIControlStateNormal];
    [stopMusicBtn addTarget:self action:@selector(musicStopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.soundPlayView addSubview:stopMusicBtn];
    
    UILabel *stopLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, soundViewHeight/2 -25 + 50 + 2, 100, 20)];
    stopLabel.text = [self DPLocalizedString:@"key_stopAthan"]; //DPLocalizedString(@"key_stopAthan");
    stopLabel.font = [UIFont systemFontOfSize:16];
    stopLabel.textAlignment = NSTextAlignmentCenter;
    [self.soundPlayView addSubview:stopLabel];
    
    self.soundPlayView.hidden = YES;
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
//    self.navigationItem.rightBarButtonItem = backBtn;
    
    NSString *musicSwitchKey = [NSString stringWithFormat:@"%@sound_switch",customKey];
    
    BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:musicSwitchKey];
    if (isOpen) {
        [self playSound];
    }
    
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adBG2"]];
////    imageView.frame = self.view.frame;
//    
//    [imageView setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, self.view.frame.size.width, imageView.frame.size.height)];
//    [self.soundPlayView insertSubview:imageView atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                            selector:@selector(volumeChanged:)
     
                                                name:@"AVSystemController_SystemVolumeDidChangeNotification"
     
                                              object:nil];
    
//    let alertController = UIAlertController(title: ChapelToolUtils.getLocalizedStr("key_AthanAlarm"), message: message1, preferredStyle: UIAlertControllerStyle.Alert)
//    let cancelAction = UIAlertAction(title: ChapelToolUtils.getLocalizedStr("key_stopAthan"), style: .Cancel) { (alertAction: UIAlertAction)->() in
//        print("TODO")
//        self.audioPlayer.stop()
//    }
//    alertController.addAction(cancelAction)
    
    
}

-(void)stopMusic
{
    [_musicPlayer stop];
}

-(void)musicStopBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:true completion:^{
        [_musicPlayer stop];
    }];
}

#define CURR_LANG   ([[NSLocale preferredLanguages] objectAtIndex:0])
- (NSString *)DPLocalizedString:(NSString *)translation_key {
    NSString * s = NSLocalizedStringFromTable(translation_key, @"MyPrayLocalized", nil);
    NSString * cur_Lan = [CURR_LANG substringWithRange:NSMakeRange(0,2)];

    if (![cur_Lan isEqual:@"en"] && ![cur_Lan isEqual:@"zh"] && ![cur_Lan isEqual:@"ar"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:@"MyPrayLocalized"];
    }

    return s;
}

- (BOOL)isMuted
{
    CFStringRef route;
    UInt32 routeSize = sizeof(CFStringRef);
    
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &routeSize, &route);
    if (status == kAudioSessionNoError)
    {
        NSLog(@"判断静音%d---%d",route == NULL,!CFStringGetLength(route));
        if (route == NULL || !CFStringGetLength(route))
        {
            NSLog(@"真的静音！！！！！！！");
            return TRUE;
        }
    }
    NSLog(@"没有静音！！！！！！！");
    return FALSE;
}
-(void)playSound {
    NSArray *str = [musicName componentsSeparatedByString:@"."];
    _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:str[0] ofType:str[1]]] error:nil];//使用本地URL创建
    if([self isMuted])
        _musicPlayer.volume = 0.0;
    else
    {
        _musicPlayer.volume = [self returnSystemVolum];
    }
    [_musicPlayer play];
}

-(float)returnSystemVolum
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    volumeView.hidden = YES;
    float systemVolume = [[AVAudioSession sharedInstance] outputVolume];
    if(systemVolume > 50)
    {
        systemVolume = systemVolume - 10;
    }
    return systemVolume;
}

-(void)touchSlide:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSLog(@"%f",slider.value);
    if([self isMuted] == NO)
    {
        MPMusicPlayerController *mp=[MPMusicPlayerController applicationMusicPlayer];
        [mp setVolume:slider.value];
    }
}

-(void)volumeChanged:(NSNotification *)notification {
    [_slider setValue:[[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdAtIndexPath:indexPath]) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"adIdentifier"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adIdentifier"];
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        IMNativeStrands *strands = [self.tableData objectAtIndex:indexPath.row];
        [[strands strandsView] setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:[strands strandsView]];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else {
        IMSimpleTableCell *cell = (IMSimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdAtIndexPath:indexPath]) {
        NSLog(@"heightForRowAtIndexPath-----%f,,,,%f",[self.nativeStrands strandsViewSize].height,self.view.frame.size.height);
        return [self.nativeStrands strandsViewSize].height;
    }
    CGFloat height= 428;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        height = 502;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] == NSNotFound && [self isAdAtIndexPath:indexPath]) {
        [self.nativeStrands recycleView];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [_musicPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //播放结束时执行的动作
    NSLog(@"播放结束！！！！！");
}

#pragma mark - Internal Methods
- (void)loadInitialData {

}

- (BOOL)isAdAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.tableData objectAtIndex:indexPath.row] isKindOfClass:[IMNativeStrands class]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:_tableView] && [keyPath isEqualToString:@"contentOffset"]) {
        [self updateTableData];
    }
}

- (void)updateTableData {
    if (!self.nativeStrandsLoaded || self.nativeStrandsInserted) {
        return;
    }
    NSArray *visibleArray = self.tableView.indexPathsForVisibleRows;
    NSIndexPath *lastVisibleCell = visibleArray.lastObject;
//    if (kIMAdInsertionPosition > lastVisibleCell.row) {
        self.nativeStrandsInserted = YES;
        [self.tableData insertObject:self.nativeStrands atIndex:kIMAdInsertionPosition];
        [self.tableView reloadData];
//    }
//    self.tableView.hidden = NO;
}

- (void)nativeStrands:(IMNativeStrands *)nativeStrands didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"Error : %@",error.description);
}
- (void)nativeStrandsAdClicked:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands Ad Clicked");
}
- (void)nativeStrandsAdImpressed:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands Ad Impression tracked");
}
- (void)nativeStrandsDidDismissScreen:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands will dismiss screen");
}
- (void)nativeStrandsDidFinishLoading:(IMNativeStrands *)nativeStrands {
    self.nativeStrandsLoaded = YES;
    [self updateTableData];
    NSLog(@"Native Strands did finish load");
}
- (void)nativeStrandsDidPresentScreen:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands did present screen");
}
- (void)nativeStrandsWillDismissScreen:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands will dismiss screen");
}
- (void)nativeStrandsWillPresentScreen:(IMNativeStrands *)nativeStrands {
    NSLog(@"Native Strands will present screen");
}
- (void)userWillLeaveApplicationFromNativeStrands:(IMNativeStrands *)nativeStrands {
    NSLog(@"user will leave application from native strands");
}
- (void)dealloc {
    self.nativeStrands.delegate = nil;
    [self.tableView removeObserver:self
                    forKeyPath:@"contentOffset"
                       context:nil];
}
@end

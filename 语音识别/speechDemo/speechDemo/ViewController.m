//
//  ViewController.m
//  speechDemo
//
//  Created by primb_xuyanhao on 2018/12/17.
//  Copyright © 2018 Primb. All rights reserved.
//

#import "ViewController.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+Toast.h"

@interface ViewController ()<AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) UITextField *textfiled;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *strCutBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;

@property (nonatomic, strong) AVSpeechSynthesizer *voiceSpeech;

@end

@implementation ViewController

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.view.frame];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled = YES;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initBasicUI];
    // 请求权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        NSLog(@"status %@", status == SFSpeechRecognizerAuthorizationStatusAuthorized ? @"授权成功" : @"授权失败");
    }];
}
- (void)initBasicUI{
    NSArray *imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"huoying1.jpg"],[UIImage imageNamed:@"huoying2.jpg"],[UIImage imageNamed:@"huoying3.jpg"],[UIImage imageNamed:@"huoying4.jpg"],[UIImage imageNamed:@"huoying5.jpg"],[UIImage imageNamed:@"huoying6.jpg"],[UIImage imageNamed:@"huoying7.jpg"],[UIImage imageNamed:@"huoying8.jpg"],[UIImage imageNamed:@"huoying9.jpg"],[UIImage imageNamed:@"huoying10.jpg"],[UIImage imageNamed:@"huoying11.jpg"],[UIImage imageNamed:@"huoying12.jpg"],[UIImage imageNamed:@"huoying13.jpg"], nil];

    UIImageView *imageArrView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 -80, 50, 160, 160)];
    [imageArrView setAnimationImages:imageArr];
    [imageArrView setAnimationRepeatCount:0];
    [imageArrView setAnimationDuration:3];
    [imageArrView startAnimating];
    [self.view addSubview:imageArrView];
    
    self.textfiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 230, self.view.bounds.size.width - 20, 44)];
    self.textfiled.placeholder = @"已识别的语音在这里！";
    self.textfiled.layer.borderWidth = 2;
    self.textfiled.layer.borderColor = [UIColor greenColor].CGColor;
    self.textfiled.layer.cornerRadius = 4;
    self.textfiled.layer.masksToBounds = YES;
    self.textfiled.textAlignment = NSTextAlignmentCenter;
    self.textfiled.textColor = [UIColor blackColor];
    [self.view addSubview:self.textfiled];
    
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(150, self.view.bounds.size.height - 190, self.view.bounds.size.width - 300, 44)];
    self.recordButton.layer.borderWidth = 2;
    self.recordButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.recordButton.layer.cornerRadius = 2;
    self.recordButton.layer.masksToBounds = YES;
    [self.recordButton setTitle:@"录音" forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.recordButton addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:self.recordButton];
    
    self.strCutBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, self.view.bounds.size.height - 135, self.view.bounds.size.width - 300, 44)];
    self.strCutBtn.layer.borderWidth = 2;
    self.strCutBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.strCutBtn.layer.cornerRadius = 2;
    self.strCutBtn.layer.masksToBounds = YES;
    [self.strCutBtn setTitle:@"语音分词" forState:UIControlStateNormal];
    [self.strCutBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.strCutBtn addTarget:self action:@selector(startCutStr:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.strCutBtn];
    
    self.voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, self.view.bounds.size.height - 80, self.view.bounds.size.width - 300, 44)];
    self.voiceBtn.layer.borderWidth = 2;
    self.voiceBtn.layer.borderColor = [UIColor greenColor].CGColor;
    self.voiceBtn.layer.cornerRadius = 2;
    self.voiceBtn.layer.masksToBounds = YES;
    [self.voiceBtn setTitle:@"语音播放" forState:UIControlStateNormal];
    [self.voiceBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.voiceBtn addTarget:self action:@selector(voiceStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.voiceBtn];
    
}

- (void)initEngine {
    if (!self.speechRecognizer) {
        // 设置语言  "zh-CN"代表普通话，"en_US"代表英文
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    }
    if (!self.audioEngine) {
        self.audioEngine = [[AVAudioEngine alloc] init];
    }
    
    _audioSession = [AVAudioSession sharedInstance];
    [_audioSession setCategory:AVAudioSessionCategoryRecord mode:AVAudioSessionModeMeasurement options:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [_audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    if (self.recognitionRequest) {
        [self.recognitionRequest endAudio];
        self.recognitionRequest = nil;
    }
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    self.recognitionRequest.shouldReportPartialResults = YES; // 实时翻译
    
    [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
//        NSLog(@"is final: %d  result: %@", result.isFinal, result.bestTranscription.formattedString);
//        if (result.isFinal) {
//            self.textfiled.text = [NSString stringWithFormat:@" %@",result.bestTranscription.formattedString];
//        }
        if (result.bestTranscription.formattedString) {
            self.textfiled.text = [NSString stringWithFormat:@" %@",result.bestTranscription.formattedString];
        }
    }];
}

- (void)releaseEngine {
    [[self.audioEngine inputNode] removeTapOnBus:0];
    [self.audioEngine stop];
    
    [self.recognitionRequest endAudio];
    self.recognitionRequest = nil;
}

- (void)startRecording:(UIButton *)recordButton {
    [self initEngine];
    
    AVAudioFormat *recordingFormat = [[self.audioEngine inputNode] outputFormatForBus:0];
    [[self.audioEngine inputNode] installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:nil];
    
    [self.recordButton setTitle:@"录音ing" forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.recordButton.layer.borderColor = [UIColor redColor].CGColor;
    self.textfiled.textColor = [UIColor redColor];
    self.textfiled.text = @"正在输入语音...";
//    直接调用显示活动指示器的方法
    [self.bgView makeToastActivity:@"center" andText:@"录音中..."];
    
}
- (void)stopRecording:(UIButton *)recordButton {
    [self releaseEngine];
    
    [self.recordButton setTitle:@"录音" forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.recordButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.textfiled.textColor = [UIColor blackColor];
    self.textfiled.text = @"";
    
    [self.bgView hideToastActivity];
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textfiled resignFirstResponder];
}
- (void)startCutStr:(UIButton *)sender{
    NSArray *wordsArr = [NSArray array];
    wordsArr = [self stringCutbyStr:self.textfiled.text];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分词器" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    for (NSString *tempStr in wordsArr) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:tempStr style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
    }
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//字符串转词数组
//其实逻辑很简单：创建分词器-->一个个地一次获取分词后的每个词的起始位置和长度，从而取出词。
- (NSArray *)stringCutbyStr:(NSString *)string{
    
    NSMutableArray *wordsArray = [[NSMutableArray alloc] init];
    //  创建分词器
    CFStringTokenizerRef ref =  CFStringTokenizerCreate(NULL,  (__bridge CFStringRef)string, CFRangeMake(0, string.length), kCFStringTokenizerUnitWord, NULL);
    CFRange range;// 当前分词的位置
    // 获取第一个分词的范围
    CFStringTokenizerAdvanceToNextToken(ref);
    range = CFStringTokenizerGetCurrentTokenRange(ref);
    // 循环遍历获取所有分词并记录到数组中
    NSString *keyWord;
    while (range.length>0) {
        keyWord = [string substringWithRange:NSMakeRange(range.location, range.length)];
        [wordsArray addObject:keyWord];
        CFStringTokenizerAdvanceToNextToken(ref);
        range = CFStringTokenizerGetCurrentTokenRange(ref);
    }
    return wordsArray;
}
- (void)voiceStart:(UIButton *)btn{
    //解决 [AXTTSCommon] Failure starting audio queue \M-3<…>  报错。
    if (!_audioSession) printf("ERROR INITIALIZING AUDIO SESSION! \n");
    else{
        NSError *nsError = nil;
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&nsError];
        
        if (nsError) printf("couldn't set audio category!");
        [_audioSession setActive:YES error:&nsError];
        if (nsError) printf("AudioSession setActive = YES failed");
    }
    
    //红外感应听筒和扬声器之间的切换。
    [self ProximityMonitoringAction];

    
    if ([self.voiceSpeech isPaused]) {
        [self.voiceSpeech continueSpeaking]; //继续播放
    }else if([self.voiceSpeech isSpeaking]){
        [self.voiceSpeech pauseSpeakingAtBoundary:AVSpeechBoundaryWord]; //暂停播放
    }else{
        AVSpeechUtterance *speechUtterance = [[AVSpeechUtterance alloc] initWithString:self.textfiled.text];
        speechUtterance.pitchMultiplier = 1;
        speechUtterance.volume = 1;
        speechUtterance.rate = 0.5;
        speechUtterance.postUtteranceDelay = 1; //目的是让语音合成器播放下一语句前有短暂的暂停
        
        self.voiceSpeech = [[AVSpeechSynthesizer alloc] init];
        self.voiceSpeech.delegate = self;
        
        AVSpeechSynthesisVoice *language = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        speechUtterance.voice = language;
        
        
        [self.voiceSpeech speakUtterance:speechUtterance]; //开始播放
    }
}

- (void)ProximityMonitoringAction{
    /** 1.先设置为外放 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    });
    //监听是否靠近耳朵
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //开启红外感应
}
#pragma mark - 监听是否靠近耳朵
-(void)sensorStateChange:(NSNotificationCenter *)notification;{
    if ([[UIDevice currentDevice] proximityState] == YES){
        //靠近耳朵
         [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }else{
        //远离耳朵
         [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
}

- (void)routeChange:(NSNotification*)notify{
    if(notify){
        NSLog(@"声音声道改变%@",notify);
    }
    AVAudioSessionRouteDescription*route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) {
        NSLog(@"当前声道%@",[desc portType]);
        NSLog(@"输出源名称%@",[desc portName]);
        if ([[desc portType] isEqualToString:@"Headphones"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            });
        }
    }
}
#pragma mark --- 下面是代理方法： AVSpeechSynthesizerDelegate
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---开始播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---播放完成");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---暂停播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---继续播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---取消播放");
}


@end

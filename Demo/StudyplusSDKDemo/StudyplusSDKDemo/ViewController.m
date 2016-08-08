//
//  ViewController.m
//  StudyplusSDKDemo
//
//  Created by akitsukada on 2014/02/17.
//  Copyright (c) 2014年 studyplus.jp. All rights reserved.
//

#import "ViewController.h"
#import "SPLStudyplus.h"

static NSString * const ConsumerKey = @"Your consumer key";
static NSString * const ConsumerSecret = @"Your consumer secret";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *elapsedSecondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *isConnectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionResultLabel;
@end

SPLStudyplus *studyplus;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [NSTimer
     scheduledTimerWithTimeInterval:0.3f
     target:self
     selector:@selector(updateElapsedSeconds)
     userInfo:nil
     repeats:YES
     ];
    
    [self updateIsConnected];
}

- (IBAction)auth:(id)sender {
    [self.studyplus auth];
}

- (IBAction)login:(id)sender {
    [self.studyplus login];
}

- (IBAction)logout:(id)sender {
    [self.studyplus logout];
    self.actionResultLabel.text = @"Logged out";
    [self updateIsConnected];
}

- (IBAction)isConnected:(id)sender {
    [self updateIsConnected];
}

- (IBAction)post:(id)sender {
    // Create new study record.
    SPLStudyplusRecord *studyplusRecord =
        [SPLStudyplusRecord
         
         // @see SPLStopwatch
         recordWithDuration:[[self studyplus].stopwatch elapsedSeconds]
         
         /** You can add optional info.
          options:@{
              // Time the learning is ended. 学習を終えた日時。
              @"recordedAt" : [NSDate date],
              // Studyplus timeline comment. Studyplusのタイムライン上で表示されるコメント。
              @"comment" : @"アプリ◯◯で勉強しました！！",
              // @see SPLStudyplusRecordAmount
              @"amount" : [SPLStudyplusRecordAmount amount:100],
          }
          */
         ];
    
    // post
    [self.studyplus postStudyRecord:studyplusRecord];
}

- (IBAction)startStopwatch:(id)sender {
    [[self studyplus].stopwatch start];
    self.elapsedSecondsLabel.backgroundColor = [UIColor cyanColor];
}

- (IBAction)pauseStopwatch:(id)sender {
    [[self studyplus].stopwatch pause];
    self.elapsedSecondsLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (IBAction)resetStopwatch:(id)sender {
    [[self studyplus].stopwatch reset];
}

- (void)updateElapsedSeconds {
    self.elapsedSecondsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[self studyplus].stopwatch elapsedSeconds]];
}

- (void)updateIsConnected {
    self.isConnectedLabel.text = [[self studyplus] isConnected] ? @"YES" : @"NO";
    self.actionResultLabel.text = @"";
}

-(SPLStudyplus*)studyplus
{
    if (studyplus) {
        return studyplus;
    }
    
    studyplus = [SPLStudyplus studyplusWithConsumerKey:ConsumerKey
                                     andConsumerSecret:ConsumerSecret];
    studyplus.delegate = self;
    return studyplus;
}

// Called by AppDelegate
-(BOOL) openURL:(NSURL*)url
{
    return [self.studyplus openURL:url];
}

// callback methods
-(void)studyplusDidConnect:(SPLStudyplus*)studyplus
{
    self.actionResultLabel.text = @"Auth or Login succeeded";
    [self updateIsConnected];
}

-(void)studyplusDidFailToConnect:(SPLStudyplus*)studyplus withError:(NSError*)error
{
    self.actionResultLabel.text = @"Auth or Login failed";
    [self updateIsConnected];
}

- (void)studyplusDidCancel:(SPLStudyplus*)studyplus
{
    self.actionResultLabel.text = @"Auth or Login canceled";
    [self updateIsConnected];
}

-(void)studyplusDidPostStudyRecord:(SPLStudyplus*)studyplus
{
    self.actionResultLabel.text = @"Post to Studyplus succeeded";
}

-(void)studyplusDidFailToPostStudyRecord:(SPLStudyplus*)studyplus withError:(NSError*)error
{
    self.actionResultLabel.text = error.localizedDescription;
}

@end

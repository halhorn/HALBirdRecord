//
//  HALBirdKindStatisticsViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/05/14.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALBirdKindStatisticsViewController.h"
#import "HALStatistics.h"
#import "HALMapManager.h"
#import "CorePlot-CocoaTouch.h"
#import <MapKit/MapKit.h>

@interface HALBirdKindStatisticsViewController ()<CPTPlotDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *monthGraphView;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (nonatomic) HALBirdKind *birdKind;
@property (nonatomic) NSArray *birdRecordList;
@property (nonatomic) CPTGraph *monthGraph;
@property (nonatomic) NSArray *monthGraphData;

@end

@implementation HALBirdKindStatisticsViewController

- (HALBirdKindStatisticsViewController *)initWithBirdKind:(HALBirdKind *)birdKind
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.birdKind = birdKind;
        HALStatistics *statistics = [HALStatistics sharedModel];
        self.birdRecordList = [statistics birdRecordWithBirdID:birdKind.birdID];
        self.monthGraphData = [statistics birdCountInMonthWithBirdRecords:self.birdRecordList];
        self.title = birdKind.name;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadMapView];
    [self setupMonthGraph];

    self.view.backgroundColor = kHALBirdKindStatisticsBackgroundColor;
    self.mapLabel.textColor = kHALTextColor;
    self.monthLabel.textColor = kHALTextColor;
}

- (void)loadMapView
{
    HALMapManager *mapManager = [HALMapManager managerWithBirdRecordList:self.birdRecordList];
    self.mapView.region = [mapManager region];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[mapManager annotationList]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMonthGraph
{
    // 最大値
    int maxCount = 0;
    for (NSNumber *num in self.monthGraphData) {
        if ([num intValue] > maxCount) {
            maxCount = [num intValue];
        }
    }
    // 目盛りの付け方の都合上、maxYは偶数にする。
    int maxY = maxCount % 2 == 0 ? maxCount : maxCount + 1;

    //　ホスティングビュー
    CPTGraphHostingView *hostingView =
    [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, self.monthGraphView.frame.size.width, self.monthGraphView.frame.size.height)];
    hostingView.collapsesLayers = NO;
    [self.monthGraphView addSubview:hostingView];

    // グラフ
    self.monthGraph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    hostingView.hostedGraph = self.monthGraph;

    // テーマ
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.monthGraph applyTheme:theme];

    // ボーダー
    self.monthGraph.plotAreaFrame.borderLineStyle = nil;
    self.monthGraph.plotAreaFrame.cornerRadius    = 0.0f;
    self.monthGraph.plotAreaFrame.masksToBorder   = NO;

    // パディング
    self.monthGraph.paddingLeft   = 0.0f;
    self.monthGraph.paddingRight  = 0.0f;
    self.monthGraph.paddingTop    = 0.0f;
    self.monthGraph.paddingBottom = 0.0f;

    self.monthGraph.plotAreaFrame.paddingLeft   = 30.0f;
    self.monthGraph.plotAreaFrame.paddingTop    = 10.0f;
    self.monthGraph.plotAreaFrame.paddingRight  = 20.0f;
    self.monthGraph.plotAreaFrame.paddingBottom = 30.0f;

    //プロット間隔の設定
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.monthGraph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(maxY)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(1) length:CPTDecimalFromInt(12)];

    // テキストスタイル
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color                = [CPTColor colorWithComponentRed:0.447f green:0.443f blue:0.443f alpha:1.0f];
    textStyle.fontSize             = 12.0f;
    textStyle.textAlignment        = CPTTextAlignmentCenter;

    // ラインスタイル
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor            = [CPTColor colorWithComponentRed:0.788f green:0.792f blue:0.792f alpha:1.0f];
    lineStyle.lineWidth            = 1.0f;

    // X軸のメモリ・ラベルなどの設定
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.monthGraph.axisSet;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = lineStyle;
    x.majorTickLineStyle          = lineStyle;
    x.minorTickLineStyle          = lineStyle;
    x.majorIntervalLength         = CPTDecimalFromString(@"1"); // Y軸ラベルの表示間隔
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // X軸のY位置
    x.title                       = @"";
    x.titleTextStyle = textStyle;
    x.titleLocation               = CPTDecimalFromFloat(5.0f);
    x.titleOffset                 = 36.0f;
    x.minorTickLength = 0.0f;                   // X軸のメモリの長さ
    x.majorTickLength = 9.0f;                   // X軸のメモリの長さ
    x.labelRotation  = M_PI/3;                // 表示角度
    x.labelTextStyle = textStyle;
    x.labelFormatter = formatter;
    x.labelAlignment = CPTAlignmentCenter;
    x.labelOffset = 0.5f;

    // ラベル
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:12];
    int idx = 1;
    for (NSString *year in @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"]) // ラベルの文字列
    {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:year
                                                       textStyle:axisSet.xAxis.labelTextStyle];
        label.tickLocation = CPTDecimalFromCGFloat(idx+0.5); // ラベルを追加するレコードの位置
        label.offset = 5.0f; // 軸からラベルまでの距離
        [labels addObject:label];
        ++idx;
    }
    // X軸に設定
    x.axisLabels = [NSSet setWithArray:labels];
    x.labelingPolicy = CPTAxisLabelingPolicyNone;

    // Y軸のメモリ・ラベルなどの設定
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = lineStyle;
    y.minorTickLength = 0.0f;                   // Y軸のメモリの長さ
    y.majorTickLength = 9.0f;                   // Y軸のメモリの長さ
    y.majorTickLineStyle          = lineStyle;
    y.minorTickLineStyle          = lineStyle;
    y.majorIntervalLength         = CPTDecimalFromFloat(maxY / 2);  // Y軸ラベルの表示間隔
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(1.0f);  // Y軸のX位置
    y.title                       = @"";
    y.titleTextStyle = textStyle;
    y.titleRotation = M_PI*2;
    y.titleLocation               = CPTDecimalFromFloat(10.5f);
    y.titleOffset                 = 25.0f;
    lineStyle.lineWidth = 0.5f;
    y.majorGridLineStyle = lineStyle;
    y.labelTextStyle = textStyle;
    y.labelFormatter = formatter;

    // 棒グラフの作成と設定
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:1.0f green:1.0f blue:0.88f alpha:1.0f] horizontalBars:NO];
    barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.573f green:0.82f blue:0.831f alpha:0.50f]]; // バーの色を設定。上記のカラーが上塗りされる。
    barPlot.lineStyle = lineStyle;                      // ラインスタイルを設定
    barPlot.baseValue  = CPTDecimalFromString(@"0");    // グラフのベースの値を設定
    barPlot.dataSource = self;                          // データソースを設定
    barPlot.delegate = self;
    barPlot.barWidth = CPTDecimalFromFloat(0.5f);       // 各棒の幅を設定
    barPlot.barOffset  = CPTDecimalFromFloat(0.5f);     // 各棒の横軸からのオフセット値を設定
    [self.monthGraph addPlot:barPlot toPlotSpace:plotSpace];      // グラフに棒グラフを追加
}

#pragma mark CPTPlotDataSource

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    // 一年は12ヶ月
    return 12;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
                //Xの位置を指定
            case CPTBarPlotFieldBarLocation:
                num = [NSDecimalNumber numberWithUnsignedInteger:index+1];
                break;

                //棒の高さを指定
            case CPTBarPlotFieldBarTip:
                num = [self.monthGraphData objectAtIndex:index];
                break;
        }
    }
    return num;
}

@end

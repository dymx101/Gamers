//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat MJRefreshHeaderHeight = 54.0;
const CGFloat MJRefreshFooterHeight = 44.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset = @"contentInset";
NSString *const MJRefreshKeyPathContentSize = @"contentSize";
NSString *const MJRefreshKeyPathPanState = @"state";

NSString *const MJRefreshHeaderLastUpdatedTimeKey = @"MJRefreshHeaderLastUpdatedTimeKey";

NSString *const MJRefreshHeaderIdleText = @"下拉可以刷新";
NSString *const MJRefreshHeaderPullingText = @"鬆開立即刷新";
NSString *const MJRefreshHeaderRefreshingText = @"正在刷新數據中...";

NSString *const MJRefreshAutoFooterIdleText = @"點擊或上拉加載更多";
NSString *const MJRefreshAutoFooterRefreshingText = @"正在加載更多的數據...";
NSString *const MJRefreshAutoFooterNoMoreDataText = @"已經全部加載完畢";

NSString *const MJRefreshBackFooterIdleText = @"上拉可以加載更多";
NSString *const MJRefreshBackFooterPullingText = @"鬆開立即加載更多";
NSString *const MJRefreshBackFooterRefreshingText = @"正在加載更多的數據...";
NSString *const MJRefreshBackFooterNoMoreDataText = @"已經全部加載完畢";
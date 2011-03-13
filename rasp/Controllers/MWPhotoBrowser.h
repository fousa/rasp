//
//  MWPhotoBrowser.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MWPhoto.h"

@class ZoomingScrollView;

@interface MWPhotoBrowser : UIViewController <UIScrollViewDelegate, MWPhotoDelegate> {
	
	// Photos
	NSArray *photos;
    NSArray *timeStamps;
    NSString *tabTitle;
	
	// Views
	UIScrollView *pagingScrollView;
	
	// Paging
	NSMutableSet *visiblePages, *recycledPages;
	int currentPageIndex;
	int pageIndexBeforeRotation;

	BOOL performingLayout;
	BOOL rotating;
}

@property (nonatomic, retain) id delegate;

// Init
- (id)initWithPhotos:(NSArray *)photosArray andTimeStamps:(NSArray *)timeStampsArray andTabTitle:(NSString *)aTabTitle;

// Photos
- (UIImage *)imageAtIndex:(int)index;

// Layout
- (void)performLayout;

// Paging
- (void)tilePages;
- (BOOL)isDisplayingPageForIndex:(int)index;
- (ZoomingScrollView *)pageDisplayedAtIndex:(int)index;
- (ZoomingScrollView *)dequeueRecycledPage;
- (void)configurePage:(ZoomingScrollView *)page forIndex:(int)index;
- (void)didStartViewingPageAtIndex:(int)index;

// Frames
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;
- (CGPoint)contentOffsetForPageAtIndex:(int)index;
- (CGRect)frameForNavigationBarAtOrientation:(UIInterfaceOrientation)orientation;
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation;

// Navigation
- (void)updateNavigation;
- (void)jumpToPageAtIndex:(int)index;
- (void)gotoPreviousPage;
- (void)gotoNextPage;

// Properties
- (void)setInitialPageIndex:(int)index;

@end

@protocol MWPhotoBrowserDelegate <NSObject>
@required
- (void)updateTitle:(NSString *)aTitle andTabTitle:(NSString *)aTabTitle onBrowser:(MWPhotoBrowser *)browser;
@end
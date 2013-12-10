//
//  jxdribbble_DetailViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-14.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_DetailViewController.h"
#import "jxdribbble_comments.h"
#import "jxdribbble_CommentCell.h"
#import "NSString+HTML.h"
#import "jxdribbble_PlayerViewController.h"
#import "jxdribbble_ReboundsViewController.h"
#import <Dropbox/Dropbox.h>
#import "ENMLUtility.h"
#import "NSData+EvernoteSDK.h"
#import "NSDate+EDAMAdditions.h"
#import "EvernoteSDK.h"
#import "MBProgressHUD.h"
#import "jxdribbble_WebViewController.h"


@interface jxdribbble_DetailViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger     pageIndex;

@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) UIButton *reboundsButton;
@property (copy, nonatomic) NSString *link;
@property (strong, nonatomic) UIActionSheet *openLinkActionSheet;

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIControl *headerView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation jxdribbble_DetailViewController

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
	// Do any additional setup after loading the view.

    self.title = @"Detail";

    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];

    if ([self.shot.rebounds_count integerValue] > 0 )
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: [NSString stringWithFormat:@"%@ rebounds",self.shot.rebounds_count]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(rebounds)];
    }
    

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,49, 0);
    
    __weak jxdribbble_DetailViewController *weakSelf = self;
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    self.tableView.tableHeaderView = [self setUpHeaderView] ;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.scrollEnabled = YES;
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:50];
    self.pageIndex = 1;
    
    if ([self.shot.comments_count integerValue] > 0 )
    {
        [self getData];
    }

}

- (void)viewWillAppear:(BOOL)animated
{

}


/**
 *  
 */
- (void)rebounds
{
    jxdribbble_ReboundsViewController *rebounds = [[jxdribbble_ReboundsViewController alloc] init];
    rebounds.shot = self.shot;
    [self.navigationController pushViewController:rebounds animated:YES];
}

- (UIControl *)setUpHeaderView
{
    
    self.headerView = [[UIControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 320.0)];
    
    //UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 7.0, 35.0, 35.0)];
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 35.0, 35.0)];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 17.5;
    
    [avatarImageView setImageWithURL:[NSURL URLWithString:self.shot.player.avatar_url] placeholderImage:[UIImage imageNamed:@"headimg_bg"]];
    
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userButton setFrame:CGRectMake(10.0, 7.0, 35.0, 35.0)];
    [userButton addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    [userButton addSubview:avatarImageView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 5.0, 250.0, 20.0)];
    titleLabel.text = self.shot.title;
    titleLabel.font = [jxdribbble_Global globlaFontWithSize:15];
    titleLabel.textColor = [jxdribbble_Global globlaColor];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 30.0, 150.0, 15.0)];
    usernameLabel.text = [NSString stringWithFormat:@"by %@", self.shot.player.name];
    usernameLabel.font = [jxdribbble_Global globlaFontWithSize:10];
    usernameLabel.textColor = [jxdribbble_Global globlaColor];
    
    UILabel *created_atLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 30.0, 107.0, 15.0)];
    created_atLabel.text = [self.shot.created_at substringToIndex:16];
    created_atLabel.textAlignment = NSTextAlignmentRight;
    created_atLabel.font = [jxdribbble_Global globlaFontWithSize:10];
    created_atLabel.textColor = [jxdribbble_Global globlaTextColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 50.0, 300.0, 225.0)];
    imageView.userInteractionEnabled = YES;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:imageView animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    __weak typeof(imageView) weakImageView = imageView;

    NSURL *url;
    if ( [[self.shot.image_url substringWithRange:NSMakeRange(self.shot.image_url.length - 4,4)] isEqualToString:@".gif"] )
    {
        url = [NSURL URLWithString:self.shot.image_teaser_url];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(openWeb)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.delegate = self;
        [imageView addGestureRecognizer:tapGestureRecognizer];


        UIImage *playImage = [UIImage imageNamed:@"play"];
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setFrame:CGRectMake(2.0, 193.0, 30.0, 30.0)];
        //[playButton addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
        [playButton setImage:playImage forState:UIControlStateNormal];
        [imageView addSubview:playButton];
    }
    else
    {
        url = [NSURL URLWithString:self.shot.image_url];
    }
    
    [imageView setImageWithURL:url
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 options:SDWebImageLowPriority
                                progress:^(NSUInteger receivedSize, long long expectedSize) {
                                    double p = (double)receivedSize/(double)expectedSize;
                                    hud.progress = p;
                                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    if (!error)
                                    {
                                        weakImageView.image = image;
                                        self.shareImage = image;
                                    }
                                    hud.hidden = YES;
                                }];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(278.0, 280.0, 30.0, 30.0)];
    [shareButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:userButton];
    [self.headerView addSubview:titleLabel];
    [self.headerView addSubview:usernameLabel];
    [self.headerView addSubview:created_atLabel];
    [self.headerView addSubview:imageView];
    [self.headerView addSubview:shareButton];
    
    return self.headerView;
    
}


- (void)openWeb
{
    if (!self.webView)
    {

        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(10.0, 50.0, 300.0, 225.0)];
        
        UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWeb)];
        tapRec.delegate = self;
        tapRec.numberOfTapsRequired = 1;
        [self.webView addGestureRecognizer:tapRec];
        
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shot.image_url]]];
        
        UIImage *playImage = [UIImage imageNamed:@"stop"];
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setFrame:CGRectMake(2.0, 193.0, 30.0, 30.0)];
        [playButton setImage:playImage forState:UIControlStateNormal];
        [self.webView addSubview:playButton];
        
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner setColor:[jxdribbble_Global globlaColor]];
        [_spinner setCenter:CGPointMake(150 , 115)];
        [self.webView addSubview:_spinner];
        [_spinner startAnimating];
        
    }

    
    [self.headerView addSubview:self.webView];

    
}

- (void)closeWeb
{

    if (self.webView)
    {
        [self.webView removeFromSuperview];
    }
}


- (void)viewDidDisappear:(BOOL)animated
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_spinner stopAnimating];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}

- (void)share
{

    
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    EvernoteSession *session = [EvernoteSession sharedSession];
    
    /**
     *  如果都授权
     */
    if ( account && session.isAuthenticated)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share and Save",@"Save to Dropbox",@"Save to Evernote",@"Open",@"Open in Safari",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }
    /**
     *  如果dropbox授权,evernote没有授权
     */
    else if (account && !session.isAuthenticated)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share and Save",@"Save to Dropbox",@"Open",@"Open in Safari",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }
    /**
     *  如果dropbox没授权,evernote授权
     */
    else if (!account && session.isAuthenticated)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share and Save",@"Save to Evernote",@"Open",@"Open in Safari",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }
    /**
     *  如果都没授权
     */
    else if (!account && !session.isAuthenticated)
    {
        //[self shareToSocialNetworking];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share and Save",@"Open",@"Open in Safari",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }
    
    
  
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = [jxdribbble_Global globlaFontWithSize:15];
            button.titleLabel.textColor = [jxdribbble_Global globlaColor];
        }
    }
}

#pragma mark -  actionsheetdelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.openLinkActionSheet)
    {
        NSLog(@"%@",self.link);
        
        if ( buttonIndex == 0 )
        {
            jxdribbble_WebViewController *webViewController = [[jxdribbble_WebViewController alloc] init];
            webViewController.urlString = self.link;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        else if ( buttonIndex == 1 )
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.link]]];
        }
    }
    else
    {
        DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
        EvernoteSession *session = [EvernoteSession sharedSession];
        
        /**
         *  如果都授权
         */
        if ( account && session.isAuthenticated)
        {
            
            if ( buttonIndex == 0 )
            {
                [self shareToSocialNetworking];
            }
            else if ( buttonIndex == 1 )
            {
                if (self.shareImage)
                {
                    [self dropbox];
                }
            }
            else if ( buttonIndex == 2 )
            {
                if (self.shareImage)
                {
                    [self evernote];
                }
            }
            else if ( buttonIndex == 3 )
            {
                jxdribbble_WebViewController *webViewController = [[jxdribbble_WebViewController alloc] init];
                webViewController.urlString = self.shot.short_url;
                webViewController.titleString = self.shot.title;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            else if ( buttonIndex ==4 )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.link]]];
            }
        }
        /**
         *  如果dropbox授权,evernote没有授权
         */
        else if (account && !session.isAuthenticated)
        {
            if ( buttonIndex == 0 )
            {
                [self shareToSocialNetworking];
            }
            else if ( buttonIndex == 1 )
            {
                if (self.shareImage)
                {
                    [self dropbox];
                }
            }
            else if ( buttonIndex == 2 )
            {
                jxdribbble_WebViewController *webViewController = [[jxdribbble_WebViewController alloc] init];
                webViewController.urlString = self.shot.short_url;
                webViewController.titleString = self.shot.title;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            else if ( buttonIndex == 3 )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.shot.short_url]]];
            }
        }
        /**
         *  如果dropbox没授权,evernote授权
         */
        else if (!account && session.isAuthenticated)
        {
            if ( buttonIndex == 0 )
            {
                [self shareToSocialNetworking];
            }
            else if ( buttonIndex == 1 )
            {
                if (self.shareImage)
                {
                    [self evernote];
                }
            }
            else if ( buttonIndex == 2 )
            {
                jxdribbble_WebViewController *webViewController = [[jxdribbble_WebViewController alloc] init];
                webViewController.urlString = self.shot.short_url;
                webViewController.titleString = self.shot.title;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            else if ( buttonIndex == 3 )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.shot.short_url]]];
            }
        }
        else if ( !account && !session.isAuthenticated )
        {
            if ( buttonIndex == 0 )
            {
                [self shareToSocialNetworking];
            }
            else if ( buttonIndex == 1 )
            {
                jxdribbble_WebViewController *webViewController = [[jxdribbble_WebViewController alloc] init];
                webViewController.urlString = self.shot.short_url;
                webViewController.titleString = self.shot.title;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            else if ( buttonIndex == 2 )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.shot.short_url]]];
            }
        }
    }
}


- (void)dropbox
{
    if ([CheckNetwork isExistenceNetwork])
    {
        DBPath *newPath = [[DBPath root] childPath:[NSString stringWithFormat:@"%@_%@.png",[self.shot.title stringByReplacingOccurrencesOfString:@" " withString:@""],[self.shot.player.name stringByReplacingOccurrencesOfString:@" " withString:@""]]];
         
        DBFile *file = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
        NSData *imageData = UIImagePNGRepresentation(self.shareImage);
        [file writeData:imageData error:nil];
    }
}

- (void)evernote
{
    if ([CheckNetwork isExistenceNetwork])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSData *imageData = UIImagePNGRepresentation(self.shareImage);
        NSData *dataHash = [imageData enmd5];
        EDAMData *edamData = [[EDAMData alloc] initWithBodyHash:dataHash size:imageData.length body:imageData];
        EDAMResource* resource = [[EDAMResource alloc] initWithGuid:nil noteGuid:nil data:edamData mime:@"image/png" width:0 height:0 duration:0 active:0 recognition:0 attributes:nil updateSequenceNum:0 alternateData:nil];
        NSString *noteContent = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                 "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
                                 "<en-note>"
                                 "<span style=\"font-weight:bold;\">%@</span>"
                                 "<br />"
                                 "<span>by %@ </span>"
                                 "<br />"
                                 "<span> %@ </span>"
                                 "<br />"
                                 "%@"
                                 "</en-note>",self.shot.title,self.shot.player.name,self.shot.url,[ENMLUtility mediaTagWithDataHash:dataHash mime:@"image/png"]];
        NSMutableArray* resources = [NSMutableArray arrayWithArray:@[resource]];
        EDAMNote *newNote = [[EDAMNote alloc] initWithGuid:nil title:[NSString stringWithFormat:@"%@ by %@",self.shot.title,self.shot.player.name] content:noteContent contentHash:nil contentLength:noteContent.length created:0 updated:0 deleted:0 active:YES updateSequenceNum:0 notebookGuid:nil tagGuids:nil resources:resources attributes:nil tagNames:nil];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        
        [[EvernoteNoteStore noteStore] setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Total bytes written : %lld , Total bytes expected to be written : %lld",totalBytesWritten,totalBytesExpectedToWrite);
            double p = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
            hud.progress = p;
        }];
        
        [[EvernoteNoteStore noteStore] createNote:newNote success:^(EDAMNote *note) {
            NSLog(@"Note created successfully.");
            [hud hide:YES];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(NSError *error) {
            [hud hide:YES];
            NSLog(@"Error creating note : %@",error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
}

- (void)shareToSocialNetworking
{
    
    NSString *textToShare = [NSString stringWithFormat:@"%@ by @\%@ from @jxdribbble",self.shot.title,self.shot.player.username];
    NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.shot.short_url]];
    NSArray *activityItems;
    if (self.shareImage)
    {
        activityItems = @[textToShare, self.shareImage, urlToShare];
    }
    else activityItems = @[textToShare, urlToShare];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePrint,UIActivityTypeCopyToPasteboard];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    if([self isViewLoaded] && ![[self view] window])
    {
        if (self.webView)
        {
            [self.webView removeFromSuperview];
            self.webView = nil;
        }
        if (self.headerView)
        {
            [self.headerView removeFromSuperview];
            self.headerView = nil;
        }
    }
}

- (void)userInfo
{
    jxdribbble_PlayerViewController *playerViewController = [[jxdribbble_PlayerViewController alloc] init];
    playerViewController.player = self.shot.player;
    [self.navigationController pushViewController:playerViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[[(jxdribbble_comments *)[self.dataSource objectAtIndex:indexPath.row] body] stringByConvertingHTMLToPlainText]
     attributes:@
     {
        NSFontAttributeName: [jxdribbble_Global globlaFontWithSize:12]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){250.0, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize  size = rect.size;
    CGFloat height = ceilf(size.height);
    
    return height + 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    jxdribbble_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[jxdribbble_CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    jxdribbble_comments *comment = [self.dataSource objectAtIndex:indexPath.row];

    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[[(jxdribbble_comments *)[self.dataSource objectAtIndex:indexPath.row] body] stringByConvertingHTMLToPlainText]
     attributes:@
     {
        NSFontAttributeName: [jxdribbble_Global globlaFontWithSize:12]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){250.0, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    cell.frame = CGRectMake(0.0, 0.0, 320.0, size.height + 60.0);
    
    cell.bodyLabel.frame = CGRectMake(50.0, 35.0, 250.0, size.height + 10.0);
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:comment.player.avatar_url] placeholderImage:[UIImage imageNamed:@"headimg_bg"]];
    cell.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [cell.avatarImageView addGestureRecognizer:tapGesture];
    cell.usernameLabel.text = comment.player.name;
    cell.bodyLabel.text = [comment.body stringByConvertingHTMLToPlainText];
    [cell.bodyLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
       
        
        NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
        NSLog(@"%@",[NSString stringWithFormat:@"%@ [%d,%d]: %@%@",
                     hotWords[hotWord],
                     (int)range.location,
                     (int)range.length,
                     string,
                     (protocol != nil) ? [NSString stringWithFormat:@" *%@*",protocol] : @""]
              );
        
        if ([hotWords[hotWord] length] > 0)
        {
            if ([hotWords[hotWord] isEqualToString:@"Link"])
            {
                self.link = string;
                self.openLinkActionSheet = [[UIActionSheet alloc] initWithTitle:string delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open",@"Open in Safari",nil];
                self.openLinkActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                [self.openLinkActionSheet showInView:self.view];
            }
        }
        
    }];
    cell.created_atLabel.frame = CGRectMake(160.0, size.height + 50.0, 150.0, 10);
    cell.created_atLabel.text =  [comment.created_at substringToIndex:16];;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

/**
 *  tap the avatar imageview in cell
 *
 *  @param tapGestureRecognizer
 */
- (void) tapGesture: (UITapGestureRecognizer *) tapGestureRecognizer
{
    jxdribbble_CommentCell *cell = (jxdribbble_CommentCell*)[[[tapGestureRecognizer.view superview] superview] superview];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    jxdribbble_PlayerViewController *playerViewController = [[jxdribbble_PlayerViewController alloc] init];
    playerViewController.player = [(jxdribbble_comments *)[self.dataSource objectAtIndex:indexPath.row] player];
    [self.navigationController pushViewController:playerViewController animated:YES];
}

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    jxdribbble_PlayerViewController *playerViewController = [[jxdribbble_PlayerViewController alloc] init];
    playerViewController.player = [(jxdribbble_comments *)[self.dataSource objectAtIndex:indexPath.row] player];
    [self.navigationController pushViewController:playerViewController animated:YES];

}
*/

#pragma mark - getdata

- (void)getData
{
    if ([CheckNetwork isExistenceNetwork])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/shots/%@/comments?page=%@&per_page=20",self.shot.id,[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]]];

        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;
            NSArray *comments = [jsonDic objectForKey:@"comments"];
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:50];
            for (NSDictionary * commentsDic in comments)
            {
                jxdribbble_comments  *comment = [[jxdribbble_comments alloc] initWithCommentInfo:commentsDic];

                if ( self.pageIndex != 1 )
                {
                    bool isExist = NO;
                    for ( jxdribbble_comments *s in self.dataSource )
                    {
                        if ( [[NSString stringWithFormat:@"%@",s.id] isEqualToString:[NSString stringWithFormat:@"%@",comment.id]] )
                        {
                            isExist = YES;
                            break;
                        }
                    }
                    if (!isExist)[ dataArray addObject:comment];
                }
                else
                {
                    [ dataArray addObject:comment];
                }

            }
            if ( [dataArray count ]< 20 )
            {
                self.tableView.showsInfiniteScrolling = NO;
            }
            
            [self.dataSource addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"%@",error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if(self.pageIndex > 1)self.pageIndex--;
        }];
        
        [operation start];
    }
    else
    {
        if(self.pageIndex > 1)self.pageIndex--;
    }
    
}

#pragma mark - loadMore

- (void)loadMore
{
    __weak jxdribbble_DetailViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        weakSelf.pageIndex++;
        [weakSelf getData];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

@end

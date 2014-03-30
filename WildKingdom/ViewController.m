//
//  ViewController.m
//  WildKingdom
//
//  Created by Marion Ano on 3/27/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
//

#import "ViewController.h"
#import "WildKingdomCollectionViewCell.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarDelegate>
{
    NSString* tags;
    //NSString *FlickrAPIKey;

}

@property NSDictionary* flickrDictionary;
@property NSDictionary* flickrPhotoDictionary;
@property NSMutableArray* myMutableArray;
@property WildKingdomCollectionViewCell *lionCollectionViewCell;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionViewLions;
@property (strong, nonatomic) IBOutlet UITabBarItem *lionTabBarItem;
@property (strong, nonatomic) IBOutlet UITabBarItem *bearsTabBarItem;
@property (strong, nonatomic) IBOutlet UITabBarItem *tigerTapBarItem;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //FlickrAPIKey = @"633598ba88b5bf68d28634f609db6aef";
    
    self.myMutableArray = [NSMutableArray new];
    tags= @"lion";
    [self searchPhotos];
    self.lionCollectionViewCell = [WildKingdomCollectionViewCell new];
    //self.tabBar.delegate = self;
    
    //why did I need to delete this code?
    //[self.myCollectionViewLions registerClass:[WildKingdomCollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionViewCellLionsID"];
}
//create helper method here to search for photos using tags:
-(void)searchPhotos
{
    
     NSString *getPhotos = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a2771d1875542f34f36cfa340a824c39&tags=%@&per_page=20&format=json&nojsoncallback=1",tags];
    
    NSURL *url = [NSURL URLWithString:getPhotos];
    //this is the JSON url to access the Flickr API
//    NSURL *flickrURL = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=633598ba88b5bf68d28634f609db6aef&tags=lions%2C+tigers%2C+bears&text=lions%2C+tigers%2C+bears&safe_search=1&format=json&nojsoncallback=1&api_sig=edf3c69979a834d164c3bba88d128b10", tags];
    
    //An NSURL object represents a URL that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data.
    NSURLRequest *flickrURLRequest = [NSURLRequest requestWithURL:url];
    
    //this is setting the spinner on in the nav bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:flickrURLRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {

         //this gets us into the JSON NSDictionary
         self.flickrDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         
         //now this gets us into the "photos" NSDictionary
         self.flickrPhotoDictionary = self.flickrDictionary[@"photos"];
         
         //this gets us into the "photo" array
         NSArray *gettingPhotosFromPhotosDictionary = self.flickrPhotoDictionary[@"photo"];

//         NSLog(@"first dictionary count: %lu", (unsigned long)self.flickrDictionary.count);
//         NSLog(@"second dictionary count: %lu", (unsigned long)self.flickrPhotoDictionary.count);
//         NSLog(@"array count: %lu", (unsigned long)gettingPhotosFromPhotosDictionary.count);
         
         //for all the NSDictionary items in the gettingPhotosFromPhotosDictionary, please do the following code in {}
         for (NSDictionary *items in  gettingPhotosFromPhotosDictionary)
         {
             //this string gets you the address where each photo lives
             NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", items[@"farm"], items[@"server"], items[@"id"], items[@"secret"]];
            
             
             //object conversion. Work backwards: What can I create an image from? What do I have? and how do I get to UIImage object? They key is: What do I want and how do I get back to it.
             
             NSLog(@"%@", photoURL);
             NSURL* url = [NSURL URLWithString:photoURL];
             NSData* data = [NSData dataWithContentsOfURL:url];
             UIImage* image = [UIImage imageWithData:data];
             
             //NSData *data = [[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
             // NSLog(@"%@", photoURL);
         
             //adding the URL object into the NSMutable Array which contains URL objects
             //now I have an array with image objects
             [self.myMutableArray addObject:image];
             
             //NSLog(@"data is being added to mutable array");
             
         }
         //NSLog(@"%lu", (unsigned long)self.myMutableArray.count);
         //remember that the view need to reload in the block
         [self.myCollectionViewLions reloadData];
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
     }];

}

#pragma mark -- Data Source Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myMutableArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //if tab bar item is at index 0
    WildKingdomCollectionViewCell *photoCell =
    [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
     UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
    //photoCell.backgroundColor = [UIColor redColor];
    photoCell.imageView.image = flickrImage;
    
    NSLog(@"make cell");
        return photoCell;
}

//note: outlets above for each tab bar item
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //call "search" method here based on string that's inserted
    //[self search:@""];
    //reference tab bar item pushed gets you the data you want to display
    if (self.lionTabBarItem.tag == 0)
    {
        tags = @"lion";
        [self searchPhotos];
    }
    
    else if (self.tigerTapBarItem.tag == 1)
    {

        tags = @"tiger";
        [self searchPhotos];
        //NSLog(@"selected 1 %d",self.tigerTapBarItem);
    }
    else (self.bearsTabBarItem.tag == 2);
    {
        tags = @"bear";
        [self searchPhotos];
        //NSLog(@"selected  2 %d",self.tabBarController.selectedIndex);
    }

   
}


//working on this 3/29, left off here before yoga

//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.tabBarController.tabBarItem == 0)
//    {
//        UICollectionViewCell *photoCell =
//        [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
//        //UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
//        photoCell.backgroundColor = [UIColor redColor];
//        //photoCell.imageView.image = flickrImage;
//        
//        NSLog(@"make cell");
//        return photoCell;
//    }
//    else if (self.tabBarController.tabBarItem == 1)
//    {
//        UICollectionViewCell *photoCell =
//        [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
//        //UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
//        photoCell.backgroundColor = [UIColor redColor];
//        //photoCell.imageView.image = flickrImage;
//        
//        NSLog(@"make cell");
//        return photoCell;
//    }
//    //else (self.tabBarController.tabBarItem == 2)
//    {
//        UICollectionViewCell *photoCell =
//        [self.myCollectionViewLions dequeueReusableCellWithReuseIdentifier:@"myCollectionViewCellLionsID" forIndexPath:indexPath];
//        //UIImage *flickrImage = [self.myMutableArray objectAtIndex:indexPath.row];
//        photoCell.backgroundColor = [UIColor redColor];
//        //photoCell.imageView.image = flickrImage;
//        return photoCell;
//    }
//    
//    return nil;
//}



@end

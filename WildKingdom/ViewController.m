//
//  ViewController.m
//  WildKingdom
//
//  Created by Marion Ano on 3/27/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

//api - b540bffdef2e4be5e90462d0c2bf7cbf
// secret  - b2a362d69dea7b69

@property NSDictionary* flickrDictionary;
@property NSDictionary* flickrPhotoDictionary;
@property NSMutableArray* myMutableArray;

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionViewLions;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//this is the JSON url to access the Flickr API
    NSURL *flickrURL = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1c8b30021433b88bc0c09fd72921f8de&tags=lions%2C+tigers%2C+bears%2C+wildlife&text=lions%2C+tigers%2C+bears%2C+wild+animais&sort=relevance&machine_tags=&machine_tag_mode=&place_id=&media=&has_geo=&lat=&lon=&radius=&radius_units=&format=json&nojsoncallback=1&auth_token=72157643021832053-739e72e268049f19&api_sig=3ac408c2f855bf836402ee27ff213c30"];
    
    //An NSURL object represents a URL that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data.
    NSURLRequest *flickrURLRequest = [NSURLRequest requestWithURL:flickrURL];
    
    [super viewDidLoad];
    
    [NSURLConnection sendAsynchronousRequest:flickrURLRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         //this gets us into the JSON NSDictionary
         self.flickrDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         
         //now this gets us into the second NSDictionary
         self.flickrPhotoDictionary = self.flickrDictionary[@"photos"];
         
         NSArray *gettingPhotosFromPhotosDictionary = self.flickrPhotoDictionary[@"photo"];
         
         //for all the NSDictionary items in the gettingPhotosFromPhotosDictionary, please do the following code in {}
         for (NSDictionary *items in  gettingPhotosFromPhotosDictionary)
         {
             //create a string with the NSURL object being called by the stringWithFormat method.
             NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", items[@"farm"], items[@"server"], items[@"id"], items[@"secret"]];
         
             //adding the URL object into the NSMutable Array which contains URL objects
             [self.myMutableArray addObject:[NSURL URLWithString:photoURL]];
             
             //somewhere in here I need to do some conversions to get the url into a photo and then reload myCollectionView with lion photos
             
             //remember that the view need to reload in the block
               [self.myCollectionViewLions reloadData];
             
         }
         
     }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myMutableArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


@end

//
//  ChatViewController.swift
//  craveit
//
//  Created by Akash Subramanian on 9/1/15.
//  Copyright (c) 2015 Akash Subramanian. All rights reserved.
//

import UIKit
import Parse



class ChatViewController: UIViewController, UITextFieldDelegate {

    let TABBAR_HEIGHT: CGFloat = 49.00
    let TEXTFIELD_HEIGHT: CGFloat = 70.00
    var chatData = []
    var isReloading = false
    let serverMan = AppDelegate.Location.ServerMan
    
    @IBOutlet var chatTable: UITableView!
    @IBOutlet var tfEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tfEntry.delegate = self
        tfEntry.clearButtonMode = UITextFieldViewMode.WhileEditing
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
// MARK -- CHAT FIELD METHODS 
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
        tfEntry.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UITextField) {
        tfEntry.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (tfEntry.text.length() > 0) {
            return false
        }
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func freeKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Undone: this was for the movement of TF up responding to keyboard
    func keyboardWasShown(notification:NSNotification) {
        let info = notification.userInfo
        // To Do
    }
    
    func keyboardWillHide(notification:NSNotification) {
        // To Do
    }
    
}
// MARK -- TABLESOURCE
  
extension ChatViewController {
    
    func  reloadTableViewDataSource{
        self.isReloading = true
        self.loadLocalChat()
        self.chatTable.reloadData
    }
    
    func doneLoadingTableViewData{
        
    isReloading = NO;
    [refreshHeaderView, egoRefreshScrollViewDataSourceDidFinishedLoading:chatTable];
    
    }
    
    
    #pragma mark -
    #pragma mark UIScrollViewDelegate Methods
    
    - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    }
    
    - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    }
    
    
    #pragma mark -
    #pragma mark EGORefreshTableHeaderDelegate Methods
    
    - (void)egoRefreshTableHeaderDidTriggerRefresh:(PF_EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
    }
    
    - (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(PF_EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
    }
    
    - (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(PF_EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
    }
    We’re going to deal with the table delegate now. Add this code to DMChatRoomViewController.m (you’ll need to #import “chatCell.h” as well):
    
    #pragma mark - Table view delegate
    
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatData count];
    }
    
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    chatCell *cell = (chatCell *)[tableView dequeueReusableCellWithIdentifier: @"chatCellIdentifier"];
    NSUInteger row = [chatData count]-[indexPath row]-1;
    
    if (row < chatData.count){
    NSString *chatText = [[chatData objectAtIndex:row] objectForKey:@"text"];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [chatText sizeWithFont:font constrainedToSize:CGSizeMake(225.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
    cell.textString.frame = CGRectMake(75, 14, size.width +20, size.height + 20);
    cell.textString.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    cell.textString.text = chatText;
    [cell.textString sizeToFit];
    
    NSDate *theDate = [[chatData objectAtIndex:row] objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm a"];
    NSString *timeString = [formatter stringFromDate:theDate];
    cell.timeLabel.text = timeString;
    
    cell.userLabel.text = [[chatData objectAtIndex:row] objectForKey:@"userName"];
    }
    return cell;
    }
    
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    NSString *cellText = [[chatData objectAtIndex:chatData.count-indexPath.row-1] objectForKey:@"text"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(225.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 40;
    }
    Now if you compile and run, you should be without error. It’s just a matter of connecting to Parse now, and loading our data… We check first that our reload method is working when pull-to-refresh is activated. Just add the following lines to the end of the viewDidLoad method:
    
    if (_refreshHeaderView == nil) {
    
    PF_EGORefreshTableHeaderView *view = [[PF_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - chatTable.bounds.size.height, self.view.frame.size.width, chatTable.bounds.size.height)];
    view.delegate = self;
    [chatTable addSubview:view];
    _refreshHeaderView = view;
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    If we build and run, we’ll see that the well-known pull-to-refresh messages comes up, before a crash: we have not entered the loadChatCata method yet. Let’s do that, add these lines to your DMChatRoomViewController.m.
    
    #pragma mark - Parse
    
    - (void)loadLocalChat
    {
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([chatData count] == 0) {
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByAscending:@"createdAt"];
    NSLog(@"Trying to retrieve from cache");
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
    // The find succeeded.
    NSLog(@"Successfully retrieved %d chats from cache.", objects.count);
    [chatData removeAllObjects];
    [chatData addObjectsFromArray:objects];
    [chatTable reloadData];
    } else {
    // Log details of the failure
    NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    }];
    }
    __block int totalNumberOfEntries = 0;
    [query orderByAscending:@"createdAt"];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error) {
    // The count request succeeded. Log the count
    NSLog(@"There are currently %d entries", number);
    totalNumberOfEntries = number;
    if (totalNumberOfEntries > [chatData count]) {
    NSLog(@"Retrieving data");
    int theLimit;
    if (totalNumberOfEntries-[chatData count]>MAX_ENTRIES_LOADED) {
    theLimit = MAX_ENTRIES_LOADED;
    }
    else {
    theLimit = totalNumberOfEntries-[chatData count];
    }
    query.limit = [NSNumber numberWithInt:theLimit];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
    // The find succeeded.
    NSLog(@"Successfully retrieved %d chats.", objects.count);
    [chatData addObjectsFromArray:objects];
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
    for (int ind = 0; ind < objects.count; ind++) {
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:ind inSection:0];
    [insertIndexPaths addObject:newPath];
    }
    [chatTable beginUpdates];
    [chatTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    [chatTable endUpdates];
    [chatTable reloadData];
    [chatTable scrollsToTop];
    } else {
    // Log details of the failure
    NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    }];
    }
    
    } else {
    // The request failed, we'll keep the chatData count?
    number = [chatData count];
    }
    }];
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

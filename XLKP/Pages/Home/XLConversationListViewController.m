//
//  XLHomeViewController.m
//  XLIM
//
//  Created by Facebook on 2017/11/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "XLConversationListViewController.h"
#import "XLConversationTableViewCell.h"
#import "XLConversationModel.h"
#import "ChatViewController.h"

@interface XLConversationListViewController ()<TIMMessageListener,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *conversationTableView;
@property(nonatomic,strong)NSMutableArray *conversationDataSocure;
@end

@implementation XLConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"聊天列表";
    [self initWithUI];
    [self loadDataSoucre];
    [[TIMManager sharedInstance]addMessageListener:self];
}

/**
 * 初始化UI
 **
 */
-(void)initWithUI{
    [self.view addSubview:self.conversationTableView];
    [self.conversationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view.safeAreaInsets);
    }];
}

/**
 * 获取本地会话列表
 **
 */
-(void)loadDataSoucre{
    __block NSString *signature =@"" ;
    __block NSString *updateTime =@"";
    NSArray *conversationList = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conversation in conversationList){
        XLConversationModel *messgeModel = [[XLConversationModel alloc]init];
        if ([conversation getType]  == TIM_SYSTEM) {        ///系统消息
            signature  = @"[系统消息]";
            messgeModel.coversationType = TIM_SYSTEM;
        }else if ([conversation getType] == TIM_C2C){       ///单聊消息
            [conversation getMessage:1 last:nil succ:^(NSArray *msgs) {
                if (msgs.count > 0) {
                    TIMMessage *elem = msgs[0];      ///获取最后一条消息
                    if(elem.isSelf) {       ///发送方
                        updateTime = [elem.timestamp shortTimeTextOfDate];
                    }else{      ///接受方
                        updateTime =  [elem.timestamp shortTimeTextOfDate];
                    }
                    TIMElem *elems = [elem getElem:0];
                    Class msg = [elems class];
                    if (msg == [TIMTextElem class]) {
                        TIMTextElem *IM_Text = (TIMTextElem *)elems;
                        signature = IM_Text.text;
                    }else if (msg ==  [TIMImageElem class]){
                        signature = @"[图片]";
                    }else if (msg == [TIMFileElem class]){
                        signature = @"[文件]";
                    }else if (msg == [TIMFaceElem class]){
                        signature = @"[表情]";
                    }else if (msg == [TIMSoundElem class]){
                        signature = @"[语音消息]";
                    }else if (msg == [TIMLocationElem class]){
                        signature = @"[位置]";
                    }else if (msg == [TIMCustomElem class]){
                        signature = @"[礼物消息]";
                    }else if (msg == [TIMUGCElem class]){
                        signature = @"[视频消息]";
                    }else if (msg == [TIMVideoElem class]){
                        signature = @"[视频]";
                    }
                    messgeModel.coversationType = TIM_C2C;
                }
                messgeModel.signature = signature;
                messgeModel.badgeValue = [self onUnReadMessag:[conversation getUnReadMessageNum]];
                
                ///UserInfo
                messgeModel.nickname = conversation.getReceiver;
                messgeModel.updated_at = updateTime;
                messgeModel.msgConv = conversation;
                messgeModel.rowHeight = 60.0;
                [self.conversationDataSocure addObject:messgeModel];
                [self.conversationTableView reloadData];
            } fail:^(int code, NSString *msg) {
                NSLog(@"获取本地消息失败%@",msg);
            }];
        }
    }
}


#warning 优化封装, 重复代码
- (void)onNewMessage:(NSArray *)msgs{
    NSString *signature =@"" ;
    NSString *updateTime =@"";
    if (msgs.count >0) {
        TIMMessage *msg = msgs[0];      ///获取最后一条消息
        if(msg.isSelf) {       ///发送方
            updateTime = [msg.timestamp shortTimeTextOfDate];
        }else{      ///接受方
            updateTime =  [msg.timestamp shortTimeTextOfDate];
        }
        TIMConversation *conversation = [msg getConversation];
        XLConversationModel *messgeModel = [[XLConversationModel alloc]init];
        for (int i = 0; i < [self.conversationDataSocure count]; i++){
            XLConversationModel *model = self.conversationDataSocure[i];
            NSString *imaconvReceiver = model.nickname;
            NSLog(@"getReceiver:%@ = imaconvReceiver:%@",[conversation getReceiver],imaconvReceiver);
            if ([[conversation getReceiver] isEqualToString:imaconvReceiver]) {         ///同一个会话消息
                if(msg.isSelf) {       ///发送方
                    updateTime = [msg.timestamp shortTimeTextOfDate];
                }else{      ///接受方
                    updateTime =  [msg.timestamp shortTimeTextOfDate];
                }
                if ([conversation getType]  == TIM_SYSTEM) {        ///系统消息
                    if (msg.elemCount == 0){
                        signature = @"[暂无系统消息]";
                    }else if (msg.elemCount > 1){
                        if ([msg isMemberOfClass:[TIMGroupSystemElem class]]){
                            signature = @"[群系统消息]";
                        }else if ([msg isMemberOfClass:[TIMSNSSystemElem class]]){
                            signature =@"[关系链变更消息]";
                        }
                    }
                    messgeModel.coversationType = TIM_SYSTEM;
                }else if ([conversation getType] == TIM_C2C){       ///单聊消息
                    if (msg.elemCount > 0){
                        TIMElem *elem = [msg getElem:0];
                        Class Tim_mesg = [elem class];
                        if (Tim_mesg == [TIMTextElem class]) {
                            TIMTextElem *IM_Text = (TIMTextElem *)elem;
                            signature = IM_Text.text;
                        }else if (Tim_mesg ==  [TIMImageElem class]){
                            signature = @"[图片]";
                        }else if (Tim_mesg == [TIMFileElem class]){
                            signature = @"[文件]";
                        }else if (Tim_mesg == [TIMFaceElem class]){
                            signature = @"[表情]";
                        }else if (Tim_mesg == [TIMSoundElem class]){
                            signature = @"[语音消息]";
                        }else if (Tim_mesg == [TIMLocationElem class]){
                            signature = @"[位置]";
                        }else if (Tim_mesg == [TIMCustomElem class]){
                            signature = @"[礼物消息]";
                        }else if (Tim_mesg == [TIMUGCElem class]){
                            signature = @"[视频消息]";
                        }else if (Tim_mesg == [TIMVideoElem class]){
                            signature = @"[视频]";
                        }
                    }
                    messgeModel.coversationType = TIM_C2C;
                }
                messgeModel.signature = signature;
                messgeModel.badgeValue = [self onUnReadMessag:[conversation getUnReadMessageNum]];
                messgeModel.nickname = conversation.getReceiver;
                messgeModel.updated_at = updateTime;
                messgeModel.rowHeight = 60.0;
                [self.conversationDataSocure removeObjectAtIndex:i];
                [self.conversationDataSocure insertObject:messgeModel atIndex:i];
            }
        }
        if (![self.conversationDataSocure containsObject:messgeModel]) {
            NSLog(@"新增会话");
            if(msg.isSelf) {       ///发送方
                updateTime = [msg.timestamp shortTimeTextOfDate];
            }else{      ///接受方
                updateTime =  [msg.timestamp shortTimeTextOfDate];
            }
            if ([conversation getType]  == TIM_SYSTEM) {        ///系统消息
                if (msg.elemCount == 0){
                    signature = @"[暂无系统消息]";
                }else if (msg.elemCount > 1){
                    if ([msg isMemberOfClass:[TIMGroupSystemElem class]]){
                        signature = @"[群系统消息]";
                    }else if ([msg isMemberOfClass:[TIMSNSSystemElem class]]){
                        signature =@"[关系链变更消息]";
                    }
                }
            }else if ([conversation getType] == TIM_C2C){       ///单聊消息
                if (msg.elemCount >0){
                    TIMElem *elem = [msg getElem:0];
                    Class Tim_mesg = [elem class];
                    if (Tim_mesg == [TIMTextElem class]) {
                        TIMTextElem *IM_Text = (TIMTextElem *)elem;
                        signature = IM_Text.text;
                    }else if (Tim_mesg ==  [TIMImageElem class]){
                        signature = @"[图片]";
                    }else if (Tim_mesg == [TIMFileElem class]){
                        signature = @"[文件]";
                    }else if (Tim_mesg == [TIMFaceElem class]){
                        signature = @"[表情]";
                    }else if (Tim_mesg == [TIMSoundElem class]){
                        signature = @"[语音消息]";
                    }else if (Tim_mesg == [TIMLocationElem class]){
                        signature = @"[位置]";
                    }else if (Tim_mesg == [TIMCustomElem class]){
                        signature = @"[礼物消息]";
                    }else if (Tim_mesg == [TIMUGCElem class]){
                        signature = @"[视频消息]";
                    }else if (Tim_mesg == [TIMVideoElem class]){
                        signature = @"[视频]";
                    }
                }
                messgeModel.coversationType = TIM_C2C;
            }
            messgeModel.signature = signature;
            messgeModel.badgeValue = [self onUnReadMessag:[conversation getUnReadMessageNum]];
            messgeModel.nickname = conversation.getReceiver;
            messgeModel.updated_at = updateTime;
            messgeModel.rowHeight = 60.0;
            [self.conversationDataSocure addObject:messgeModel];
        }
    }
    [self.conversationTableView reloadData];
}


#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLConversationModel *model = self.conversationDataSocure[indexPath.row];
    return model.rowHeight;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.conversationDataSocure.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLConversationTableViewCell *cell = [XLConversationTableViewCell CellWithTableView:tableView];
    XLConversationModel *model = self.conversationDataSocure[indexPath.row];
    [cell InitDataViewModel:model];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLConversationModel *model = self.conversationDataSocure[indexPath.row];
    switch (model.coversationType) {
        case TIM_C2C:{          //私聊
            ChatViewController *chat = [[ChatViewController alloc]init];
            chat.identifier  = model.nickname;
//            chat.remark = model.remark;   //备注
            chat.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chat animated:YES];
        }
            break;
        case TIM_GROUP:{       //群组
           
        }
        case TIM_SYSTEM:{      //系统
           
        }
            break;
        default:
            break;
    }
}

#pragma mark 删除会话

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    XLConversationModel *model = self.conversationDataSocure[indexPath.row];
    TIMConversation *conv = model.msgConv;
    switch (model.coversationType) {
        case TIM_C2C:{      //删除私聊
            [[TIMManager sharedInstance]deleteConversation:TIM_C2C receiver:[conv getReceiver]];
            [self.conversationDataSocure removeObject:model];
        }
            break;
        case TIM_GROUP:{       //删除群组消息
            [[TIMManager sharedInstance]deleteConversation:TIM_GROUP receiver:[conv getReceiver]];
            [self.conversationDataSocure removeObject:model];
        }
        case TIM_SYSTEM:{      ///删除系统消息
            [[TIMManager sharedInstance]deleteConversation:TIM_SYSTEM receiver:[conv getReceiver]];
            [self.conversationDataSocure removeObject:model];
        }
            break;
        default:
            break;
    }
    [self.conversationTableView reloadData];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UITableView *)conversationTableView{
    if (!_conversationTableView) {
        _conversationTableView= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _conversationTableView.showsVerticalScrollIndicator =NO;
        _conversationTableView.showsHorizontalScrollIndicator =NO;
        _conversationTableView.dataSource = self;
        _conversationTableView.delegate = self;
        _conversationTableView.tableFooterView  =[UIView new];
        _conversationTableView.estimatedRowHeight = 0;
        _conversationTableView.estimatedSectionFooterHeight = 0;
        _conversationTableView.estimatedSectionHeaderHeight = 0;
        _conversationTableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
        if ([_conversationTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_conversationTableView setSeparatorInset:inset];
        }
        if ([_conversationTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_conversationTableView setLayoutMargins:inset];
        }
    }
    return _conversationTableView;
}

-(NSMutableArray *)conversationDataSocure{
    if (!_conversationDataSocure) {
        _conversationDataSocure = [NSMutableArray arrayWithCapacity:0];
    }
    return _conversationDataSocure;
}


///MARK: 未读消息数
- (NSString *)onUnReadMessag:(int)unRead{
    NSString *badge = @"";
    if (unRead > 0 && unRead <= 99){
        badge = [NSString stringWithFormat:@"%d", (int)unRead];
    }else if (unRead > 99){
        badge = @"99+";
    }
    return badge;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end



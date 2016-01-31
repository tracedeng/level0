//
//  Constance.h
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#ifndef Constance_h
#define Constance_h

#ifdef DEBUG
#define ACCOUNTURL @"http://localhost:8000/account"
#define CONSUMERURL @"http://localhost:8000/consumer"
#define MERCHANTURL @"http://localhost:8000/merchant"
#define CREDITURL @"http://localhost:8000/credit"
#define FLOWTURL @"http://localhost:8000/flow"
#define QINIUURL @"http://7xor5x.com1.z0.glb.clouddn.com"
#define BUSINESSURL @"http://localhost:8000/business"
#define FLOWURL @"http://localhost:8000/flow"
#define DISCOUNTURL @"http://localhost:8000/activity"
#define ACTIVITYURL @"http://localhost:8000/activity"
#define VOUCHERURL @"http://localhost:8000/voucher"
//
//#define ACCOUNTURL @"http://192.168.1.3:8000/account"
//#define CONSUMERURL @"http://192.168.1.3:8000/consumer"
//#define MERCHANTURL @"http://192.168.1.3:8000/merchant"
//#define CREDITURL @"http://192.168.1.3:8000/credit"
//#define FLOWTURL @"http://192.168.1.3:8000/flow"
//#define QINIUURL @"http://7xor5x.com1.z0.glb.clouddn.com"
//#define BUSINESSURL @"http://192.168.1.3:8000/business"
//#define FLOWURL @"http://192.168.1.3:8000/flow"
//#define DISCOUNTURL @"http://192.168.1.3:8000/activity"
//#define ACTIVITYURL @"http://192.168.1.3:8000/activity"
//#define VOUCHERURL @"http://192.168.1.3:8000/voucher"
#else
#define CONSUMERURL @"http://www.weijifen.me:8000/consumer"
#define MERCHANTURL @"http://www.weijifen.me:8000/merchant"
#define CREDITURL @"http://www.weijifen.me:8000/credit"
#define FLOWTURL @"http://www.weijifen.me:8000/flow"
#endif

#endif /* Constance_h */



const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
const firestore = admin.firestore()


//push通知実行メソッド
const pushMessage = (fcmToken, text) => ({
    notification: {
        title: '新しいメッセージがあります',
        body:  `${text}`,
    },
    apns: {
        headers: {
            'apns-priority': '10'
        },
        payload: {
            aps: {
                badge: 9999,
                sound: 'default'
            }
        }
    },
    data: {
        data: 'test',
    },
    token: fcmToken
  });


exports.sendMessage = functions.firestore.document('users/{fcmToken}/post/{postId}').onCreate(async (snapshot, context) => {
    const fcmToken = snapshot.data()['fcmToken'];
    const text = snapshot.data()['text'];
    try {pushMessage(fcmToken, text);} catch (e) {console.log(e);}
});
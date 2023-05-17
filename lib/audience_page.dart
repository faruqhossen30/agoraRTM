import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String appId = '0b8c1e8e74de4766827c83420a8ac6a2';

class AudiencePage extends StatefulWidget {
  static String routeName = '/audience';
  const AudiencePage({Key? key}) : super(key: key);

  @override
  State<AudiencePage> createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  late AgoraRtmClient _client;
  late AgoraRtmChannel _channel;
  List<String> msg = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createClient();
  }

  void _createClient()async{
    _client = await AgoraRtmClient.createInstance(appId);

    _client.onConnectionStateChanged=(int state, int reason){
      Fluttertoast.showToast(msg: 'state is = ${state}');
      print('state${state}');
      if(state==5){
        _client.logout();
      }
    };

    _client.login('0060b8c1e8e74de4766827c83420a8ac6a2IAAYbV67Ywy6Bdudx37a4Q1FjWW3Dtk0gi7RPQpSp/200O/UWBUAAAAAEABiOAEAjZJlZAEA6AONkmVk', 'user2');

    _channel = await _createChannel('test');
    await _channel.join();

    print('RTM join successfully: test');

    _channel.onMessageReceived=(AgoraRtmMessage message, AgoraRtmMember member){
      setState(() {
        msg.add(message.text);

      });

      Fluttertoast.showToast(msg: 'onMessageReceived:${message.text}');
      print('onMessageReceived${message.text}');
    };
    

  }

  Future<AgoraRtmChannel> _createChannel(String channelName)async{
    AgoraRtmChannel? channel = await _client.createChannel(channelName);

    channel!.onMemberJoined=(AgoraRtmMember member){
        Fluttertoast.showToast(msg: 'onMemberJoined${member.userId}');
        print('onMemberJoined${member.userId}');
    };
    channel!.onMemberLeft=(AgoraRtmMember member){
      Fluttertoast.showToast(msg: 'onMemberLeft${member.userId}');
      print('onMemberLeft${member.userId}');
    };

    return channel;
  }
  // final ScrollController _controller = ScrollController();
  //
  // void _scrollDown() {
  //   _controller.jumpTo(_controller.position.maxScrollExtent);
  // }


  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audience'),),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple, Colors.blueAccent])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: msg.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 5.sp, vertical: 2.sp),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Faruq Hossen:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Text(
                            msg[index].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.mail_outline,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            try{
                              _messageController.clear();
                              await _channel.sendMessage(AgoraRtmMessage.fromText(_messageController.text));
                              setState(() {
                                msg.add(_messageController.text);
                              });

                            }catch(e){
                              print('error');
                              print(e);
                            }
                          },
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.sp),
                            borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.zero),
                  ),

                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    Icons.heart_broken,
                    color: Colors.pink,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    Icons.card_giftcard,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


}

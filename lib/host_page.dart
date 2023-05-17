import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realtimemessagin/gift_modal.dart';

const String appId = '0b8c1e8e74de4766827c83420a8ac6a2';

class HostPage extends StatefulWidget {
  static String routeName = '/host';

  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  late AgoraRtmClient _client;
  late AgoraRtmChannel _channel;

  List<String> msg = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createClient();
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(appId);

    _client.onConnectionStateChanged = (int state, int reason) {
      Fluttertoast.showToast(msg: 'state is = ${state}');
      print('state${state}');
      if (state == 5) {
        _client.logout();
      }
    };

    _client.login(
        '0060b8c1e8e74de4766827c83420a8ac6a2IAD8xVwXKeUBINHEJfABGZ6P/2EQmMzR1IAaUCgmVkNxpVWFUYwAAAAAEABaSwEAIYBlZAEA6AMhgGVk',
        'user1');

    _channel = await _createChannel('test');
    await _channel.join();

    print('RTM join successfully: test');

    _channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      setState(() {
        msg.add(message.text);
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(microseconds: 300), curve: Curves.easeOut);
      });


      Fluttertoast.showToast(msg: 'onMessageReceived:${message.text}');
      print('onMessageReceived${message.text}');
    };
  }

  Future<AgoraRtmChannel> _createChannel(String channelName) async {
    AgoraRtmChannel? channel = await _client.createChannel(channelName);

    channel!.onMemberJoined = (AgoraRtmMember member) {
      Fluttertoast.showToast(msg: 'onMemberJoined${member.userId}');
      print('onMemberJoined${member.userId}');
    };
    channel!.onMemberLeft = (AgoraRtmMember member) {
      Fluttertoast.showToast(msg: 'onMemberLeft${member.userId}');
      print('onMemberLeft${member.userId}');
    };

    return channel;
  }

  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('host'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple, Colors.blueAccent])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: msg.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Wrap(
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
                            try {
                              _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(microseconds: 300), curve: Curves.easeOut);

                              await _channel.sendMessage(AgoraRtmMessage.fromText(_messageController.text));
                              setState(() {
                                msg.add(_messageController.text);
                              });
                              _messageController.clear();
                            } catch (e) {
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
                  onPressed: () async{
                    await giftModal(context);
                  },
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

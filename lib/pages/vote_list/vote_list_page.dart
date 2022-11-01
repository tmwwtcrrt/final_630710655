import 'package:flutter/material.dart';
import 'package:final_630710655/models/fifa_item.dart';
import 'package:final_630710655/services/api.dart';

class VoteListPage extends StatefulWidget {
  const VoteListPage({Key? key}) : super(key: key);

  @override
  State<VoteListPage> createState() => _VoteListPageState();
}

class _VoteListPageState extends State<VoteListPage> {
  List<FifaItem>? _fifaList;
  var _isLoading = false;
  String? _errMessage;

  @override
  void initState() {
    super.initState();
    _fetchVoteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VOTE RESULT')),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/bg.png',
            fit: BoxFit.cover,
            ),Padding(padding: const EdgeInsets.all(10.0),
              child: new Container(
                height: 50.0,
                width: 50.0,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage('assets/images/logo.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(child: Stack(
              children: [
                if(_fifaList != null)
                  ListView.builder(
                    itemBuilder: _buildListItem,
                    itemCount: _fifaList!.length,
                  ),
                if(_isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: const EdgeInsets.all(24.0),
                        child: Text(_errMessage!),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            _fetchVoteData();
                          },
                          child: const Text('RETRY'),
                        )
                      ],
                    ),
                  ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
  void _fetchVoteData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var data = await Api().fetch('foods');
      setState(() {
        _fifaList = data
            .map<FifaItem>((item) => FifaItem.fromJson(item))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildListItem(BuildContext context, int index) {
    var FifaItem = _fifaList![index];

    return Card(
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Image.network(
              FifaItem.flagImage,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8.0),
            Text(FifaItem.team),
          ],
        ),
      ),
    );
  }
}

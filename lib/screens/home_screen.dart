import 'package:flutter/material.dart';
import 'package:newstube/models/channel_model.dart';
import 'package:newstube/models/video_model.dart';
import 'package:newstube/screens/video_screen.dart';
import 'package:newstube/services/api_service.dart';
import 'package:newstube/utilities/channels.dart';
import 'package:newstube/screens/dailog_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Channel _newschannel;
  Channel _techchannel;
  Channel _filmchannel;
  String newsTitle = 'ETV Telangana';
  String filmTitle = 'TV9 Entertainment';
  String techTitle = 'Prasadtechintelugu';
  bool _isLoading = false;
  bool nChannelLoading = false;
  bool tChannelLoading = false;
  bool fChannelLoading = false;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _initNewsChannel(news[newsTitle]);
    _initFilmChannel(film[filmTitle]);
    _initTechChannel(tech[techTitle]);
  }

  _initNewsChannel(String id) async {
    setState(() {
      nChannelLoading = true;
    });
    Channel channel = await APIService().fetchChannel(channelId: id);
    setState(() {
      _newschannel = channel;
      nChannelLoading = false;
    });
  }

  _initFilmChannel(String id) async {
    setState(() {
      fChannelLoading = true;
    });
    Channel tchannel = await APIService().fetchChannel(channelId: id);
    setState(() {
      _filmchannel = tchannel;
      fChannelLoading = false;
    });
  }

  _initTechChannel(String id) async {
    setState(() {
      tChannelLoading = true;
    });
    Channel tchannel = await APIService().fetchChannel(channelId: id);
    setState(() {
      _techchannel = tchannel;
      tChannelLoading = false;
    });
  }

  _buildProfileInfo(int n) {
    if (n == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Channel : ',
            style:
                TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6)),
          ),
          DropdownButton<String>(
            value: newsTitle,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.red,
            ),
            onChanged: (String newValue) {
              setState(() {
                newsTitle = newValue;
                _initNewsChannel(news[newsTitle]);
              });
            },
            items: news.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              _initNewsChannel(news[newsTitle]);
            },
            iconSize: 30.0,
            icon: Icon(Icons.refresh),
            color: Colors.black.withOpacity(0.7),
          ),
        ],
      );
    } else if (n == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Channel : ',
            style:
                TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6)),
          ),
          DropdownButton<String>(
            value: filmTitle,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.red,
            ),
            onChanged: (String newValue) {
              setState(() {
                filmTitle = newValue;
                _initFilmChannel(film[filmTitle]);
              });
            },
            items: film.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          IconButton(
            onPressed: () {
              _initFilmChannel(film[filmTitle]);
            },
            iconSize: 30.0,
            icon: Icon(Icons.refresh),
            color: Colors.black.withOpacity(0.7),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Channel : ',
            style:
                TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6)),
          ),
          DropdownButton<String>(
            value: techTitle,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.red,
            ),
            onChanged: (String newValue) {
              setState(() {
                techTitle = newValue;
                _initTechChannel(tech[techTitle]);
              });
            },
            items: tech.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          IconButton(
            onPressed: () {
              _initTechChannel(tech[techTitle]);
            },
            iconSize: 30.0,
            icon: Icon(Icons.refresh),
            color: Colors.black.withOpacity(0.7),
          ),
        ],
      );
    }
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: EdgeInsets.all(3.0),
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.77,
              child: Image(
                fit: BoxFit.fill,
                image: NetworkImage(video.thumbnailUrl),
              ),
            ),
            SizedBox(height: 10),
            Text(
              video.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 0.8,
              color: Colors.black.withOpacity(0.5),
            )
          ],
        ),
      ),
    );
  }

  _loadMoreVideos(Channel channel) async {
    _isLoading = true;
    List<Video> moreVideos =
        await APIService().fetchVideosFromPlaylist(channel);
    List<Video> allVideos = channel.videos..addAll(moreVideos);
    setState(() {
      channel.videos = allVideos;
    });
    _isLoading = false;
  }

  _getTabView(int n) {
    if (n == 0) {
      if (_newschannel != null &&
          _newschannel.title == newsTitle &&
          !nChannelLoading) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollDetails) {
            if (!_isLoading &&
                _newschannel.videos.length !=
                    int.parse(_newschannel.videoCount) &&
                scrollDetails.metrics.pixels ==
                    scrollDetails.metrics.maxScrollExtent) {
              _loadMoreVideos(_newschannel);
            }
            return false;
          },
          child: Column(
            children: <Widget>[
              _buildProfileInfo(0),
              new Expanded(
                child: ListView.builder(
                  itemCount: _newschannel.videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    Video video = _newschannel.videos[index];
                    return _buildVideo(video);
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor, // Red
            ),
          ),
        );
      }
    } else if (n == 1) {
      if (_filmchannel != null &&
          _filmchannel.title == filmTitle &&
          !fChannelLoading) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollDetails) {
            if (!_isLoading &&
                _filmchannel.videos.length !=
                    int.parse(_filmchannel.videoCount) &&
                scrollDetails.metrics.pixels ==
                    scrollDetails.metrics.maxScrollExtent) {
              _loadMoreVideos(_filmchannel);
            }
            return false;
          },
          child: Column(
            children: <Widget>[
              _buildProfileInfo(1),
              new Expanded(
                child: ListView.builder(
                  itemCount: _filmchannel.videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    Video video = _filmchannel.videos[index];
                    return _buildVideo(video);
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor, // Red
            ),
          ),
        );
      }
    } else {
      if (_techchannel != null &&
          _techchannel.title == techTitle &&
          !tChannelLoading) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollDetails) {
            if (!_isLoading &&
                _techchannel.videos.length !=
                    int.parse(_techchannel.videoCount) &&
                scrollDetails.metrics.pixels ==
                    scrollDetails.metrics.maxScrollExtent) {
              _loadMoreVideos(_techchannel);
            }
            return false;
          },
          child: Column(
            children: <Widget>[
              _buildProfileInfo(2),
              new Expanded(
                child: ListView.builder(
                  itemCount: _techchannel.videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    Video video = _techchannel.videos[index];
                    return _buildVideo(video);
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor, // Red
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 5.5),
          child: AppBar(
            backgroundColor: Colors.grey[200],
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: GestureDetector(
                onTap: () {
                  FutureDialog.showToast();
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "      Search here",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.4),
                                  fontSize: 15.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: IconButton(
                            onPressed: () {
                              FutureDialog.showFutureDialogue(context);
                            },
                            iconSize: 30.0,
                            icon: Icon(Icons.search)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.black54,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.4),
              tabs: <Widget>[
                getTab('News'),
                getTab('Film News'),
                getTab('Tech News')
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _getTabView(0),
            _getTabView(1),
            _getTabView(2),
          ],
        ),
      ),
    );
  }

  Tab getTab(String name) {
    return Tab(
      child: Container(
        child: Text(
          name,
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

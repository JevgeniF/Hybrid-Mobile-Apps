class SongInfo {
  final String artist;
  final String title;

  SongInfo({required this.artist, required this.title});

  factory SongInfo.fromJson(Map<String, dynamic> jsonObject) {
    // ignore: non_constant_identifier_names
    var SongHistoryList = jsonObject['SongHistoryList'];
    if (SongHistoryList == null) {
      return SongInfo(artist: 'bad', title: 'luck');
    }
    var currentSong = SongHistoryList[0];
    if (currentSong == null) {
      return SongInfo(artist: 'bad', title: 'luck');
    }

    return SongInfo(
      artist: currentSong['Artist'] ?? 'bad',
      title: currentSong['Title'] ?? 'luck');
  }
}

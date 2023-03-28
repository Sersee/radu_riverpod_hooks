class GetImagesUrl {
  static List<String> picsum() {
    List<String> urlList = [];
    for (var i=1; i<20; i=i+2)
      {
        urlList.add('https://placeimg.com/300/300/$i');
      }
    return urlList;
  }
}
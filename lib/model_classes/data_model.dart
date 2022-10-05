


class COCOExplorerData{

  List<ImageData>? imagesByID;
  List<ImagesSegment>? imagesSegment;
  List<ImagesCaptions>? imagesCaptions;
  COCOExplorerData({required this.imagesByID, required this.imagesCaptions, required this.imagesSegment});

  COCOExplorerData.fromJson(Map<String, dynamic> json) {
    imagesByID = json['imagesByID'];
    imagesSegment = json['imagesSegment'];
    imagesCaptions = json['imagesCaptions'];
  }
}





class ImageData {
  int? id;
  String? cocoUrl;
  String? flickrUrl;

  ImageData({this.id, this.cocoUrl, this.flickrUrl});

  ImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cocoUrl = json['coco_url'];
    flickrUrl = json['flickr_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coco_url'] = this.cocoUrl;
    data['flickr_url'] = this.flickrUrl;
    return data;
  }
}



class ImagesSegment {
  int? imageId;
  String? segmentation;
  int? categoryId;

  ImagesSegment({this.imageId, this.segmentation, this.categoryId});

  ImagesSegment.fromJson(Map<String, dynamic> json) {
    imageId = json['image_id'];
    segmentation = json['segmentation'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_id'] = this.imageId;
    data['segmentation'] = this.segmentation;
    data['category_id'] = this.categoryId;
    return data;
  }
}



class ImagesCaptions {
  String? caption;
  int? imageId;

  ImagesCaptions({this.caption, this.imageId});

  ImagesCaptions.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    imageId = json['image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caption'] = this.caption;
    data['image_id'] = this.imageId;
    return data;
  }
}
import 'package:assessment/model_classes/data_model.dart';

class ImageObjectModel {
  late ImageData imageData;
  late List<ImagesSegment> imagesSegment;
  late List<ImagesCaptions> imagesCaptions;

  ImageObjectModel(
      {required this.imageData,
      required this.imagesCaptions,
      required this.imagesSegment});

  ImageObjectModel.fromJson(Map<String, dynamic> json) {
    imageData = (json["imageData"] != null
        ? ImageData.fromJson(json["imageData"])
        : null)!;

    if (json['imagesSegment'] != null) {
      imagesSegment = <ImagesSegment>[];
      json['imagesSegment'].forEach((v) {
        imagesSegment.add(new ImagesSegment.fromJson(v));
      });
    }

    if (json['imagesCaptions'] != null) {
      imagesCaptions = <ImagesCaptions>[];
      json['imagesCaptions'].forEach((v) {
        imagesCaptions.add(new ImagesCaptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["imageData"] = imageData.toJson();

    data['imagesSegment'] = this.imagesSegment.map((v) => v.toJson()).toList();
    data['imagesCaptions'] =
        this.imagesCaptions.map((v) => v.toJson()).toList();
    return data;
  }
}

class EventModelClass {
  List<Events>? events;
  Meta? meta;

  EventModelClass({this.events, this.meta});

  EventModelClass.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) { events!.add(new Events.fromJson(v)); });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Events {
  String? type;
  int? id;
  String? datetimeUtc;
  Venue? venue;
  bool? datetimeTbd;
  List<Performers>? performers;
  bool? isOpen;
  List? links;
  String? datetimeLocal;
  bool? timeTbd;
  String? shortTitle;
  String? visibleUntilUtc;
  Stats? stats;
  List<Taxonomies>? taxonomies;
  String? url;
  double? score;
  String? announceDate;
  String? createdAt;
  bool? dateTbd;
  String? title;
  double? popularity;
  String? description;
  String? status;
  var accessMethod;
  var eventPromotion;
  Announcements? announcements;
  bool? conditional;
  var enddatetimeUtc;
  List<Null>? themes;
  List<Null>? domainInformation;

  Events({this.type, this.id, this.datetimeUtc, this.venue, this.datetimeTbd, this.performers, this.isOpen, this.links, this.datetimeLocal, this.timeTbd, this.shortTitle, this.visibleUntilUtc, this.stats, this.taxonomies, this.url, this.score, this.announceDate, this.createdAt, this.dateTbd, this.title, this.popularity, this.description, this.status, this.accessMethod, this.eventPromotion, this.announcements, this.conditional, this.enddatetimeUtc, this.themes, this.domainInformation});

  Events.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    datetimeUtc = json['datetime_utc'];
    venue = json['venue'] != null ? new Venue.fromJson(json['venue']) : null;
    datetimeTbd = json['datetime_tbd'];
    if (json['performers'] != null) {
      performers = <Performers>[];
      json['performers'].forEach((v) { performers!.add(new Performers.fromJson(v)); });
    }
    isOpen = json['is_open'];
    if (json['links'] != null) {
      links = [];
    }
    datetimeLocal = json['datetime_local'];
    timeTbd = json['time_tbd'];
    shortTitle = json['short_title'];
    visibleUntilUtc = json['visible_until_utc'];
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    if (json['taxonomies'] != null) {
      taxonomies = <Taxonomies>[];
      json['taxonomies'].forEach((v) { taxonomies!.add(new Taxonomies.fromJson(v)); });
    }
    url = json['url'];
    score = double.parse(json['score'].toString());
    announceDate = json['announce_date'];
    createdAt = json['created_at'];
    dateTbd = json['date_tbd'];
    title = json['title'];
    popularity = double.parse(json['popularity'].toString());
    description = json['description'];
    status = json['status'];
    accessMethod = json['access_method'];
    eventPromotion = json['event_promotion'];
    announcements = json['announcements'] != null ? new Announcements.fromJson(json['announcements']) : null;
    conditional = json['conditional'];
    enddatetimeUtc = json['enddatetime_utc'];
    if (json['themes'] != null) {
      themes = [];
    }
    if (json['domain_information'] != null) {
      domainInformation = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['datetime_utc'] = this.datetimeUtc;
    if (this.venue != null) {
      data['venue'] = this.venue!.toJson();
    }
    data['datetime_tbd'] = this.datetimeTbd;
    if (this.performers != null) {
      data['performers'] = this.performers!.map((v) => v.toJson()).toList();
    }
    data['is_open'] = this.isOpen;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['datetime_local'] = this.datetimeLocal;
    data['time_tbd'] = this.timeTbd;
    data['short_title'] = this.shortTitle;
    data['visible_until_utc'] = this.visibleUntilUtc;
    if (this.stats != null) {
      data['stats'] = this.stats!.toJson();
    }
    if (this.taxonomies != null) {
      data['taxonomies'] = this.taxonomies!.map((v) => v.toJson()).toList();
    }
    data['url'] = this.url;
    data['score'] = this.score;
    data['announce_date'] = this.announceDate;
    data['created_at'] = this.createdAt;
    data['date_tbd'] = this.dateTbd;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    data['description'] = this.description;
    data['status'] = this.status;
    data['access_method'] = this.accessMethod;
    data['event_promotion'] = this.eventPromotion;
    if (this.announcements != null) {
      data['announcements'] = this.announcements!.toJson();
    }
    data['conditional'] = this.conditional;
    data['enddatetime_utc'] = this.enddatetimeUtc;
    if (this.themes != null) {
      data['themes'] = [];
    }
    if (this.domainInformation != null) {
      data['domain_information'] = [];
    }
    return data;
  }
}

class Venue {
  String? state;
  String? nameV2;
  String? postalCode;
  String? name;
  List<Null>? links;
  String? timezone;
  String? url;
  double? score;
  Location? location;
  String? address;
  String? country;
  bool? hasUpcomingEvents;
  int? numUpcomingEvents;
  String? city;
  String? slug;
  String? extendedAddress;
  int? id;
  int? popularity;
  var accessMethod;
  int? metroCode;
  int? capacity;
  String? displayLocation;

  Venue({this.state, this.nameV2, this.postalCode, this.name, this.links, this.timezone, this.url, this.score, this.location, this.address, this.country, this.hasUpcomingEvents, this.numUpcomingEvents, this.city, this.slug, this.extendedAddress, this.id, this.popularity, this.accessMethod, this.metroCode, this.capacity, this.displayLocation});

  Venue.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    nameV2 = json['name_v2'];
    postalCode = json['postal_code'];
    name = json['name'];
    if (json['links'] != null) {
      links = [];
    }
    timezone = json['timezone'];
    url = json['url'];
    score = double.parse(json['score'].toString());
    location = json['location'] != null ? new Location.fromJson(json['location']) : null;
    address = json['address'];
    country = json['country'];
    hasUpcomingEvents = json['has_upcoming_events'];
    numUpcomingEvents = json['num_upcoming_events'];
    city = json['city'];
    slug = json['slug'];
    extendedAddress = json['extended_address'];
    id = json['id'];
    popularity = json['popularity'];
    accessMethod = json['access_method'];
    metroCode = json['metro_code'];
    capacity = json['capacity'];
    displayLocation = json['display_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['name_v2'] = this.nameV2;
    data['postal_code'] = this.postalCode;
    data['name'] = this.name;
    if (this.links != null) {
      data['links'] = [];
    }
    data['timezone'] = this.timezone;
    data['url'] = this.url;
    data['score'] = this.score;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['address'] = this.address;
    data['country'] = this.country;
    data['has_upcoming_events'] = this.hasUpcomingEvents;
    data['num_upcoming_events'] = this.numUpcomingEvents;
    data['city'] = this.city;
    data['slug'] = this.slug;
    data['extended_address'] = this.extendedAddress;
    data['id'] = this.id;
    data['popularity'] = this.popularity;
    data['access_method'] = this.accessMethod;
    data['metro_code'] = this.metroCode;
    data['capacity'] = this.capacity;
    data['display_location'] = this.displayLocation;
    return data;
  }
}

class Location {
  double? lat;
  double? lon;

  Location({this.lat, this.lon});

  Location.fromJson(Map<String, dynamic> json) {
    lat = double.parse(json['lat'].toString());
    lon = double.parse(json['lon'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}

class Performers {
  String? type;
  String? name;
  String? image;
  int? id;
  Images? images;
  var divisions;
  bool? hasUpcomingEvents;
  bool? primary;
  Stats? stats;
  List<Taxonomies>? taxonomies;
  String? imageAttribution;
  String? url;
  double? score;
  String? slug;
  var homeVenueId;
  String? shortName;
  int? numUpcomingEvents;
  var colors;
  String? imageLicense;
  List<Genres>? genres;
  int? popularity;
  Location? location;
  String? imageRightsMessage;

  Performers({this.type, this.name, this.image, this.id, this.images, this.divisions, this.hasUpcomingEvents, this.primary, this.stats, this.taxonomies, this.imageAttribution, this.url, this.score, this.slug, this.homeVenueId, this.shortName, this.numUpcomingEvents, this.colors, this.imageLicense, this.genres, this.popularity, this.location, this.imageRightsMessage});

  Performers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    image = json['image'];
    id = json['id'];
    images = json['images'] != null ? new Images.fromJson(json['images']) : null;
    divisions = json['divisions'];
    hasUpcomingEvents = json['has_upcoming_events'];
    primary = json['primary'];
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    if (json['taxonomies'] != null) {
      taxonomies = <Taxonomies>[];
      json['taxonomies'].forEach((v) { taxonomies!.add(new Taxonomies.fromJson(v)); });
    }
    imageAttribution = json['image_attribution'];
    url = json['url'];
    score = double.parse(json['score'].toString());
    slug = json['slug'];
    homeVenueId = json['home_venue_id'];
    shortName = json['short_name'];
    numUpcomingEvents = json['num_upcoming_events'];
    colors = json['colors'];
    imageLicense = json['image_license'];
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) { genres!.add(new Genres.fromJson(v)); });
    }
    popularity = json['popularity'];
    location = (json["location"] != null
        ? Location.fromJson(json["location"])
        : null);
    imageRightsMessage = json['image_rights_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['image'] = this.image;
    data['id'] = this.id;
    if (this.images != null) {
      data['images'] = this.images!.toJson();
    }
    data['divisions'] = this.divisions;
    data['has_upcoming_events'] = this.hasUpcomingEvents;
    data['primary'] = this.primary;
    if (this.stats != null) {
      data['stats'] = this.stats!.toJson();
    }
    if (this.taxonomies != null) {
      data['taxonomies'] = this.taxonomies!.map((v) => v.toJson()).toList();
    }
    data['image_attribution'] = this.imageAttribution;
    data['url'] = this.url;
    data['score'] = this.score;
    data['slug'] = this.slug;
    data['home_venue_id'] = this.homeVenueId;
    data['short_name'] = this.shortName;
    data['num_upcoming_events'] = this.numUpcomingEvents;
    data['colors'] = this.colors;
    data['image_license'] = this.imageLicense;
    if (this.genres != null) {
      data['genres'] = this.genres!.map((v) => v.toJson()).toList();
    }
    data['popularity'] = this.popularity;
    data['location'] = this.location;
    data['image_rights_message'] = this.imageRightsMessage;
    return data;
  }
}

class Images {
  String? huge;

  Images({this.huge});

  Images.fromJson(Map<String, dynamic> json) {
    huge = json['huge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['huge'] = this.huge;
    return data;
  }
}

class Stats {
  int? eventCount;

  Stats({this.eventCount});

  Stats.fromJson(Map<String, dynamic> json) {
    eventCount = json['event_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_count'] = this.eventCount;
    return data;
  }
}

class Taxonomies {
  int? id;
  String? name;
  int? parentId;
  DocumentSource? documentSource;
  int? rank;

  Taxonomies({this.id, this.name, this.parentId, this.documentSource, this.rank});

  Taxonomies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    documentSource = json['document_source'] != null ? new DocumentSource.fromJson(json['document_source']) : null;
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    if (this.documentSource != null) {
      data['document_source'] = this.documentSource!.toJson();
    }
    data['rank'] = this.rank;
    return data;
  }
}

class DocumentSource {
  String? sourceType;
  String? generationType;

  DocumentSource({this.sourceType, this.generationType});

  DocumentSource.fromJson(Map<String, dynamic> json) {
    sourceType = json['source_type'];
    generationType = json['generation_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source_type'] = this.sourceType;
    data['generation_type'] = this.generationType;
    return data;
  }
}

class Genres {
  int? id;
  String? name;
  String? slug;
  bool? primary;
  Images? images;
  String? image;
  DocumentSource? documentSource;

  Genres({this.id, this.name, this.slug, this.primary, this.images, this.image, this.documentSource});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    primary = json['primary'];
    images = json['images'] != null ? new Images.fromJson(json['images']) : null;
    image = json['image'];
    documentSource = json['document_source'] != null ? new DocumentSource.fromJson(json['document_source']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['primary'] = this.primary;
    if (this.images != null) {
      data['images'] = this.images!.toJson();
    }
    data['image'] = this.image;
    if (this.documentSource != null) {
      data['document_source'] = this.documentSource!.toJson();
    }
    return data;
  }
}





class Announcements {




Announcements.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}

class Meta {
  int? total;
  int? took;
  int? page;
  int? perPage;
  Null geolocation;

  Meta({this.total, this.took, this.page, this.perPage, this.geolocation});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    took = json['took'];
    page = json['page'];
    perPage = json['per_page'];
    geolocation = json['geolocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['took'] = this.took;
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['geolocation'] = this.geolocation;
    return data;
  }
}
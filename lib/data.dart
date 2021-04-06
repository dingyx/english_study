class WordBean {

  int id;
  String translate;
  String word;

  WordBean({this.id, this.translate, this.word});

  WordBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translate = json['translate'];
    word = json['word'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['translate'] = this.translate;
    data['word'] = this.word;
    return data;
  }
}



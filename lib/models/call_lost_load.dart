
class LostLoad {
  int code= 0;
  String reason= '';

  LostLoad({
     this.code,
     this.reason,
  });

  factory LostLoad.fromJson(Map<String, dynamic> json) {
    return LostLoad(
       code: json['id'],
       reason: json['call_lost'],
    );
}
}

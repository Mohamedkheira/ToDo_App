class User{
  static const String collectionName = "user";
  String? id;
  String? fullName;
  String? userName;
  String? email;
  String? imageURL;

  User({
    this.id,
    this.fullName,
    this.userName,
    this.email,
    this.imageURL,
});

  User.fromFirestore(Map<String,dynamic>? data){
    id = data?["id"];
    fullName = data?["fullName"];
    userName = data?["userName"];
    email = data?["email"];
    imageURL = data?["imageURL"];

  }

   Map<String,dynamic>toFirestore(){
    return {
      "id": id,
      "fullName": fullName,
      "userName":userName,
      "email":email,
      "imageURL":imageURL,
    };
  }
}
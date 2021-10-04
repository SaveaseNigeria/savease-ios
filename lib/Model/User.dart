
class User {

  String balance;
  String saveaseID;
  String lname;
  String fname;
  String phone;
  String email;


      User({

    this.balance,
        this.saveaseID,
        this.lname,
        this.fname,
        this.phone,
        this.email

    });


      factory User.fromJson(Map<String,dynamic> json){
        return User(

          balance: json['balance'],
          saveaseID: json['saveaseID'],
          fname: json['fname'],
          lname: json['lname'],
          phone: json['phone'],
          email: json['email'],

        );
      }


}
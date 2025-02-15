// Side Note - on your product class when you add to product table get the university of such user then also add it to every product hey upload

// This will be a class where I retrieve he books from the product table
// taking the product_name - price - quantity - university



class Books{
  String name;
  String id;
  String price;
  String quantity;
  String imagePath;
  String image1;
  String image2;
  String image3;

  String university;

  Books({
    required this.name,
    required this.id,
    required this.price,
    required this.quantity,
    required this.imagePath,
    required this.university,
    required this.image1,
    required this.image2,
    required this.image3,
    });


  String get _name => name;
  String get _id => id;
  String get _price => price;
  String get _quantity => quantity;
  String get _imagePath => imagePath;
  String get _image1 => image1;

  String get _image2 => image2;
  String get _image3 => image3;
  String get _university => university;
}


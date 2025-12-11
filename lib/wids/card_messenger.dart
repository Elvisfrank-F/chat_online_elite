import 'package:flutter/material.dart';


class CardMessenger extends StatelessWidget {

  final String? photoURL;
  final String? name;
  final String? text;
  final String? imgURL;
  final bool isMy;

  const CardMessenger({super.key, required this.photoURL, required this.name, required this.text, this.imgURL, required this.isMy});

  @override
  Widget build(BuildContext context) {
    return isMy? userMensenger(context) : otherMensenger(context);
  }

  Widget userMensenger(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.5,
      // height: MediaQuery.of(context).size. * 0.5,

      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [





                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,

                            image: photoURL != null ? NetworkImage(photoURL!)
                                :
                            AssetImage("assets/person.jpeg")
                        )
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(


                      child: Text(
                        name != null ? name!.split(" ").first : "Invalid name",
                        style: TextStyle(fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),)

                  ),




                ],
              ),

              SizedBox(height: 20,),



              imgURL == null ? Text(text ?? "") :
              Image.network(


                  imgURL!)
            ],
          ),
        ),
      ),
    );
  }


    Widget otherMensenger(BuildContext context){

      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        // height: MediaQuery.of(context).size. * 0.5,

        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,

                              image: photoURL != null? NetworkImage(photoURL!)
                                  :
                              AssetImage("assets/person.jpeg")
                          )
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(


                        child: Text( name != null? name!.split(" ").first : "Invalid name",
                          style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w600),)

                    )
                  ],
                ),

                SizedBox(height: 20,),

                imgURL == null? Text(text ?? "") :
                Image.network(


                    imgURL!)
              ],
            ),
          ),
        ),
      );
    }

}

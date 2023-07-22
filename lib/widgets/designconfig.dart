// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DesignConfig {
  static BoxDecoration boxDecorationContainer(Color color, double radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static Widget displayUserList(String title, String firstChar, String email, String phoneNumber, width) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: const Color(0xFFffffff), borderRadius: BorderRadius.circular(10)),
      child: Card(
        elevation: 3,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          leading: CircleAvatar(
              backgroundColor: const Color.fromRGBO(136, 189, 216, 1),
              radius: 26,
              child: ClipOval(
                  child: Text(
                firstChar,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 8, 8, 8)),
              ))),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Email:',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 35,
                          ),
                          Text(
                            email,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Mobile No. :',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            phoneNumber,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

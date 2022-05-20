import 'package:flutter/material.dart';
import 'package:impel/services/app_colors.dart';

// app snack bar
appSnackBar(BuildContext context, String message){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.error,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

// showLoaderDialog(BuildContext context, text) {
//   AlertDialog alert = AlertDialog(
//     content: Row(
//       children: [
//         const CircularProgressIndicator(),
//         Container(
//             margin: EdgeInsets.only(left: 15), child: Text(text)),
//       ],
//     ),
//   );
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       Future.delayed(Duration(milliseconds: 1800), () {
//         Navigator.of(context).pop(true);
//       });
//       return alert;
//     },
//   );
// }

showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

inputText(controller, message, hintText, {prefixIcon, suffixIcon, obscureText, labelText}){
  return TextFormField(
    controller: controller,
    validator: (v){
      if(v!.isEmpty){
        return 'please enter $message';
      }else{
        return null;
      }
    },

    style: const TextStyle(fontSize: 12),
    keyboardType: TextInputType.emailAddress,
    textAlignVertical: TextAlignVertical.center,
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
        hintText: '$hintText',
        labelText: '$labelText',
        border: InputBorder.none,
        filled: true,
        fillColor: AppColors.secondaryColor,
        prefixIcon: Icon(
          prefixIcon,
          size: 18,
        ),
        suffixIcon: suffixIcon ?? null,
        hintStyle: TextStyle(fontSize: 12)),
  );
}

button(BuildContext context, {text, press}){
  Size size = MediaQuery.of(context).size;
  return Container(
    height: size.height * 0.055,
    margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(48)),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryColor,
          blurRadius: 5,
          offset: const Offset(0, 5), // changes position of shadow
        ),
      ],
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      onPressed: press,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,style: AppColors.buttonStyle,
            ),
          ),
          Positioned(
            right: 16,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.15),
                // button color
                child: SizedBox(
                    width: size.width * 0.074,
                    height: size.height * 0.035,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 15,
                    )),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
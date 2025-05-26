import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laboratorio_3/pages/models/useradmin.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';

import 'home_Navigation_Bar_Page.dart';

class AdminRConfirmado extends StatefulWidget {
  const AdminRConfirmado({super.key});

  @override
  State<AdminRConfirmado> createState() => _AdminRConfirmadoState();
}
enum Genre{ male, female} // a male le da un cero y a female le da un uno
class _AdminRConfirmadoState extends State<AdminRConfirmado> {
  Genre? _genre = Genre.male;

  bool _isPasswordObscure = true;
  bool _isrePasswordObscure = true;
  String buttonMsg = "Fecha de nacimiento";
  DateTime _bornDate = DateTime.now(); // variable donde se va a almacenar la fecha
  final _name = TextEditingController();
  final _email =TextEditingController();
  final _cellphone =TextEditingController();
  final _password = TextEditingController();
  final _repassword = TextEditingController();

  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/F_ARD.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(height: 16,), // espacio entre widgets
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nombre",
                        prefixIcon: Icon(Icons.person,color: Colors.white,),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )

                      ),
                      keyboardType: TextInputType.name,
                    ), // nombre de la persona
                    SizedBox(height: 16,),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Correo electrónico",
                        prefixIcon: Icon(Icons.mail_sharp,color: Colors.white,),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty){
                          return "Debe digitar un correo electronico valido";
                        } else{
                          if (!value!.isValidEmail()){
                            return "correo electronico no valido";
                          }
                        }
                        return null;

                      },
                    ),// Direccion de correo con validaciones
                    SizedBox(height: 16,),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _cellphone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Número de celular",
                        prefixIcon: Icon(Icons.phone,color: Colors.white,),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )
                      ),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty){
                          return "Debe digitar un número telefónico valido";
                        } else{
                          if (!value!.isOnlyNumber()){
                            return "Número telefónico no valido";
                          }
                        }
                        return null;

                      },
                    ),// Celular
                    SizedBox(height: 16,),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _password,
                      obscureText: _isPasswordObscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock,color: Colors.white,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscure = !_isPasswordObscure;
                            });
                          },
                        ),
                        labelText: "Contraseña",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),// Contraseña
                    SizedBox(height: 16,),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _repassword,
                      obscureText: _isrePasswordObscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock,color: Colors.white,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isrePasswordObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isrePasswordObscure = !_isrePasswordObscure;
                            });
                          },
                        ),
                        labelText: "Ingrese la contraseña nuevamente",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ), // Repetir la contraseña
                    SizedBox(height: 16,),
                    const Text("Seleccione su genero", style: TextStyle(color: Colors.white),),

                    Row (
                        children: [
                          Expanded(
                              child: RadioListTile(
                                  title: const Text("Masculino", style: TextStyle(color: Colors.white),),
                                  value: Genre.male, // valor que toma el radio button
                                  groupValue: _genre, // permite que se pueda seleccionar solo uno.
                                  activeColor: Colors.cyanAccent,
                                  onChanged: (Genre? value){
                                    setState(() { //cuando se le da click
                                      _genre = value;
                                    });
                                  }
                              )// Boton radial
                          ), // sive para que queden equidistante los radial butons
                          Expanded(
                              child: RadioListTile(
                                  title: const Text("Femenino", style: TextStyle(color: Colors.white),),
                                  value: Genre.female,
                                  groupValue: _genre,
                                  activeColor: Colors.cyanAccent,
                                  onChanged: (Genre? value){
                                    setState(() {
                                      _genre = value;
                                    });
                                  }
                              )
                          ),

                        ]
                    ), //Fila para los botones radiales
                    SizedBox(height: 16,),
                    ElevatedButton(
                      onPressed: () {
                        _showSelectedDate();
                      },
                      child: Text(buttonMsg),
                    ), //boton para el calendario
                    SizedBox(height: 16,),
                    ElevatedButton(
                      onPressed: (){
                        _onRegisterButtonClicked();
                      },
                      child: const Text("Registrarse"),
                    ), //Boton para registrarse
                  ],

                ),
              ),
            ),
          ),
        ],
      )

    );
  }
  void _onRegisterButtonClicked(){
    if(_email.text.isEmpty || _password.text.isEmpty ||  _repassword.text.isEmpty || _cellphone.text.isEmpty){// si todos los campos estan vacios
      showMsg("Debe digitar todos los campos");
    } else if(_password.text!=_repassword.text){// si las contraseñas son diferentes
      showMsg("Las contraseñas deben ser iguales");
    } else if(_password.text.length < 6){ // verifica el tamaño de la contraseña
      showMsg("La contraseña debe tener minimo 6 caracteres");
    } else if(_cellphone.text.length < 10){ // verifica el tamaño de la contraseña
      showMsg("Ingrese un número de celular valido");
    } else {
      createUser(_email.text, _password.text, _cellphone.text);

    }

  }
  void createUser(String email, String password, String cellphone) async{
    var result = await _firebaseApi.createUser(email, password);
    if (result == 'weak-password') {
      showMsg("la contraseña debe tener minimo 6 digitos");
    } else if (result == 'weak-cellphone') {
      showMsg("la número de celular debe tener minimo 10 digitos");
    } else if (result == 'email-already-in-use') {
      showMsg("Ya existe una cuenta con ese correo electronico");
    } else if (result == 'invalid-email') {
      showMsg("El correo electronico esta mal escrito");
    }else if (result == 'network-request-failed') {
      showMsg("Revise su conexion a internet");
    } else{
      var genre = (_genre == Genre.male) ? "Masculino":"Femenino";
      var _user = UserAdmin(result, _name.text, _email.text, genre, _bornDate, _cellphone.text, "");
      createUserIDB(_user);

    }
  } // mensajes de respuesta a todos los errores que pueden surgir.

  void createUserIDB(UserAdmin user) async{
    var result = await _firebaseApi.createUserInDB(user);
    if(result == 'network-request-failed'){
      showMsg('Revise su conexion a internet');
    }else {
      showMsg("Usuario registrado exitosamente");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPage())); //para que se devuelva al dominio
    }

  }

  void showMsg(String msg){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
              label: "Aceptar",
              onPressed: scaffold.hideCurrentSnackBar
          ),
        )
    );
  } // Funcion para que aparezca un texto con un boton que diga aceptar
  void _showSelectedDate()async{
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate:DateTime.now() , // es la fecha que se mostrara primero
      firstDate: DateTime(1925, 1), // es la primera fecha que se mostrara en el calendario (año, mes)
      lastDate: DateTime.now(),
      helpText: "Fecha de Nacimiento",
    ); // en esa linea se queda esperando y se configura el calendario
    if (newDate != null){
      setState(() {
        _bornDate= newDate;
        buttonMsg = "Fecha de Nacimiento: ${_dateConverter(newDate)}";

      });//indica y guarda el valor de la fecha de nacimiento

    }
  }
  String _dateConverter(DateTime date){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(date);
    return dateFormatted;
  } //para cambiar el formato en el que se ve la fecha
}

extension on String{
  bool isValidEmail(){
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(this);
  }
}
extension on String{
  bool isOnlyNumber(){
    return RegExp("^[0-9]").hasMatch(this);
  }
}

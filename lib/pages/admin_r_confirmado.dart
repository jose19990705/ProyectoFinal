import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laboratorio_3/pages/models/useradmin.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';

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
  final _password = TextEditingController();
  final _repassword = TextEditingController();

  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/M.png"),
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 16,), // espacio entre widgets
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nombre",
                    prefixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.name,
                ), // nombre de la persona
                SizedBox(height: 16,),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Correo electrónico",
                    prefixIcon: Icon(Icons.mail_sharp),
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
                  controller: _password,
                  obscureText: _isPasswordObscure,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscure = !_isPasswordObscure;
                        });
                      },
                    ),
                    labelText: "Contraseña",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),// Contraseña
                SizedBox(height: 16,),
                TextFormField(
                  controller: _repassword,
                  obscureText: _isrePasswordObscure,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isrePasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isrePasswordObscure = !_isrePasswordObscure;
                        });
                      },
                    ),
                    labelText: "Ingrese la contraseña nuevamente",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ), // Repetir la contraseña
                SizedBox(height: 16,),
                const Text("Seleccione su genero"),
                Row (
                    children: [
                      Expanded(
                          child: RadioListTile(
                              title: const Text("Masculino"),
                              value: Genre.male, // valor que toma el radio button
                              groupValue: _genre, // permite que se pueda seleccionar solo uno.
                              onChanged: (Genre? value){
                                setState(() { //cuando se le da click
                                  _genre = value;
                                });
                              }
                          )// Boton radial
                      ), // sive para que queden equidistante los radial butons
                      Expanded(
                          child: RadioListTile(
                              title: const Text("Femenino"),
                              value: Genre.female,
                              groupValue: _genre,
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
    );
  }
  void _onRegisterButtonClicked(){
    if(_email.text.isEmpty || _password.text.isEmpty ||  _repassword.text.isEmpty){// si todos los campos estan vacios
      showMsg("Debe digitar todos los campos");
    } else if(_password.text!=_repassword.text){// si las contraseñas son diferentes
      showMsg("Las contraseñas deben ser iguales");
    } else if(_password.text.length < 6){ // verifica el tamaño de la contraseña
      showMsg("La contraseña debe tener minimo 6 caracteres");
    } else {
      createUser(_email.text, _password.text);

    }

  }
  void createUser(String email, String password) async{
    var result = await _firebaseApi.createUser(email, password);
    if (result == 'weak-password') {
      showMsg("la contraseña debe tener minimo 6 digitos");
    } else if (result == 'email-already-in-use') {
      showMsg("Ya existe una cuenta con ese correo electronico");
    } else if (result == 'invalid-email') {
      showMsg("El correo electronico esta mal escrito");
    }else if (result == 'network-request-failed') {
      showMsg("Revise su conexion a internet");
    } else{
      var genre = (_genre == Genre.male) ? "Masculino":"Femenino";
      var _user = UserAdmin(result, _name.text, _email.text, _genre, _bornDate, "");
      createUserInDB(_user as UserAdmin);

    }
  } // mensajes de respuesta a todos los errores que pueden surgir.

  void createUserInDB(UserAdmin user) async{
    var result = await _firebaseApi.createUserInDB(user);
    if(result == 'network-request-failed'){
      showMsg('Revise su conexion a internet');
    }else {
      showMsg("Usuario registrado exitosamente");
      Navigator.pop(context); //para que se devuelva al dominio
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

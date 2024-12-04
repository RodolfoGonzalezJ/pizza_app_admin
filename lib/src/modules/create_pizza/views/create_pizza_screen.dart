import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pizza_repository/pizza_repository.dart';

import '../../../components/my_text_field.dart';
import '../blocs/create_pizza_bloc/create_pizza_bloc.dart';
import '../blocs/upload_picture_bloc/upload_picture_bloc.dart';
import '../components/macro.dart';

class CreatePizzaScreen extends StatefulWidget {
  const CreatePizzaScreen({super.key});

  @override
  State<CreatePizzaScreen> createState() => _CreatePizzaScreenState();
}

class _CreatePizzaScreenState extends State<CreatePizzaScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final calorieController = TextEditingController();
  final proteinController = TextEditingController();
  final fatController = TextEditingController();
  final carbsController = TextEditingController();
  bool creationRequired = false;
  String? _errorMsg;
  late Pizza pizza;

  @override
  void initState() {
    pizza = Pizza.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePizzaBloc, CreatePizzaState>(
      listener: (context, state) {
        if (state is CreatePizzaSuccess) {
          setState(() {
            creationRequired = false;
            context.go('/');
          });
          context.go('/');
        } else if (state is CreatePizzaLoading) {
          setState(() {
            creationRequired = true;
          });
        }
      },
      child: BlocListener<UploadPictureBloc, UploadPictureState>(
        listener: (context, state) {
          if (state is UploadPictureLoading) {
          } else if (state is UploadPictureSuccess) {
            setState(() {
              pizza.picture = state.url;
            });
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crear una Nueva Pizza !',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, maxWidth: 1000);

                      if (image != null && context.mounted) {
                        context.read<UploadPictureBloc>().add(UploadPicture(
                              await image.readAsBytes(),
                              basename(image.path),
                            ));
                      }
                    },
                    child: pizza.picture.startsWith(('http'))
                        ? Container(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(pizza.picture),
                                    fit: BoxFit.cover)))
                        : Ink(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.photo,
                                  size: 100,
                                  color: Colors.grey.shade200,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Subir una foto',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: nameController,
                                  hintText: 'Nombre',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  //prefixIcon: const Icon(CupertinoIcons.mail_solid),
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Por favor, rellene este campo';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 400,
                              child: MyTextField(
                                  controller: descriptionController,
                                  hintText: 'Descripción',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  //prefixIcon: const Icon(CupertinoIcons.mail_solid),
                                  errorMsg: _errorMsg,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Por favor, rellene este campo';
                                    }
                                    return null;
                                  })),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 400,
                            child: Row(
                              children: [
                                Expanded(
                                    child: MyTextField(
                                        controller: priceController,
                                        hintText: 'Precio',
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        //prefixIcon: const Icon(CupertinoIcons.mail_solid),
                                        errorMsg: _errorMsg,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Por favor, rellene este campo';
                                          }
                                          return null;
                                        })),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: MyTextField(
                                        controller: discountController,
                                        hintText: 'Descuento',
                                        suffixIcon: Icon(
                                          CupertinoIcons.percent,
                                          color: Colors.grey,
                                        ),
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        //prefixIcon: const Icon(CupertinoIcons.mail_solid),
                                        errorMsg: _errorMsg,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Por favor, rellene este campo';
                                          }
                                          return null;
                                        })),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Es Vegano: '),
                              SizedBox(
                                width: 10,
                              ),
                              Checkbox(
                                  value: pizza.isVeg,
                                  onChanged: (value) {
                                    setState(() {
                                      pizza.isVeg = value!;
                                    });
                                  })
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Es Picante: '),
                              SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      setState(() {
                                        pizza.spicy = 1;
                                      });
                                    },
                                    child: Ink(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: pizza.spicy == 1
                                            ? Border.all(width: 2)
                                            : null,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      setState(() {
                                        pizza.spicy = 2;
                                      });
                                    },
                                    child: Ink(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: pizza.spicy == 2
                                            ? Border.all(width: 2)
                                            : null,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      setState(() {
                                        pizza.spicy = 3;
                                      });
                                    },
                                    child: Ink(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: pizza.spicy == 3
                                            ? Border.all(width: 2)
                                            : null,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Macros',
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 400,
                            child: Row(
                              children: [
                                MyMacroWidget(
                                  title: 'Calorias',
                                  value: 12,
                                  icon: FontAwesomeIcons.fire,
                                  controller: calorieController,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyMacroWidget(
                                  title: 'Proteina',
                                  value: 12,
                                  icon: FontAwesomeIcons.dumbbell,
                                  controller: proteinController,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyMacroWidget(
                                  title: 'Grasas',
                                  value: 12,
                                  icon: FontAwesomeIcons.oilWell,
                                  controller: fatController,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyMacroWidget(
                                  title: 'Carbos',
                                  value: 12,
                                  icon: FontAwesomeIcons.breadSlice,
                                  controller: carbsController,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 20),
                  !creationRequired
                      ? SizedBox(
                          width: 400,
                          height: 40,
                          child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    pizza.name = nameController.text;
                                    pizza.description =
                                        descriptionController.text;
                                    pizza.price =
                                        int.parse(priceController.text);
                                    pizza.discount =
                                        int.parse(discountController.text);
                                    pizza.isVeg = pizza.isVeg;
                                    pizza.spicy = pizza.spicy;
                                    pizza.macros.calories =
                                        int.parse(calorieController.text);
                                    pizza.macros.carbs =
                                        int.parse(carbsController.text);
                                    pizza.macros.proteins =
                                        int.parse(proteinController.text);
                                    pizza.macros.fat =
                                        int.parse(fatController.text);
                                  });
                                  print(pizza.toString());
                                  context
                                      .read<CreatePizzaBloc>()
                                      .add(CreatePizza(pizza));
                                }
                              },
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: Text(
                                  'Crear Pizza',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

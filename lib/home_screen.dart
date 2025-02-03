import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool inProgress = false;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  void getProduct() async {
    inProgress = true;
    if (mounted) {
      setState(() {});
    }

    Response response = await get(
      Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct'),
    );
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
      products.clear();
      decodedResponse['data'].forEach((e) {
        products.add(
          Product.toJson(e),
        );
      });
    }
    inProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void updateProduct(String id) async {
    inProgress = true;
    if (mounted) {
      setState(() {});
    }
    Response response = await post(
        Uri.parse('https://crud.teamrabbil.com/api/v1/UpdateProduct/$id'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          "ProductName": _nameTEController.text.trim(),
          "ProductCode": _codeTEController.text.trim(),
          "UnitPrice": _unitPriceTEController.text.trim(),
          "Qty": _quantityTEController.text.trim(),
          "TotalPrice": _totalPriceTEController.text.trim(),
          "Img": _imageTEController.text.trim(),
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      if (decodedResponse['status'] == 'success') {
        if (mounted) {
          showSnackBar('Product updated successfully.');
        }
        getProduct(); // Refresh the product list after updating
      }
    } else {
      if (mounted) {
        showSnackBar('Failed to update the product.');
      }
    }
    inProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void postProduct() async {
    Response response = await post(
        Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          "ProductName": _nameTEController.text.trim(),
          "ProductCode": _codeTEController.text.trim(),
          "UnitPrice": _unitPriceTEController.text.trim(),
          "Qty": _quantityTEController.text.trim(),
          "TotalPrice": _totalPriceTEController.text.trim(),
          "Img": _imageTEController.text.trim(),
        }));
    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(response.body);
      if (decodedBody['status'] == 'success') {
        if (mounted) {
          _nameTEController.clear();
          _codeTEController.clear();
          _unitPriceTEController.clear();
          _quantityTEController.clear();
          _totalPriceTEController.clear();
          _imageTEController.clear();

          showSnackBar('Product Added Successfully');
        }
      } else {
        if (mounted) {
          showSnackBar('Product Add Failed. Try Again.');
        }
      }
    }
  }

  void deleteProduct(String id) async {
    inProgress = true;
    if (mounted) {
      setState(() {});
    }

    Response response = await get(
        Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$id'));
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
      getProduct();
    } else {
      inProgress = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crud App'),
        actions: [
          IconButton(
            onPressed: () {
              getProduct();
            },
            icon: Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: inProgress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    minLeadingWidth: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onLongPress: () {
                      showUDBox(index);
                    },
                    leading: Image.network(
                      width: 40,
                      products[index].image,
                      errorBuilder: (_, __, ___) {
                        return Icon(Icons.camera);
                      },
                    ),
                    title: Text(
                      products[index].productName,
                      style: TextStyle(color: Colors.pink),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Code : ${products[index].productCode}'),
                        Text('Quantity : ${products[index].quantity}'),
                        Text('Unit Price : ${products[index].unitPrice}/p'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Price :',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          products[index].totalPrice,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNewBottomSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showNewBottomSheet() {
    _nameTEController.clear();
    _codeTEController.clear();
    _unitPriceTEController.clear();
    _quantityTEController.clear();
    _totalPriceTEController.clear();
    _imageTEController.clear();
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 40,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Add New Product',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                    controller: _nameTEController,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter product code';
                      }
                      return null;
                    },
                    controller: _codeTEController,
                    decoration: InputDecoration(hintText: 'Product Code'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter product unit price';
                      }
                      return null;
                    },
                    controller: _unitPriceTEController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Unit Price'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter product quantity';
                      }
                      return null;
                    },
                    controller: _quantityTEController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Quantity'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter product total price';
                      }
                      return null;
                    },
                    controller: _totalPriceTEController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Total Price'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter image url';
                      }
                      return null;
                    },
                    controller: _imageTEController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(hintText: 'Image'),
                  ),
                  const SizedBox(height: 20),
                  inProgress
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              getProduct();
                              postProduct();

                              Navigator.pop(context);
                            }
                          },
                          child: Text('Add'),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showUpdateDialogueBox(Product product) {
    _nameTEController.text = product.productName;
    _codeTEController.text = product.productCode;
    _unitPriceTEController.text = product.unitPrice;
    _quantityTEController.text = product.quantity;
    _totalPriceTEController.text = product.totalPrice;
    _imageTEController.text = product.image;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Update Information',
            style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 40,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    TextFormField(
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                      controller: _nameTEController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter product code';
                        }
                        return null;
                      },
                      controller: _codeTEController,
                      decoration: InputDecoration(hintText: 'Product Code'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter product unit price';
                        }
                        return null;
                      },
                      controller: _unitPriceTEController,
                      decoration: InputDecoration(hintText: 'Unit Price'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter product quantity';
                        }
                        return null;
                      },
                      controller: _quantityTEController,
                      decoration: InputDecoration(hintText: 'Quantity'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter product total price';
                        }
                        return null;
                      },
                      controller: _totalPriceTEController,
                      decoration: InputDecoration(hintText: 'Total Price'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter image link';
                        }
                        return null;
                      },
                      controller: _imageTEController,
                      decoration: InputDecoration(hintText: 'Image'),
                    ),
                    const SizedBox(height: 10),
                    inProgress
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateProduct(product.id);

                                Navigator.pop(context);
                              }
                            },
                            child: Text('Update'),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showUDBox(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text(
            'Choose an option',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showUpdateDialogueBox(products[index]);
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      deleteProduct(products[index].id);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Product {
  final String id,
      productName,
      productCode,
      image,
      unitPrice,
      quantity,
      totalPrice,
      createdDate;
  Product(this.id, this.productName, this.productCode, this.image,
      this.unitPrice, this.quantity, this.totalPrice, this.createdDate);
  factory Product.toJson(Map<String, dynamic> e) {
    return Product(
      e['_id'],
      e['ProductName'],
      e['ProductCode'],
      e['Img'],
      e['UnitPrice'],
      e['Qty'],
      e['TotalPrice'],
      e['CreatedDate'],
    );
  }
}

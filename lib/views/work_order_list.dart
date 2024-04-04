// Work Order view

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frontend/models/employee_model.dart';
import 'package:frontend/models/trailer_model.dart';
import 'package:frontend/models/work_order_model.dart';
import 'package:frontend/services/database_handler.dart';
import 'package:frontend/views/work_order_create.dart';
import 'package:frontend/views/work_order_search.dart';
import 'work_order_edit.dart';

class WorkOrderList extends StatefulWidget {
  const WorkOrderList({super.key, required this.workOrders, required this.trailer, required this.employeeCode});

  final List<WorkOrders> workOrders;
  final Trailer trailer;
  final String employeeCode;
  

  @override
  State<WorkOrderList> createState() => _MyWorkOrderState(workOrders, trailer, employeeCode);
}



class _MyWorkOrderState extends State<WorkOrderList> {
  _MyWorkOrderState(this.workOrders, this.trailer, this.employeeCode);

  late List<WorkOrders> workOrders;
  late Trailer trailer;
  late String employeeCode;
  

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order View"),
      ),
      body: ListView.builder(
          itemCount: workOrders.length+1,
          itemBuilder: (context, index) {

            if (workOrders.length > index) {
              return ListTile(
                  title: Text("Order ID: ${workOrders[index].workOrderNum}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${workOrders[index].status}"),
                      Text("Job Codes: ${workOrders[index].jobCodes}"),
                      Text("Employee Code: ${workOrders[index].empNum}"),
                    ],
                  ),
                  trailing: Row( 
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        ), 
                      backgroundColor: const Color.fromARGB(255, 136, 186, 226),),
                      child: Image.asset('asset/images/completed.png', width: 30, height: 30,),
                      onPressed: () {
                      
                        DatabaseHandler.WorkOrderStatus(trailer.trailerId, workOrders[index].workOrderNum, 'C');
                        workOrders.removeAt(index);
                        setState(() {_MyWorkOrderState(workOrders, trailer, employeeCode);});

                      }
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        ), 
                      backgroundColor: Colors.red,
                      ),
                      child: Image.asset('asset/images/delete.png', width: 30, height: 30,),
                      onPressed: () {

                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>AlertDialog(
                            title: Text("Delete Work Order ${workOrders[index].workOrderNum}"),
                            content: const Text("Are you sure you want to delete this Work Order?"),
                            actions: <Widget>[
                              TextButton(onPressed: () {
                                  DatabaseHandler.WorkOrderStatus(trailer.trailerId, workOrders[index].workOrderNum, 'D');
                                  workOrders.removeAt(index);
                                  setState(() {_MyWorkOrderState(workOrders, trailer, employeeCode);});
                                  Navigator.pop(context, 'No');
                                }, 
                                child: const Text("Yes"),
                              ),
                              TextButton(onPressed: () {

                                  Navigator.pop(context, 'No');

                                }, 
                                child: const Text("No"),
                              ),
                            ],
                          ),
                        );
                      }  
                    ),
                  ], 
                ),
              shape: const Border(top: BorderSide()),
              onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditWorkOrder(trailer: trailer, workOrders: workOrders, index: index, employeeCode: employeeCode),));
                  }
              );
          
            }else {
              return ListTile(
                title: const Center(child: Text("Create a New Work Order")),
                subtitle: const Center(child: Text("Add new jobs and work orders to this trailer")),
                shape: const Border(top: BorderSide(), bottom: BorderSide()),
                onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWorkOrder(trailer: trailer, workOrders: workOrders, employeeCode: employeeCode,),));    
                }
              );
            }     
          }  
        ),
    );
  }
}
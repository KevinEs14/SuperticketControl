import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_access_control/blocs/blocs.dart';
import 'package:st_access_control/blocs/ticket/filter/ticket_filter_model.dart';
import 'package:st_access_control/ui/values/colors.dart';
import 'package:st_access_control/ui/values/dimens.dart';
import 'package:st_access_control/ui/values/routes.dart';
import 'package:st_access_control/ui/values/styles.dart';
import 'package:st_access_control/ui/widgets/common/circle_progress.dart';
import 'package:st_access_control/ui/widgets/common/snack_bars.dart';
import 'package:st_common/st_ac.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScannerScreen extends StatefulWidget {
  String eventId;
  ScannerScreen({Key key,this.eventId}) : super(key: key);

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode result;
  int _time=2;
  bool _auto=false;

  QRViewController controller;


  bool _found=false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: colorPrimary,
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),

            centerTitle: true,
            // title: Text("Tiempo de Alerta",style: TextStyle(color: Colors.white),),
            actions: [
              Row(
                children: [
                  Checkbox(value: _auto, onChanged: (value){
                    setState(() {
                      _auto=value;
                    });
                  },
                    activeColor: Colors.white,
                    checkColor: colorPrimary,
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                  ),
                  GestureDetector(
                    child: Text("Auto."),
                    onTap: (){
                      setState(() {
                        _auto=!_auto;
                      });
                    },
                    ),
                ],
              ),
              PopupMenuButton<MenuItem>(
                onSelected: (item)=>onSelected(context, item),

                itemBuilder: (context)=>[
                  ...MenuItems.itemsList.map(buildItem).toList(),
                ],
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: (controller){
                    _onQRViewCreated(controller,context);
                  },
                  overlay: QrScannerOverlayShape(
                    borderRadius: 10,
                    borderColor: _found?colorPrimary:Colors.white,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                    overlayColor: _found?colorPrimaryVariant.withOpacity(0.8):Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: BlocConsumer<EventTicketsBloc, EventTicketsState>(
                  listener: (context,state){


                  },
                    builder: (context,state){

                      if (state is EventTicketsLoadInProgress) {
                        return Container(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Obteniendo Ticket...",style: Styles.titleToList),
                              CircleProgress(),

                            ],
                          )
                        );
                      }

                      else if (state is EventTicketsLoadedFailure) {
                        return Container(
                          color: colorError.withOpacity(0.8),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(state.error,style: TextStyle(color: colorOnError,fontSize: Dimens.normal,fontWeight: FontWeight.w500),),
                                RaisedButton(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Aceptar",
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  color: colorPrimaryVariant,
                                  padding: const EdgeInsets.all(Dimens.small),
                                  onPressed: () {
                                    BlocProvider.of<EventTicketsBloc>(context).add(EventTicketsInit());
                                    setState(() {
                                      _found=false;
                                    });
                                  },
                                ),
                              ],
                            )
                        );
                      }

                      else if (state is EventTicketsLoadedSuccess) {
                        final List<TicketModel> _tickets = state.tickets;
                        if(_tickets.length == 1){
                          _registerTicket(_tickets.first,context);
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            BlocProvider.of<EventTicketsBloc>(context).add(EventTicketsInit());
                            setState(() {
                              _found=false;
                            });
                            Navigator.pushNamed(context, Routes.tickets, arguments: TicketFilterModel.searchByTicket(widget.eventId,state.accessCode));
                          });
                        }
                        return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Registrando Ticket...",style: Styles.titleToList),
                                CircleProgress(),

                              ],
                            )
                        );
                      }
                      else if (state is EventTicketsRegisterSuccess) {
                        _waitSuccess(context);
                        return Container(
                            color: colorSuccess,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Ticket registrado exitosamente!",style: TextStyle(color: colorPrimaryVariant,fontSize: Dimens.normal,fontWeight: FontWeight.w500),),
                                  Text("${state.ticket.accessQuantity-state.ticket.accesses.length} accesos restantes",style: Styles.textDetailSmall,),

                                ],
                              )
                          );
                      }
                      else{
                        return _found&&!_auto?Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Text("Ticket: ${result.code}", style: Styles.titleToList),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    onPressed: (){
                                      _scan(context);
                                    },
                                    color: colorPrimaryVariant,
                                    child: Text("Procesar",),
                                    padding: const EdgeInsets.all(Dimens.small),
                                  ),

                                  RawMaterialButton(
                                    onPressed: (){
                                      setState(() {
                                        _found=false;
                                      });
                                    },
                                    child: Text("Cancelar",style: Styles.errorForm,),
                                  )
                                ],
                              ),
                            ]
                          )
                        )
                            :Container(
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Buscando códigos...",style: Styles.titleToList,),
                            CircleProgress(),

                          ],
                        )
                        );
                      }
                    },
              ),
              )
            ],
          ),
        );

      }

  void _onQRViewCreated(QRViewController controller,context) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
        if(!_found){
          setState(() {
            result=scanData;
          });
          setState(() {
            _found=true;
          });
          if(_auto){
            _scan(context);
          }
        }
    });
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item)=>PopupMenuItem<MenuItem>(
      value: item,

      child: Row(
        children: [
          Icon(item.icon,color: colorPrimary,),
          const SizedBox(width: 12,),
          Text(item.text),
        ],
      )
  );

  void onSelected(BuildContext context,MenuItem item){
    switch(item){
      case MenuItems.itemAdd:
        setState(() {
          _time++;
        });
        _showToast("Tiempo de Alerta aumentado a $_time s");
        break;
      case MenuItems.itemRemove:
        setState(() {
          if(_time>1){
            _time--;
          }
        });
        _showToast("Tiempo de Alerta disminuido a $_time s");
        break;
    }
  }

  void _scan(context)async{
    BlocProvider.of<EventTicketsBloc>(context).add(EventCrudSearchTicket(eventId: widget.eventId, accessCode: result.code));
  }
  void _registerTicket(TicketModel ticket,context)async{
    BlocProvider.of<EventTicketsBloc>(context).add(EventTicketsRegister(ticket: ticket));
  }
  void _showToast(String msg){

    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimaryVariant.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

  void _waitSuccess(context)async{
    await Future.delayed(Duration(seconds: _time));
    BlocProvider.of<EventTicketsBloc>(context).add(EventTicketsInit());
    setState(() {
      _found=false;
    });
  }

}

class MenuItem{
  final String text;
  final IconData icon;
  const MenuItem({
    this.text,
    this.icon
  });
}
class MenuItems{
  static const List<MenuItem> itemsList=[itemAdd,itemRemove];
  static const itemAdd=MenuItem(text: "Incrementar",icon: Icons.add);
  static const itemRemove=MenuItem(text: "Decrementar",icon: Icons.remove);
}
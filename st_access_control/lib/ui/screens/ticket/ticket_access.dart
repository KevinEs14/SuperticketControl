import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_common/st_ac.dart';

import '../../../blocs/access/form/access_form_bloc.dart';
import '../../../blocs/access/crud/access_crud_bloc.dart';
import '../../values/values.dart';
import '../../widgets/common/circle_progress.dart';
import '../../widgets/common/snack_bars.dart';

class TicketAccess extends StatelessWidget {
  final int accessesAvailable;

  const TicketAccess({Key key, @required this.accessesAvailable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccessFormBloc, AccessFormState>(
      listener: (context, state){
        if (state.status == MyFormStatus.FORM_SUCCESS) {
          switch(state.accessAction){
            case AccessAction.REGISTER_ACCESS:
              BlocProvider.of<AccessCrudBloc>(context).add(AccessCrudRegister(
                ticketAccessId: state.ticketAccess.id,
                qty: state.quantity,
                note: state.ticketAccess?.note
              ));
              break;
            case AccessAction.LOCK:
              BlocProvider.of<AccessCrudBloc>(context).add(AccessCrudLock(
                ticketAccessId: state.ticketAccess.id,
                note: state.ticketAccess.note,
              ));
              break;
            case AccessAction.UNLOCK:
              BlocProvider.of<AccessCrudBloc>(context).add(AccessCrudUnlock(
                ticketAccessId: state.ticketAccess.id,
                note: state.ticketAccess.note,
              ));
              break;
          }
        }
      },
      buildWhen: (previous, current) => current.ticketAccess.state != previous.ticketAccess.state ||
          current.status != previous.status,
      builder: (context, state){
        List<Widget> _children = [
          SizedBox(height: Dimens.little),
          _buildFailure(),
        ];

        if (accessesAvailable > 1 && state.ticketAccess.state.toEnum == TicketAccessStateEnum.ENABLED) {
          _children.add(Text(Strings.accessQuantity, style: Styles.titleDetailSmallTextSecondary));
          _children.add(Padding(
            padding: const EdgeInsets.only(bottom: Dimens.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _subtractQty(),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.small),
                    child: SizedBox(
                      width: 72,
                      child: _inputQty(),
                    ),
                  ),
                ),
                _addQty(),
              ],
            ),
          ));
        }

        _children.add(_inputNote());

        switch(state.ticketAccess.state.toEnum){
          case TicketAccessStateEnum.ENABLED:
            _children.add(_buttons());
            break;
          case TicketAccessStateEnum.LOCKED:
            _children.add(_unlockButton());
            break;
        }

        return Container(
            padding: EdgeInsets.only(top: Dimens.little),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimens.normal),
                topLeft: Radius.circular(Dimens.normal),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _children,
            ));
      },
    );
  }

  BlocBuilder _buildFailure() {
    return BlocBuilder<AccessCrudBloc, AccessCrudState>(
      builder: (context, state) {
        if (state is AccessCrudFailure) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimens.normal),
            child: Center(
              child: Text(
                state.error,
                style: TextStyle(fontSize: 12.0, color: Theme.of(context).errorColor),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  BlocBuilder _subtractQty(){
    return BlocBuilder<AccessFormBloc, AccessFormState>(
      buildWhen: (previous, current) =>
          current.quantity != previous.quantity ||
          current.status != previous.status,
      builder: (context, state) {
        final _qty = BlocProvider.of<AccessFormBloc>(context).state.quantity;
        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Colors.white,
          constraints: BoxConstraints.tightFor(
            width: 48.0,
            height: 48.0,
          ),
          child: Icon(Icons.remove, color: !state.disabledWidgets && _qty > 1 ? colorSecondary : Colors.grey[400]),
          onPressed: !state.disabledWidgets && _qty > 1 ? () {
            BlocProvider.of<AccessFormBloc>(context)
                .add(AccessFormUpdateData(
              value: _qty-1,
              typeData: AccessFormData.QUANTITY,
            ));
          } : null,
        );
      },
    );
  }

  BlocBuilder _addQty(){
    return BlocBuilder<AccessFormBloc, AccessFormState>(
      buildWhen: (previous, current) =>
      current.quantity != previous.quantity ||
          current.status != previous.status,
      builder: (context, state) {
        final _qty = BlocProvider.of<AccessFormBloc>(context).state.quantity;
        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Colors.white,
          constraints: BoxConstraints.tightFor(
            width: 48.0,
            height: 48.0,
          ),
          child: Icon(Icons.add, color: !state.disabledWidgets && _qty < accessesAvailable ? colorSecondary : Colors.grey[400]),
          onPressed: !state.disabledWidgets && _qty < accessesAvailable ? () {
            BlocProvider.of<AccessFormBloc>(context)
                .add(AccessFormUpdateData(
              value: _qty+1,
              typeData: AccessFormData.QUANTITY,
            ));
          } : null,
        );
      },
    );
  }

  BlocBuilder _inputQty(){
    return BlocBuilder<AccessFormBloc, AccessFormState>(
      buildWhen: (previous, current) =>
          current.quantity != previous.quantity ||
          current.status != previous.status,
      builder: (context, state) {
        return Center(
          child: Text('${state.quantity ?? ''}', style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black),),
        );
      },
    );
  }

  BlocBuilder _inputNote(){
    return BlocBuilder<AccessFormBloc, AccessFormState>(
      buildWhen: (previous, current) =>
          current.ticketAccess.note != previous.ticketAccess.note ||
          current.status != previous.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(Dimens.normal, 0, Dimens.normal, Dimens.normal),
          child: TextFormField(
            enabled: !state.disabledWidgets,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            maxLines: null,
            initialValue: '${state.ticketAccess.note ?? ''}',
            inputFormatters: [
              LengthLimitingTextInputFormatter(256),
            ],
            decoration: InputDecoration(
              labelText: '${Strings.note}',
              errorText: state.status == MyFormStatus.FORM_FAILURE ? state.isValidNote : null,
            ),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            onChanged: (String value) {
              BlocProvider.of<AccessFormBloc>(context)
                  .add(AccessFormUpdateData(
                value: value,
                typeData: AccessFormData.NOTE,
              ));
            },
          ),
        );
      },
    );
  }

  _accessCrudListener(context, state) async{
    if (state is AccessCrudInProgress){
      BlocProvider.of<AccessFormBloc>(context).add(AccessFormUpdateData(typeData: AccessFormData.STATUS, value: MyFormStatus.IN_PROGRESS));
    }

    if (state is AccessCrudFailure){
      BlocProvider.of<AccessFormBloc>(context).add(AccessFormUpdateData(typeData: AccessFormData.STATUS, value: MyFormStatus.FAILURE));
    }

    if (state is AccessCrudSuccess){
      BlocProvider.of<AccessFormBloc>(context).add(AccessFormUpdateData(typeData: AccessFormData.STATUS, value: MyFormStatus.SUCCESS));

      switch (state.on) {
        case CrudOn.CREATE:
          showSuccessSnackBar(context: context, text: 'Acceso Aceptado');
          break;
        case CrudOn.READ:
          showCustomSnackBar(context: context, text: 'Acceso Bloqueado', icon: Icons.lock, bgColor: colorError, textColor: colorOnError);
          break;
        case CrudOn.UPDATE:
          //TODO actualizar ticket access en caso de Acceso Desbloqueado success
          showCustomSnackBar(context: context, text: 'Acceso Desbloqueado', icon: Icons.lock_open, bgColor: colorSuccess, textColor: colorOnSuccess);
          break;
        case CrudOn.DELETE:
          break;
        case CrudOn.UPLOAD:
          break;
        case CrudOn.DOWNLOAD:
          break;
      }
      await Future.delayed(Duration(milliseconds: 2000));
      Navigator.popUntil(context, ModalRoute.withName(Routes.eventDetail));
    }
  }

  BlocConsumer _buttons(){
    return BlocConsumer<AccessCrudBloc, AccessCrudState>(
      listener: _accessCrudListener,
      builder: (context, state){
        if (state is AccessCrudInProgress) {
          return Padding(
            padding: const EdgeInsets.all(Dimens.normal),
            child: SizedBox(
                width: Dimens.medium,
                height: Dimens.medium,
                child: CircleProgress()),
          );
        }

        if (state is AccessCrudSuccess) {
          return Padding(
            padding: const EdgeInsets.all(Dimens.normal),
            child: Center(child: Icon(Icons.check, color: colorSuccess, size: Dimens.medium,)),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: RaisedButton.icon(
                icon: Icon(Icons.lock_outline),
                label: Text("Bloquear"),
                color: Colors.white,
                padding: const EdgeInsets.all(Dimens.normal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(Dimens.medium)),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  BlocProvider.of<AccessFormBloc>(context).add(AccessFormValidateLock());
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: RaisedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Marcar acceso",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: Dimens.small),
                    Icon(Icons.arrow_forward, color: colorOnPrimary)
                  ],
                ),
                color: colorPrimaryVariant,
                padding: const EdgeInsets.all(Dimens.normal),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(Dimens.medium)),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  BlocProvider.of<AccessFormBloc>(context).add(AccessFormValidate());
                },
              ),
            ),
          ],
        );
      },
    );
  }

  BlocConsumer _unlockButton(){
    return BlocConsumer<AccessCrudBloc, AccessCrudState>(
      listener: _accessCrudListener,
      builder: (context, state){
        if (state is AccessCrudInProgress) {
          return Padding(
            padding: const EdgeInsets.all(Dimens.normal),
            child: SizedBox(
                width: Dimens.medium,
                height: Dimens.medium,
                child: CircleProgress()),
          );
        }

        if (state is AccessCrudSuccess) {
          return Padding(
            padding: const EdgeInsets.all(Dimens.normal),
            child: Center(child: Icon(Icons.check, color: colorSuccess, size: Dimens.medium,)),
          );
        }

        return RaisedButton.icon(
          icon: Icon(Icons.lock_open),
          label: Text(
            "Desbloquear",
            textAlign: TextAlign.center,
          ),
          color: colorPrimaryVariant,
          padding: const EdgeInsets.all(Dimens.normal),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.only(topLeft: Radius.circular(Dimens.medium), topRight: Radius.circular(Dimens.medium)),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            BlocProvider.of<AccessFormBloc>(context).add(AccessFormValidateUnlock());
          },
        );
      },
    );
  }
}

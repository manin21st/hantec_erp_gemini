$PBExportHeader$w_error.srw
$PBExportComments$DB ERROR MESSAGEÇ¥½Ã
forward
global type w_error from window
end type
type dw_1 from datawindow within w_error
end type
end forward

global type w_error from window
integer x = 530
integer y = 464
integer width = 2537
integer height = 1256
boolean titlebar = true
string title = "Db Error Message !"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
dw_1 dw_1
end type
global w_error w_error

type variables
Long rowno
String errorcode, errorsyntax_system, errorsyntax_user, errorsqlsyntax
end variables

on w_error.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_error.destroy
destroy(this.dw_1)
end on

event open;str_db_error db_error_msg
String sMsg_txt1, sMsg_txt2
Long	 Lerrcode

db_error_msg = message.PowerObjectParm

Lerrcode = Dec(Mid(db_error_msg.errorcode, 5, 5))

SELECT "MSGFILE"."MSG_TXT1",   
       "MSGFILE"."MSG_TXT2"  
	INTO :smsg_txt1,   
        :smsg_txt2  
   FROM "MSGFILE"  
   WHERE "MSGFILE"."MSG_NO" = :Lerrcode;

dw_1.insertrow(0)
dw_1.setitem(1, 1, 'Row.No......... : ' + String(db_error_msg.rowno))
dw_1.setitem(1, 2, 'Error.Code... : ' + db_error_msg.errorcode)
dw_1.setitem(1, 3, 'System Msg : ' + db_error_msg.errorsyntax_system)
dw_1.setitem(1, 4, 'User...Msg... : ' + smsg_txt1 + '~n' + smsg_txt2)
dw_1.setitem(1, 5, 'Sql.Syntax... : ' + db_error_msg.errorsqlsyntax)

f_window_center_response(this)
end event

type dw_1 from datawindow within w_error
integer width = 2501
integer height = 1172
integer taborder = 10
string dataobject = "d_dberror"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type


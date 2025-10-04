$PBExportHeader$w_mat_03550.srw
$PBExportComments$** 출고증
forward
global type w_mat_03550 from w_standard_print
end type
type pb_1 from u_pb_cal within w_mat_03550
end type
type pb_2 from u_pb_cal within w_mat_03550
end type
type rr_1 from roundrectangle within w_mat_03550
end type
type rr_2 from roundrectangle within w_mat_03550
end type
end forward

global type w_mat_03550 from w_standard_print
string title = "출고증"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_mat_03550 w_mat_03550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string jpno1, jpno2, sgub, sfilter, date1, date2, ls_saupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sgub  = dw_ip.object.gub[1]

jpno1 = trim(dw_ip.object.jpno1[1])
jpno2 = trim(dw_ip.object.jpno2[1])
date1 = trim(dw_ip.object.date1[1])
date2 = trim(dw_ip.object.date2[1])
ls_saupj = trim(dw_ip.object.saupj[1])
sfilter = dw_ip.object.sfilter[1]

if (IsNull(jpno1) or jpno1 = "")  then jpno1 = "."
if (IsNull(jpno2) or jpno2 = "")  then jpno2 = "ZZZZZZZZZZZZ"

if (IsNull(date1) or date1 = "")  then date1 = f_today()
if (IsNull(date2) or date2 = "")  then date2 = f_today()

if sgub = '1' then 
   dw_list.DataObject = 'd_mat_03550_02'
	dw_print.DataObject = 'd_mat_03550_02_p'
elseIF sgub = '2' then 	
   dw_list.DataObject = 'd_mat_03550_03'
	dw_print.DataObject = 'd_mat_03550_03_p'
elseIF sgub = '3' then 	
   dw_list.DataObject = 'd_mat_03550_04'
	dw_print.DataObject = 'd_mat_03550_04_p'
elseIF sgub = '4' then 	
   dw_list.DataObject = 'd_mat_03550_05'	
	dw_print.DataObject = 'd_mat_03550_05_p'
end if
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

	
IF sgub = '3' or sgub = '4' then 
	dw_list.setfilter("")
ELSE
	IF sfilter = '1' then //전체
		dw_list.setfilter("")
	ELSE
		dw_list.setfilter("ioseq <> '999'")
	END IF   
END IF
dw_list.filter()	

Long Lrow = 0
//if sgub = '4' then
//   Lrow = dw_list.Retrieve(gs_sabu, date1, date2) 
//Else
//   Lrow = dw_list.Retrieve(gs_sabu, jpno1, jpno2)
//End if
//
//if Lrow < 1 then
//	f_message_chk(50,'[출고증]')
//	dw_ip.Setfocus()
//	return -1
//end if

if sgub = '4' then
	IF dw_print.Retrieve(gs_sabu, date1, date2, ls_saupj, ls_saupj) <= 0 then
		f_message_chk(50,'[출고증]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)

Else
	IF dw_print.Retrieve(gs_sabu, jpno1, jpno2,ls_saupj, date1, date2) <= 0 then
		f_message_chk(50,'[출고증]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)
End if

return 1
end function

on w_mat_03550.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_mat_03550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;//사업장
f_mod_saupj(dw_ip, 'saupj' )

dw_ip.SetItem(1, 'date1',f_today())
dw_ip.SetItem(1, 'date2',f_today())
end event

type p_preview from w_standard_print`p_preview within w_mat_03550
end type

type p_exit from w_standard_print`p_exit within w_mat_03550
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_mat_03550
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03550
end type







type st_10 from w_standard_print`st_10 within w_mat_03550
end type



type dw_print from w_standard_print`dw_print within w_mat_03550
string dataobject = "d_mat_03550_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03550
integer x = 59
integer y = 44
integer width = 3346
integer height = 288
string dataobject = "d_mat_03550_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;// 출고번호
setnull(gs_code)
setnull(gs_codename)

if this.getcolumnname() = "jpno1" 	then
   IF this.getitemstring(1, 'gub') = '1' then 
		gs_gubun = '001'
		open(w_chulgo_popup)
	ELSE	
		gs_gubun = '002'
		open(w_chulgo_popup2)
   END IF
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno1", Left(gs_code,12))
ElSEif this.getcolumnname() = "jpno2" 	then
   IF this.getitemstring(1, 'gub') = '1' then 
		gs_gubun = '001'
		open(w_chulgo_popup)
	ELSE	
		gs_gubun = '002'
		open(w_chulgo_popup2)
   END IF
   if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno2", Left(gs_code,12))
end if

end event

event dw_ip::itemchanged;string sfilter, sgubun

IF this.GetColumnName() = 'sfilter' THEN
	sfilter  = TRIM(this.gettext())
	sgubun  = this.getitemstring(1, 'gub')
	
	IF sgubun = '3'  then 
		dw_list.setfilter("")
	ELSE
		IF sfilter = '1' then //전체
  			dw_list.setfilter("")
		ELSE
  			dw_list.setfilter("ioseq <> '999'")
		END IF   
	END IF
	
	dw_list.filter()	
END IF

end event

type dw_list from w_standard_print`dw_list within w_mat_03550
integer x = 50
integer y = 376
integer width = 4544
integer height = 1908
string dataobject = "d_mat_03550_02"
end type

type pb_1 from u_pb_cal within w_mat_03550
integer x = 800
integer y = 224
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('date1')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'date1', gs_code)



end event

type pb_2 from u_pb_cal within w_mat_03550
integer x = 1330
integer y = 224
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('date2')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'date2', gs_code)



end event

type rr_1 from roundrectangle within w_mat_03550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 36
integer width = 3511
integer height = 304
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_03550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 360
integer width = 4576
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type


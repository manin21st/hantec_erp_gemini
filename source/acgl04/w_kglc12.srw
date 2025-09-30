$PBExportHeader$w_kglc12.srw
$PBExportComments$전표별 원가부문 등록
forward
global type w_kglc12 from w_inherite
end type
type dw_cond from u_key_enter within w_kglc12
end type
type dw_1 from u_key_enter within w_kglc12
end type
type rr_1 from roundrectangle within w_kglc12
end type
end forward

global type w_kglc12 from w_inherite
string title = "전표별 원가부문 등록"
dw_cond dw_cond
dw_1 dw_1
rr_1 rr_1
end type
global w_kglc12 w_kglc12

on w_kglc12.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_kglc12.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_cond.SetTransObject(Sqlca)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(1,"saupj", Gs_Saupj)
dw_cond.SetItem(1,"fdate", Left(F_Today(),6)+'01')
dw_cond.SetItem(1,"tdate", F_Today())
dw_cond.SetItem(1,"dept",  Gs_Dept)

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 1")
	dw_cond.Modify("dept.protect = 1")	
	
ELSE
	dw_cond.Modify("saupj.protect = 0")
	dw_cond.Modify("dept.protect = 0")	
END IF	

dw_1.SetTransObject(Sqlca)

end event

type dw_insert from w_inherite`dw_insert within w_kglc12
boolean visible = false
integer x = 101
integer y = 2580
integer taborder = 70
end type

type p_delrow from w_inherite`p_delrow within w_kglc12
integer x = 3831
integer y = 3600
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc12
integer x = 3657
integer y = 3600
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc12
integer x = 3127
integer y = 3600
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kglc12
integer x = 3483
integer y = 3600
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglc12
integer x = 4439
integer y = 16
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kglc12
integer x = 4265
integer y = 16
integer taborder = 50
end type

event p_can::clicked;call super::clicked;

dw_1.Reset()
end event

type p_print from w_inherite`p_print within w_kglc12
integer x = 3301
integer y = 3600
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kglc12
integer x = 3918
integer y = 16
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;
String sSaupj,sFdate,sTdate,sAcGbn,sFacc,sTacc,sDept

dw_cond.AcceptText()
sSaupj  = dw_cond.GetItemString(1,"saupj")
sFdate  = dw_cond.GetItemString(1,"fdate")
sTdate  = dw_cond.GetItemString(1,"tdate")
sAcGbn  = dw_cond.GetItemString(1,"acc_gbn")
sDept   = dw_cond.GetItemString(1,"dept")

if sSaupj = '' or IsNull(sSaupj) then
	F_MessageChk(1,'[사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return
end if

if sFdate = '' or IsNull(sFdate) then
	F_MessageChk(1,'[회계일자]')
	dw_cond.SetColumn("fdate")
	dw_cond.SetFocus()
	Return
end if

if sTdate = '' or IsNull(sTdate) then
	F_MessageChk(1,'[회계일자]')
	dw_cond.SetColumn("tdate")
	dw_cond.SetFocus()
	Return
end if

if sAcGbn = '' or IsNull(sAcGbn) then
	F_MessageChk(1,'[구분]')
	dw_cond.SetColumn("acc_gbn")
	dw_cond.SetFocus()
	Return
else
	select substr(rfna2,1,5),substr(rfna2,6,5) into :sFacc, :sTacc from reffpf 
		where rfcod = 'BM' and rfgub = :sAcGbn;
end if
if sDept = '' or IsNull(sDept) then sDept = '%'

//DataWindowChild Dw_Child
//Integer    iVal
//
//iVal = dw_1.GetChild("sdept_cd",Dw_Child)
//IF iVal = 1 THEN
//	dw_child.SetTransObject(Sqlca)
//	IF dw_child.Retrieve(sSaupj) <=0 THEN
//		dw_child.InsertRow(0)
//	END IF	
//END IF

if dw_1.Retrieve(sSaupj,sFdate,sTdate,sFacc,sTacc,sDept) <=0 then
	F_MessageChk(14,'')
	Return
end if



end event

type p_del from w_inherite`p_del within w_kglc12
integer x = 4178
integer y = 3600
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglc12
integer x = 4091
integer y = 16
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;Integer k

IF dw_1.AcceptText() = -1 THEN RETURN 

FOR k = 1 to dw_1.RowCount()
	if dw_1.GetItemString(k,"sdept_cd") = '' or IsNull(dw_1.GetItemString(k,"sdept_cd")) then
		F_MessageChk(1,'[원가부문]')
		dw_1.SetColumn("sdept_cd")
		dw_1.ScrollToRow(k)
		dw_1.SetFocus()
		Return
	end if
NEXT

IF f_dbconfirm("등록") = 2 THEN RETURN

IF	dw_1.Update() = 1 THEN	
	COMMIT;
	
	w_mdi_frame.sle_msg.text =" 자료가 저장되었습니다.!!!"
	ib_any_typing=False
ELSE
	ROLLBACK;	
	f_messagechk(13,"")
	dw_1.SetFocus()
END IF


end event

type cb_exit from w_inherite`cb_exit within w_kglc12
boolean visible = false
end type

type cb_mod from w_inherite`cb_mod within w_kglc12
boolean visible = false
end type

type cb_ins from w_inherite`cb_ins within w_kglc12
boolean visible = false
end type

type cb_del from w_inherite`cb_del within w_kglc12
boolean visible = false
end type

type cb_inq from w_inherite`cb_inq within w_kglc12
boolean visible = false
end type

type cb_print from w_inherite`cb_print within w_kglc12
boolean visible = false
end type

type st_1 from w_inherite`st_1 within w_kglc12
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglc12
boolean visible = false
end type

type cb_search from w_inherite`cb_search within w_kglc12
boolean visible = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kglc12
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kglc12
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kglc12
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc12
boolean visible = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc12
boolean visible = false
end type

type dw_cond from u_key_enter within w_kglc12
integer x = 59
integer y = 20
integer width = 3758
integer height = 156
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kglc121"
boolean border = false
end type

type dw_1 from u_key_enter within w_kglc12
integer x = 78
integer y = 192
integer width = 4517
integer height = 2040
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kglc122"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type rr_1 from roundrectangle within w_kglc12
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 64
integer y = 184
integer width = 4544
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type


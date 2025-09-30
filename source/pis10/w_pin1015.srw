$PBExportHeader$w_pin1015.srw
$PBExportComments$비품등록
forward
global type w_pin1015 from w_inherite_multi
end type
type dw_3 from datawindow within w_pin1015
end type
type dw_1 from u_d_popup_sort within w_pin1015
end type
type dw_2 from u_key_enter within w_pin1015
end type
type st_2 from statictext within w_pin1015
end type
type rr_1 from roundrectangle within w_pin1015
end type
type rr_2 from roundrectangle within w_pin1015
end type
end forward

global type w_pin1015 from w_inherite_multi
string title = "비품등록"
dw_3 dw_3
dw_1 dw_1
dw_2 dw_2
st_2 st_2
rr_1 rr_1
rr_2 rr_2
end type
global w_pin1015 w_pin1015

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saup,ls_large,ls_middle,ls_little,ls_dept

if dw_3.AcceptText() = -1 then return 1

ls_saup = dw_3.GetItemString(1,"sabu")
ls_large = dw_3.GetItemString(1,"large")
ls_middle = dw_3.GetItemString(1,"middle")
ls_little = dw_3.GetItemString(1,"little")
ls_dept = dw_3.GetItemString(1,"dept")

if isnull(ls_saup) or ls_saup = '' then 	ls_saup = '%'
if isnull(ls_large) or ls_large = '' then	ls_large = '%'
if isnull(ls_middle) or ls_middle = '' then	ls_middle = '%'
if isnull(ls_little) or ls_little = '' then	ls_little = '%'
if isnull(ls_dept) or ls_dept = '' then	ls_dept = '%'

if dw_1.retrieve(ls_saup,ls_large,ls_middle,ls_little,ls_dept) < 1 then
	messagebox("조회","조회할 자료가 없습니다!")
	return -1 
end if
w_mdi_frame.sle_msg.text = "조회되었습니다!"
setpointer(Arrow!)

return 1
end function

on w_pin1015.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_pin1015.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_3)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_2.insertrow(0)
dw_3.settransobject(sqlca)
dw_3.insertrow(0) 

f_set_saupcd(dw_3, 'sabu', '1')
is_saupcd = gs_saupcd

p_inq.TriggerEvent(Clicked!)
end event

type p_delrow from w_inherite_multi`p_delrow within w_pin1015
boolean visible = false
integer x = 4160
integer y = 3304
end type

type p_addrow from w_inherite_multi`p_addrow within w_pin1015
boolean visible = false
integer x = 3986
integer y = 3304
end type

type p_search from w_inherite_multi`p_search within w_pin1015
boolean visible = false
integer x = 3593
integer y = 3268
end type

type p_ins from w_inherite_multi`p_ins within w_pin1015
boolean visible = false
integer x = 3625
integer y = 3064
end type

event p_ins::clicked;call super::clicked;long curr_row

curr_row = dw_1.insertrow(0)
//dw_1.setitem(curr_row, "codegbn", dw_detail.getitemstring(1, "codegbn"))

dw_1.setcolumn(1)
dw_1.setrow(curr_row)
dw_1.scrolltorow(curr_row)
dw_1.setfocus()
end event

type p_exit from w_inherite_multi`p_exit within w_pin1015
end type

type p_can from w_inherite_multi`p_can within w_pin1015
end type

event p_can::clicked;call super::clicked;dw_1.setredraw(false)
dw_1.reset()
p_inq.triggerevent(clicked!)
dw_1.setredraw(true)

dw_2.setredraw(false)
dw_2.reset()
dw_2.insertrow(0)
dw_2.setredraw(true)
dw_2.setfocus()

end event

type p_print from w_inherite_multi`p_print within w_pin1015
boolean visible = false
integer x = 3767
integer y = 3268
end type

type p_inq from w_inherite_multi`p_inq within w_pin1015
integer x = 3698
end type

event p_inq::clicked;call super::clicked;if wf_retrieve() = -1 then
	return 
end if
	
end event

type p_del from w_inherite_multi`p_del within w_pin1015
end type

event p_del::clicked;call super::clicked;IF messagebox("확인","삭제하시겠습니까?",Question!,YesNo!,2) = 1 THEN
	dw_2.Deleterow(0)
	dw_2.update()
	commit;
ELSE
	f_messagechk(13,'')
	ROLLBACK;
END IF

p_can.Triggerevent(clicked!)
	
end event

type p_mod from w_inherite_multi`p_mod within w_pin1015
end type

event p_mod::clicked;call super::clicked;string ls_gbn1,ls_gbn2,ls_gbn3,ls_name,ls_indate,ls_outdate, &
       ls_saupcd,ls_madept,ls_usedept,ls_user,ls_gojung1,ls_gojung2
long  ll_qty,ll_get_seq,ll_seq,ll_inamt,ll_outamt,ll_row,ll_gojung2, ls_seq
int cnt

IF dw_2.AcceptText() <> 1 THEN RETURN -1

ls_seq =     dw_2.GetItemDecimal(1,"seq")
ls_gbn1 =    dw_2.GetItemString(1,"gbn1")
ls_gbn2 =    dw_2.GetItemString(1,"gbn2")
ls_gbn3 =    dw_2.GetItemString(1,"gbn3")
ls_name =    dw_2.GetItemString(1,"sname")
ls_indate =  dw_2.GetItemString(1,"indate")
ls_outdate = dw_2.GetItemString(1,"outdate")
ls_saupcd =  dw_2.GetItemString(1,"saupcd")
ls_madept =  dw_2.GetItemString(1,"madept")
ls_usedept = dw_2.GetItemString(1,"usedept")
ls_user =    dw_2.GetItemString(1,"userid")
ls_gojung1 = LEFT(dw_2.GetItemString(1,"gojung"),1)
ll_qty =     dw_2.GetItemDecimal(1,"dataqty")
ll_inamt =   dw_2.GetItemDecimal(1,"inamt")
ll_outamt =  dw_2.GetItemDecimal(1,"outamt")
ls_gojung2 = MID(dw_2.GetitemString(1,"gojung"),2,8)

SELECT MAX(SEQ)                       //마지막 번호 채번
  INTO :ll_get_seq
  FROM P1_BIPUM
 WHERE GBN1 = :ls_gbn1 AND
       GBN2 = :ls_gbn2 AND
		 GBN3 = :ls_gbn3  ;
		 
SELECT count(*)                       //마지막 번호 채번
  INTO :cnt
  FROM P1_BIPUM
 WHERE GBN1 = :ls_gbn1 AND
       GBN2 = :ls_gbn2 AND
		 GBN3 = :ls_gbn3 AND
		 seq  = :ls_seq;	 
		 
IF isnull(ll_get_seq) or ll_get_seq = 0 THEN  //번호부여
	ll_seq = 1
ELSE
	ll_seq = ll_get_seq + 1
END IF

ll_gojung2 = long(ls_gojung2)

if cnt> 0 and ll_qty > 0 or cnt <= 0 and ll_qty > 0 then

FOR ll_row = 1 TO ll_qty
	 
//  dw_2.Setitem(ll_row,"seq",string(ll_seq,'000'))
//	 dw_2.SetItem(ll_row,"qty",'1')
//	 dw_2.SetItem(ll_row,"gbn1",ls_gbn1)
//	 dw_2.SetItem(ll_row,"gbn2",ls_gbn2)
//	 dw_2.SetItem(ll_row,"gbn3",ls_gbn3)	 
//	 dw_2.SetItem(ll_row,"name",ls_name)	 
//  dw_2.SetItem(ll_row,"indate",ls_indate)	 
//  dw_2.SetItem(ll_row,"outdate",ls_outdate)
//  dw_2.SetItem(ll_row,"saupcd",ls_saupcd)	
//	 dw_2.SetItem(ll_row,"madept",ls_madept)	 
//	 dw_2.SetItem(ll_row,"usedept",ls_usedept)	 
//	 dw_2.SetItem(ll_row,"user",ls_user)	 
//	 dw_2.SetItem(ll_row,"gojung",ls_gojung1+ls_gojung2)	 
//	 dw_2.SetItem(ll_row,"inamt",ll_inamt)	 
//  dw_2.SetItem(ll_row,"outamt",ll_outamt)
//  dw_2.SetItem(ll_row,"gojung",ll_gojung2)	 
		INSERT INTO p1_bipum
	             ("GBN1","GBN2","SEQ","SNAME","QTY","INDATE","INAMT","OUTDATE","OUTAMT",
                 "SAUPCD","MADEPT","USEDEPT","USERID","GBN3","KOJUNG1","KOJUNG2")
			VALUES (:ls_gbn1,:ls_gbn2,:ll_seq,:ls_name,1,:ls_indate,:ll_inamt,:ls_outdate,:ll_outamt,:ls_saupcd,:ls_madept,
			        :ls_usedept,:ls_user,:ls_gbn3,:ls_gojung1,:ll_gojung2) ;

	ll_seq++
	
NEXT
else
	if dw_2.Update() = 1 then
		commit;
	else
		rollback;
		messagebox("저장실패","자료저장에 실패했습니다.")
		return
   end if
end if
commit;
//if sqlca.sqlnrows > 0 then
//	commit;
//	messagebox("자료저장","자료가 저장되었습니다.")
//else
//	rollback;
//	messagebox("저장실패","자료저장에 실패했습니다.")
//end if

p_inq.triggerevent(clicked!)

w_mdi_frame.sle_msg.text = "저장되었습니다."
dw_2.reset()
dw_2.insertrow(0)
dw_2.setfocus()
end event

type dw_insert from w_inherite_multi`dw_insert within w_pin1015
boolean visible = false
integer x = 82
integer y = 2768
integer width = 128
integer height = 104
end type

type st_window from w_inherite_multi`st_window within w_pin1015
boolean visible = false
integer x = 2181
integer y = 3292
end type

type cb_append from w_inherite_multi`cb_append within w_pin1015
boolean visible = false
integer x = 448
integer y = 3120
end type

type cb_exit from w_inherite_multi`cb_exit within w_pin1015
boolean visible = false
integer x = 3177
integer y = 3120
end type

type cb_update from w_inherite_multi`cb_update within w_pin1015
boolean visible = false
integer x = 2080
integer y = 3120
end type

type cb_insert from w_inherite_multi`cb_insert within w_pin1015
boolean visible = false
integer x = 1353
integer y = 3120
end type

type cb_delete from w_inherite_multi`cb_delete within w_pin1015
boolean visible = false
integer x = 2446
integer y = 3120
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pin1015
boolean visible = false
integer x = 82
integer y = 3120
end type

type st_1 from w_inherite_multi`st_1 within w_pin1015
boolean visible = false
integer x = 18
integer y = 3292
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pin1015
boolean visible = false
integer x = 2811
integer y = 3120
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pin1015
boolean visible = false
integer x = 2830
integer y = 3292
end type

type sle_msg from w_inherite_multi`sle_msg within w_pin1015
boolean visible = false
integer x = 347
integer y = 3292
end type

type gb_2 from w_inherite_multi`gb_2 within w_pin1015
boolean visible = false
integer x = 2039
integer y = 3060
end type

type gb_1 from w_inherite_multi`gb_1 within w_pin1015
boolean visible = false
integer x = 37
integer y = 3060
integer width = 430
end type

type gb_10 from w_inherite_multi`gb_10 within w_pin1015
boolean visible = false
integer x = 0
integer y = 3240
end type

type dw_3 from datawindow within w_pin1015
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 238
integer y = 132
integer width = 1687
integer height = 464
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pin1015"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key();IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;this.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

end event

type dw_1 from u_d_popup_sort within w_pin1015
integer x = 261
integer y = 612
integer width = 1659
integer height = 1480
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pin1015_01"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;
IF dw_1.GetColumnName() = "madept" THEN
//   SetNull(gs_code)
	SetNull(gs_codename)
	
	open(w_dept_popup)
	
   IF IsNull(Gs_code) THEN RETURN
		dw_1.SetITem(1,"madept",gs_codename)
 
END IF

	
end event

event doubleclicked;call super::doubleclicked;//string ls_user,ls_ename
//long ll_seq
//
//IF row <=0 THEN RETURN
//
//SelectRow(0,False)
//SelectRow(row,True)
//
//ll_seq = dw_1.getitemdecimal(row, "seq")
//
//if dw_2.retrieve(ll_seq) < 0 then
//	dw_2.SetFocus()
//	return
//end if
//
//SELECT "A"."USER"
//  INTO :ls_user
//  FROM p1_bipum A 
// WHERE "A"."SEQ" = :ll_seq;
//
//SELECT empname
//  INTO :ls_ename
//  FROM p1_master
// WHERE empno = :ls_user;
//	 
//dw_2.setitem(1,"empname",ls_ename)
//
//dw_2.setfocus()
end event

event clicked;call super::clicked;string ls_user,ls_ename, sabu, sgbn1,sgbn2,sgbn3
long ll_seq

IF row <=0 THEN RETURN

SelectRow(0,False)
SelectRow(row,True)

ll_seq = dw_1.getitemdecimal(row, "seq")
sabu = dw_1.getitemstring(row,"saupcd")
sgbn1 = dw_1.getitemstring(row,"gbn1")
sgbn2 = dw_1.getitemstring(row,"gbn2")
sgbn3 = dw_1.getitemstring(row,"gbn3")

if dw_2.retrieve(sabu,sgbn1,sgbn2,sgbn3,ll_seq) < 0 then
	dw_2.SetFocus()
	return
end if
//
//SELECT "A"."USER"
//  INTO :ls_user
//  FROM p1_bipum A 
// WHERE "A"."SEQ" = :ll_seq;
//
//SELECT empname
//  INTO :ls_ename
//  FROM p1_master
// WHERE empno = :ls_user;
//	 
//dw_2.setitem(1,"empname",ls_ename)

//dw_2.setfocus()
end event

type dw_2 from u_key_enter within w_pin1015
event ue_key pbm_dwnkey
integer x = 2043
integer y = 320
integer width = 2117
integer height = 1692
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pin1015_02"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;IF dw_2.GetColumnName() = "userid" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
	
	open(w_employee_popup)
	
   IF IsNull(Gs_code) THEN RETURN
      dw_2.SetItem(1,"userid",gs_code)
		dw_2.SetITem(1,"empname",gs_codename)
END IF	

IF dw_2.GetColumnName() = "gojung" THEN
	SetNull(gi_page)
	SetNull(gs_code)
	SetNull(gs_codename)
	
	open(w_gojung_popup)
	
   IF IsNull(Gs_code) THEN RETURN
      dw_2.SetItem(1,"gojung",gs_code + string(gi_page))
		dw_2.SetITem(1,"kfname",gs_codename)
END IF	
IF dw_2.GetColumnName() = "madept"  THEN
	SetNull(gs_code)
	SetNull(gs_codename)
	
	open(w_dept_popup)
	
   IF IsNull(Gs_code) THEN RETURN
      dw_2.SetItem(1,"madept",gs_code )

ELSEIF dw_2.GetColumnName() = "usedept" then
	
	SetNull(gs_code)
	SetNull(gs_codename)
	
	open(w_dept_popup)
	
   IF IsNull(Gs_code) THEN RETURN
      dw_2.SetItem(1,"usedept",gs_code )

END IF	
end event

event itemchanged;call super::itemchanged;string sempno, sname, sno, skoname

if GetColumnName() = "userid" then
	sempno = this.Gettext()
	
	select empname into :sname
	from p1_master
	where companycode = :gs_company and empno = :sempno;
	
	dw_2.setitem(dw_2.getrow(),"empname",sname)
	
end if

if GetColumnName() = "kojung" then
	sno = this.Gettext()
	
	select kfname into :skoname
	from fra02om0
	where kfcod1 = substr(sno,1,1) and
	      kfcod2 = substr(sno,2,8);
			
	dw_2.setitem(dw_2.getrow(), "kfname", skoname)

end if
end event

type st_2 from statictext within w_pin1015
integer x = 238
integer y = 60
integer width = 1934
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* 대분류, 중분류, 소분류 항목은 참조코드등록에서 등록하실 수 있습니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pin1015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 247
integer y = 604
integer width = 1682
integer height = 1500
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pin1015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2021
integer y = 196
integer width = 2249
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 46
end type


$PBExportHeader$w_pdt_07600.srw
$PBExportComments$집계공정코드 관리(생산일보에서 사용)
forward
global type w_pdt_07600 from w_inherite
end type
type dw_insert1 from u_key_enter within w_pdt_07600
end type
type gb_1 from groupbox within w_pdt_07600
end type
type st_2 from statictext within w_pdt_07600
end type
type st_3 from statictext within w_pdt_07600
end type
end forward

global type w_pdt_07600 from w_inherite
integer x = 270
integer y = 212
integer width = 3218
integer height = 1992
string title = "집계공정코드 등록"
string menuname = ""
boolean minbox = false
windowtype windowtype = response!
dw_insert1 dw_insert1
gb_1 gb_1
st_2 st_2
st_3 st_3
end type
global w_pdt_07600 w_pdt_07600

on w_pdt_07600.create
int iCurrent
call super::create
this.dw_insert1=create dw_insert1
this.gb_1=create gb_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_insert1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
end on

on w_pdt_07600.destroy
call super::destroy
destroy(this.dw_insert1)
destroy(this.gb_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event open;call super::open;String  sii, Sname
Integer ii, jj

For ii = 1 to 9 
	
	 sII = string(ii)
	 Select rfna1 into :sName
	 	From reffpf
	  Where rfcod = '1B' and rfgub = :sII;
	  
	 jj = dw_insert.insertrow(ii)
	 dw_insert.setitem(jj, "no", 		sII)
	 dw_insert.setitem(jj, "name", 	sName)
	
NExt

dw_insert1.settransobject(sqlca)
dw_insert1.retrieve(gs_sabu)
end event

type dw_insert from w_inherite`dw_insert within w_pdt_07600
integer x = 151
integer y = 128
integer width = 1312
integer height = 1068
string dataobject = "d_pdt_07600_1"
boolean vscrollbar = true
end type

type p_delrow from w_inherite`p_delrow within w_pdt_07600
end type

type p_addrow from w_inherite`p_addrow within w_pdt_07600
end type

type p_search from w_inherite`p_search within w_pdt_07600
end type

type p_ins from w_inherite`p_ins within w_pdt_07600
end type

type p_exit from w_inherite`p_exit within w_pdt_07600
end type

type p_can from w_inherite`p_can within w_pdt_07600
end type

type p_print from w_inherite`p_print within w_pdt_07600
end type

type p_inq from w_inherite`p_inq within w_pdt_07600
end type

type p_del from w_inherite`p_del within w_pdt_07600
end type

type p_mod from w_inherite`p_mod within w_pdt_07600
end type

type cb_exit from w_inherite`cb_exit within w_pdt_07600
integer x = 1102
integer y = 1564
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_pdt_07600
integer x = 750
integer y = 1564
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;setpointer(hourglass!)

sle_msg.text = '자료를 저장중입니다!'

sTring sno, sname
Integer ii

if dw_insert.accepttext()  = -1 then return
if dw_insert1.accepttext() = -1 then return

for ii = 1 to 9
	 sno 		= dw_insert.getitemstring(ii, "no")
	 sname 	= dw_insert.getitemstring(ii, "name")	
	 
	 Insert into reffpf
	 	(sabu, 			rfcod,		rfgub,		rfna1,		rfna2)
	 Values
	 	(:gs_sabu,		'1B',		:sno,			:sname,		:sname);
		 
	 if sqlca.sqlcode <> 0 then
		 Update reffpf
		 	 set rfna1 = :sname,
			  	  rfna2 = :sname
		  Where sabu = '1' and rfcod = '1B' and rfgub = :sno;
		  if sqlca.sqlcode <> 0 then
			  rollback;
			  sle_msg.text = '집계공정코드 저장시 ERROR'
			  f_rollback()
			  return;
		  end if	  
	 End if
	
Next

DELETE FROM "ROUTNG_SUM"  ;
if sqlca.sqlcode <> 0 then
   rollback;
	sle_msg.text = '공정코드 삭제시 ERROR'
	f_rollback()
	return;
End if

For ii = 1 to dw_insert1.rowcount()
	 sno 		= dw_insert1.getitemString(ii, "rsl_opseq")
	 sname	= dw_insert1.getitemstring(ii, "rfgub")
	 
	 if isnull(sno) or trim(sno) = '' then
		 sno = '9'
	 end if

	 insert into routng_sum
	 		(sabu,		rsl_opseq,		roslt,		rsl_name)
		values
			(:gs_sabu,	:sno,				:sname,		null);
			
	 if sqlca.sqlcode <> 0 then
	    rollback;
	    sle_msg.text = '공정코드 저장시 ERROR'
	    f_rollback()
	    return;
	 End if
Next

dw_insert1.retrieve(gs_sabu)

Messagebox("자료저장", "자료저장을 완료하였읍니다", information!)
sle_msg.text = ''

ib_any_typing = false

commit;

setpointer(arrow!)
end event

type cb_ins from w_inherite`cb_ins within w_pdt_07600
boolean visible = false
integer x = 878
integer y = 2424
integer taborder = 40
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_07600
boolean visible = false
integer x = 1239
integer y = 2428
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_07600
boolean visible = false
integer x = 1641
integer y = 2436
integer taborder = 70
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdt_07600
boolean visible = false
integer x = 2043
integer y = 2420
integer taborder = 80
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_07600
integer y = 1776
end type

type cb_can from w_inherite`cb_can within w_pdt_07600
boolean visible = false
integer x = 2437
integer y = 2428
integer taborder = 90
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdt_07600
boolean visible = false
integer x = 2825
integer y = 2420
integer taborder = 100
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pdt_07600
integer x = 2409
integer y = 1776
end type

type sle_msg from w_inherite`sle_msg within w_pdt_07600
integer y = 1776
integer width = 2030
end type

type gb_10 from w_inherite`gb_10 within w_pdt_07600
integer y = 1724
integer width = 3159
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_07600
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_07600
end type

type dw_insert1 from u_key_enter within w_pdt_07600
integer x = 1577
integer y = 120
integer width = 1577
integer height = 1580
integer taborder = 20
string dataobject = "d_pdt_07600_2"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_pdt_07600
integer x = 704
integer y = 1504
integer width = 773
integer height = 196
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type st_2 from statictext within w_pdt_07600
integer x = 151
integer y = 44
integer width = 626
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "[ 참조코드 ~'1B~' ]"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdt_07600
integer x = 1577
integer y = 44
integer width = 626
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "[ 참조코드 ~'21~' ]"
boolean focusrectangle = false
end type


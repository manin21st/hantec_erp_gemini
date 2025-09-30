$PBExportHeader$w_pdt_02030_4.srw
$PBExportComments$제품할당
forward
global type w_pdt_02030_4 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pdt_02030_4
end type
type dw_update from datawindow within w_pdt_02030_4
end type
type cb_3 from commandbutton within w_pdt_02030_4
end type
type st_2 from statictext within w_pdt_02030_4
end type
type sle_itdsc from singlelineedit within w_pdt_02030_4
end type
type rr_2 from roundrectangle within w_pdt_02030_4
end type
end forward

global type w_pdt_02030_4 from w_inherite_popup
integer x = 46
integer y = 628
integer width = 3657
integer height = 1164
string title = "제품할당"
rr_1 rr_1
dw_update dw_update
cb_3 cb_3
st_2 st_2
sle_itdsc sle_itdsc
rr_2 rr_2
end type
global w_pdt_02030_4 w_pdt_02030_4

type variables
string isitnbr, isitdsc, ispspec, isporder
str_02030 parm02030

end variables

on w_pdt_02030_4.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_update=create dw_update
this.cb_3=create cb_3
this.st_2=create st_2
this.sle_itdsc=create sle_itdsc
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_update
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_itdsc
this.Control[iCurrent+6]=this.rr_2
end on

on w_pdt_02030_4.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.dw_update)
destroy(this.cb_3)
destroy(this.st_2)
destroy(this.sle_itdsc)
destroy(this.rr_2)
end on

event open;call super::open;/* parm02030의 structrue
	datawindow, 품명, 할당번호 */


parm02030 = message.powerobjectparm

sle_itdsc.text = parm02030.sitdsc
dw_1.settransobject(sqlca)

f_window_center_response(this)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_02030_4
boolean visible = false
integer x = 155
integer y = 1332
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_pdt_02030_4
integer x = 3424
integer y = 12
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdt_02030_4
integer x = 3077
integer y = 12
end type

event p_inq::clicked;call super::clicked;dw_1.retrieve(sle_itdsc.text + '%')

Long 		lrow, lcnt
String 	sitnbr, 	spspec, 	sdepot_no, 	sPordno

Decimal {3} dwiqty
datawindow dwname

dw_1.accepttext()

dwname  = parm02030.dwname
spordno = dwname.getitemstring(dwname.getrow(), "momast_copy_pordno")

For Lrow = 1 to dw_1.rowcount()
	  
	 sitnbr    = dw_1.getitemstring(lrow, "stock_itnbr")
	 spspec    = dw_1.getitemstring(lrow, "stock_pspec")
	 sdepot_no = dw_1.getitemstring(lrow, "stock_depot_no")
	 
	 dWiqty 	  = 0;
	 Select hold_qty 
	 	Into :dWiqty 
		From Holdstock_copy
	  Where Sabu 		= :gs_sabu And pordno = :sPordno
	  	 And itnbr		= :sItnbr	And pspec  = :sPspec   And hold_store = :sDepot_no
		 And hold_gu	= 'O14';
		 
	 if dwiqty > 0 then
		 dw_1.setitem(Lrow, "wiqty", dWiqty)
	 end if   
		  
Next


end event

type p_choose from w_inherite_popup`p_choose within w_pdt_02030_4
integer x = 3250
integer y = 12
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_choose::clicked;call super::clicked;call super::clicked;Long lrow, lcnt
String sitnbr, spspec, sdepot_no, sjpno, stoday, spdtgu, sstrdate, sinstore, &
		 spordno, sholdno, sdptno, sopseq, smaxno

Decimal {3} dwiqty
integer ino, icnt
datawindow dwname

if dw_1.accepttext() = -1 then return 

SetPointer(HourGlass!)

stoday  = f_today()

lcnt = 0
icnt = 0
dwname  = parm02030.dwname
sstrdate = dwname.getitemstring(dwname.getrow(), "momast_copy_esdat")
spordno = dwname.getitemstring(dwname.getrow(), "momast_copy_pordno")
spdtgu  = dwname.getitemstring(dwname.getrow(), "momast_copy_pdtgu")
Select cvcod, deptcode into :sinstore, :sdptno from vndmst
 where cvgu = '5' and jumaeip = :spdtgu;
If sqlca.sqlcode <> 0 then
	f_message_chk(104,'[생산팀에 대한 창고코드]') 	
	return
End if

/* 할당번호 채번 */
SEtnull(sMaxno)
Select Max(hold_no) into :sMaxno from holdstock_copy
 Where sabu   = :gs_sabu 
 	And pordno = :sPordno;
	 
if isnull( smaxno ) then
	ino = sqlca.fun_junpyo(gs_sabu, stoday, 'B0')
	if ino < 1 then
		f_message_chk(51,'[할당번호]') 
		rollback;
		return -1
	end if
else
	ino 	= dec(mid(sMaxno,  9, 4))
	icnt 	= dec(mid(sMaxno, 13, 3))
end if

sjpno   = stoday+string(ino, '0000')

/* 기존의 내역을 삭제한다(사양개조 출고만 삭제) */
Delete 
  From holdstock_copy 
 Where sabu 	  = :gs_sabu and Pordno = :sPordno
						   		  and hold_gu = 'O14';
									  
/* 최초공정을 구한다 */
Select Min(opseq) into :sOpseq from morout_copy
 Where sabu   = :gs_sabu 
 	And pordno = :sPordno;
	 
If sqlca.sqlcode <> 0 then
	f_message_chk(104,'[최초공정]') 	
	return
End if	 

Commit;

lcnt = icnt

For Lrow = 1 to dw_1.rowcount()
	
	 dwiqty = dw_1.getitemdecimal(lrow, "wiqty")
	 If dwiqty < 1 then
		 continue
	 End if
	 
	 lcnt++
	 sholdno	  = sjpno+string(lcnt, '000')
	  
	 sitnbr    = dw_1.getitemstring(lrow, "stock_itnbr")
	 spspec    = dw_1.getitemstring(lrow, "stock_pspec")
	 sdepot_no = dw_1.getitemstring(lrow, "stock_depot_no")
	 
  INSERT INTO HOLDSTOCK_COPY
			(SABU,			HOLD_NO,				HOLD_DATE,				HOLD_GU,				ITNBR,
			 PSPEC,			HOLD_QTY,			ADDQTY,					ISQTY,				UNQTY,
			 HOLD_STORE,	OUT_STORE,			REQ_DEPT,				RQDAT,				ISDAT,
			 ORDER_NO,		PORDNO,				OUT_CHK,					NAOUGU,				IN_STORE,
			 PJTNO,			HOSTS,				OPSEQ,					CANCELQTY)
  VALUES (:gs_sabu,    :sholdno,         :stoday,             'O14',            :sitnbr,   
          :spspec,      :dwiqty,          0,   			         0,              	:dwiqty,   
          :sDepot_no,	:sInstore,       	:sdptno,   		      :sstrdate,     	null,   
          null,         :sPordno,         '1',                 '1',              null,   
          null,         'N',              :sOpseq,              0 );
		  
	If sqlca.sqlcode <> 0 or sqlca.sqlnrows < 1 then
		rollback;
		f_message_chk(32,'[사양개조 할당]') 	
		return
	End if
Next

Commit;

SetPointer(Arrow!)

cb_return.triggerevent(clicked!)

end event

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event p_choose::ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_pdt_02030_4
integer x = 46
integer y = 196
integer width = 3547
integer height = 844
integer taborder = 20
string dataobject = "d_pdt_02030_b"
boolean hscrollbar = true
end type

event dw_1::ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event dw_1::itemchanged;this.accepttext()

if this.getitemdecimal(row, "stock_valid_qty") < &
	this.getitemdecimal(row, "wiqty") then
	f_message_chk(105,'[의뢰수량]') 
	this.setitem(row, "wiqty", 0)
	return 1
End if
end event

event dw_1::constructor;Modify("itemas_ispec_t.text = '" + f_change_name('2') + "'" )

end event

type sle_2 from w_inherite_popup`sle_2 within w_pdt_02030_4
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_02030_4
boolean visible = false
integer x = 2103
integer y = 1280
integer width = 306
boolean enabled = false
string text = "조회(&Q)"
end type

type cb_return from w_inherite_popup`cb_return within w_pdt_02030_4
boolean visible = false
integer x = 2743
integer y = 1280
integer width = 306
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdt_02030_4
boolean visible = false
integer x = 1074
integer taborder = 70
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_02030_4
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_02030_4
boolean visible = false
end type

type rr_1 from roundrectangle within w_pdt_02030_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 24
integer width = 1719
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_update from datawindow within w_pdt_02030_4
boolean visible = false
integer x = 64
integer y = 1260
integer width = 1824
integer height = 288
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_pdt_02030_7"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_pdt_02030_4
boolean visible = false
integer x = 2423
integer y = 1280
integer width = 306
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "저장(&S)"
end type

type st_2 from statictext within w_pdt_02030_4
integer x = 178
integer y = 64
integer width = 151
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "품명"
boolean focusrectangle = false
end type

type sle_itdsc from singlelineedit within w_pdt_02030_4
integer x = 439
integer y = 52
integer width = 1134
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
end type

type rr_2 from roundrectangle within w_pdt_02030_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 184
integer width = 3575
integer height = 876
integer cornerheight = 40
integer cornerwidth = 55
end type


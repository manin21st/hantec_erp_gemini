$PBExportHeader$w_sal_01037_1.srw
$PBExportComments$차종/모델별 생산계획 자동생성
forward
global type w_sal_01037_1 from window
end type
type sle_msg from singlelineedit within w_sal_01037_1
end type
type p_1 from uo_picture within w_sal_01037_1
end type
type p_exit from uo_picture within w_sal_01037_1
end type
type p_mod from uo_picture within w_sal_01037_1
end type
type dw_ip from u_key_enter within w_sal_01037_1
end type
type dw_add from datawindow within w_sal_01037_1
end type
type gb_1 from groupbox within w_sal_01037_1
end type
type rr_1 from roundrectangle within w_sal_01037_1
end type
end forward

global type w_sal_01037_1 from window
integer x = 951
integer y = 336
integer width = 1865
integer height = 2132
boolean titlebar = true
string title = "차종/모델별 생산계획"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
sle_msg sle_msg
p_1 p_1
p_exit p_exit
p_mod p_mod
dw_ip dw_ip
dw_add dw_add
gb_1 gb_1
rr_1 rr_1
end type
global w_sal_01037_1 w_sal_01037_1

type variables
decimal is_danga
string is_cvcod, &
         is_year, &
         is_series
integer is_chasu
str_itnct lstr_sitnct
end variables

on w_sal_01037_1.create
this.sle_msg=create sle_msg
this.p_1=create p_1
this.p_exit=create p_exit
this.p_mod=create p_mod
this.dw_ip=create dw_ip
this.dw_add=create dw_add
this.gb_1=create gb_1
this.rr_1=create rr_1
this.Control[]={this.sle_msg,&
this.p_1,&
this.p_exit,&
this.p_mod,&
this.dw_ip,&
this.dw_add,&
this.gb_1,&
this.rr_1}
end on

on w_sal_01037_1.destroy
destroy(this.sle_msg)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.dw_ip)
destroy(this.dw_add)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

dw_add.settransobject(sqlca)
dw_ip.settransobject(sqlca)
dw_ip.settransobject(sqlca)

dw_ip.insertrow(0)
dw_ip.setitem(1, "syy", gs_code)
dw_ip.setitem(1, "schasu", gi_page)

// 부가세 사업장 설정
f_mod_saupj(dw_ip, 'saupj')

SetNull(gs_code)
SetNull(gi_page)
end event

type sle_msg from singlelineedit within w_sal_01037_1
integer x = 50
integer y = 1920
integer width = 1746
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type p_1 from uo_picture within w_sal_01037_1
integer x = 1307
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;String syear, ssaupj, sittyp, sitcls
long   lchasu

if dw_ip.accepttext() = -1 then return

syear 	= dw_ip.getitemstring(1, "syy")
lchasu 	= dw_ip.getitemnumber(1, "schasu")
ssaupj 	= dw_ip.getitemstring(1, "saupj")
sittyp 	= dw_ip.getitemstring(1, "ittyp")
sitcls 	= dw_ip.getitemstring(1, "itcls")

If IsNull( sSaupj ) Or Trim( sSaupj) = '' then
	Messagebox("사업장", "사업장을 등록하세요", stopsign!)
	return
End if

If IsNull( sittyp ) Or Trim( sittyp) = '' then
	Messagebox("품목구분", "품목구분을 등록하세요", stopsign!)
	return
End if

If IsNull( sitcls ) Or Trim( sitcls ) = '' then
	sitcls = '%'
End if

if dw_add.retrieve(sittyp, sitcls, ssaupj) < 1 then
	Messagebox("조회", "조회할 자료가 없읍니다", stopsign!)
	return
End if


end event

type p_exit from uo_picture within w_sal_01037_1
integer x = 1655
integer y = 12
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CloseWithReturn(parent,-1)	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_mod from uo_picture within w_sal_01037_1
integer x = 1481
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;
String syear, ssaupj, scar, smdl, scarname, smdlname
decimal {2} dqty
Long    Lrow
long   lrtn, lchasu

If dw_ip.accepttext()  = -1 then return
if dw_add.accepttext()  = -1 then return

syear   = dw_ip.getitemstring(1, "syy")
Lchasu  = dw_ip.getitemNumber(1, "schasu")
ssaupj  = dw_ip.getitemstring(1, "saupj")

For Lrow = 1 to dw_add.rowcount()
	
	 scar = dw_add.getitemstring(Lrow, "itemas_gritu")
	 smdl = dw_add.getitemstring(Lrow, "itemas_mdl_jijil")	 
	  
	 dQty = dw_add.getitemDecimal(Lrow, "qtypr")
	 
	 scarname = dw_add.getitemstring(Lrow, "modelname")
	 smdlname = dw_add.getitemstring(Lrow, "optioname")
	 
	 if isnull( smdl ) then 
		 smdl = '.'	 
		 smdlname = ' '
	 End if
	 
	 sle_msg.text = scarname + '  ' + smdlname + '  생성중'
	 
	 if dqty = 0 then continue
	
	 Lrtn = 0
	 Lrtn = sqlca.erp000000072(gs_sabu, syear, lchasu, ssaupj, scar, smdl, dqty)
	 Choose Case Lrtn
			  Case 1
					 commit;
			  Case -1
					Rollback;
	 				MessageBox("모델", "품목별 계획생성 실패", stopsign!)
			  Case Else
					Rollback;
	 				MessageBox("모델", "서버프로세스가 없음", stopsign!)
	 End Choose
	
Next

CloseWithReturn(parent,1)	
end event

type dw_ip from u_key_enter within w_sal_01037_1
event ue_key pbm_dwnkey
integer x = 41
integer y = 172
integer width = 1792
integer height = 368
integer taborder = 10
string dataobject = "d_sal_01037_00"
boolean border = false
end type

event ue_key;if key = keyf1! then
	triggerevent(rbuttondown!)
End if
	
end event

event rbuttondown;call super::rbuttondown;string snull, sname

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if this.GetColumnName() = 'itcls' then
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
//	this.SetItem(1,"titnm1", lstr_sitnct.s_titnm)

	this.SetColumn('itcls')
	this.SetFocus()
	RETURN 1

end if	

end event

type dw_add from datawindow within w_sal_01037_1
event ue_pressenter pbm_dwnprocessenter
integer x = 55
integer y = 560
integer width = 1755
integer height = 1308
integer taborder = 20
string dataobject = "d_sal_01037_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemchanged;String sNull, sCol_Name
Long lRow, lQty, lDan, lAmt

dw_add.AcceptText()

sCol_Name = This.GetColumnName()
lRow = this.GetRow()
SetNull(sNull)

Choose Case sCol_Name
	// 계획수량 조정시 표준단가에 의해 계획금액이 재생성됨
   Case "plan_qty"
		lQty = this.GetItemNumber(lRow, 'plan_qty')
		if isNull(is_danga) then
			is_danga = 0
		end if
		lAmt = lQty * is_Danga
		this.SetItem(lRow, 'plan_amt', lAmt)
end Choose
end event

type gb_1 from groupbox within w_sal_01037_1
integer x = 41
integer y = 1884
integer width = 1774
integer height = 132
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_sal_01037_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 552
integer width = 1778
integer height = 1328
integer cornerheight = 40
integer cornerwidth = 55
end type


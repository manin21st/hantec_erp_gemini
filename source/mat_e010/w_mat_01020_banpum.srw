$PBExportHeader$w_mat_01020_banpum.srw
$PBExportComments$출고등록(직접출고)-재고조회
forward
global type w_mat_01020_banpum from window
end type
type p_exit from uo_picture within w_mat_01020_banpum
end type
type p_choose from uo_picture within w_mat_01020_banpum
end type
type p_inq from uo_picture within w_mat_01020_banpum
end type
type dw_2 from datawindow within w_mat_01020_banpum
end type
type dw_1 from datawindow within w_mat_01020_banpum
end type
type rr_1 from roundrectangle within w_mat_01020_banpum
end type
end forward

global type w_mat_01020_banpum from window
integer width = 3639
integer height = 2084
boolean titlebar = true
string title = "재고수량 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_choose p_choose
p_inq p_inq
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_mat_01020_banpum w_mat_01020_banpum

type variables
str_itnct lstr_sitnct
datawindow dwname
string isdepot, iscvcod, isjasa, issaupj, isitnbr
end variables

on w_mat_01020_banpum.create
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_choose,&
this.p_inq,&
this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_mat_01020_banpum.destroy
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;String sIttyp

F_Window_Center_Response(This)

dwname = message.powerobjectparm
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

isdepot = gs_code		// 창고
iscvcod = gs_gubun	// 거래처
dw_2.insertrow(0)
dw_2.setitem(1, 'depot', isdepot)

// 자사코드는 창고기준으로 선택
SELECT ipjogun INTO :issaupj
  FROM VNDMST
 WHERE ( CVCOD = :isdepot ) ;
		 
SELECT DATANAME
  INTO :isjasa
  FROM SYSCNFG, VNDMST
 WHERE SYSGU = 'C' and SERIAL = '4' and RFCOD = :issaupj
	AND DATANAME = CVCOD;

// gs_codename이 품번인지 체크
select ittyp, itnbr into :sittyp, :isitnbr from itemas where itnbr = :gs_codename;
If IsNull(isItnbr) Or Trim(isItnbr) = '' Then
	isItnbr = ''
Else
	dw_2.SetItem(1, 'ittyp', sIttyp)
	dw_1.SetFilter("itnbr = '"+isitnbr +"'")
	dw_1.Filter()
	dw_1.Retrieve(isdepot, sittyp, '%', gs_saupj)
End If

dw_2.setfocus()
end event

type p_exit from uo_picture within w_mat_01020_banpum
integer x = 3424
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_choose from uo_picture within w_mat_01020_banpum
integer x = 3250
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long Lrow, Lgrow, Lfind
String sItnbr, scustNo
Dec    Lunprc

dw_1.accepttext()
dwname.setredraw(false)
For Lrow = 1 to dw_1.rowcount()
	
	 if dw_1.getitemstring(Lrow, "gbn") = 'N' then continue

	 // 구매반품인 경우
	 If dwname.dataobject = 'd_mat_01021' then
		 Lgrow =	dwname.insertrow(0)
		 
		 sItnbr = dw_1.getitemstring(Lrow, "itnbr")
		 dwname.setitem(Lgrow, "itnbr", 			dw_1.getitemstring(Lrow, "itnbr"))
		 dwname.setitem(Lgrow, "itemas_itdsc",	dw_1.getitemstring(Lrow, "itdsc"))
		 dwname.setitem(Lgrow, "itemas_ispec",	dw_1.getitemstring(Lrow, "ispec"))
		 dwname.setitem(Lgrow, "pspec", 			dw_1.getitemstring(Lrow, "pspec"))
		 dwname.setitem(Lgrow, "depot_no",		isdepot)
		 dwname.setitem(Lgrow, "lotsno", 		dw_1.getitemstring(Lrow, "lotno"))
		 dwname.setitem(Lgrow, "ioqty", 			dw_1.getitemdecimal(Lrow, "valid_qty"))
		 dwname.setitem(Lgrow, "jego_qty", 		dw_1.getitemdecimal(Lrow, "jego_qty"))
		 dwname.setitem(Lgrow, "itm_shtnm", 	dw_1.getitemstring(Lrow, "itm_shtnm"))
		 dwname.setitem(Lgrow, "lotgub", 		dw_1.getitemstring(Lrow, "lotgub"))
		 
		/* 업체별 단가 */
		Select Nvl(unprc, 0)	  Into :Lunprc	  From danmst
		 Where itnbr  = :sItnbr	And cvcod  = :iscvcod	and rownum = 1	 Using sqlca;	
		 dwname.setitem(Lgrow, "price", 			0)
	 // 출고등록(직출)
	 ElseIf dwname.dataobject = 'd_pdt_04035_1' Or dwname.dataobject = 'd_pdt_04035_han_1' Or &
				dwname.dataobject = 'd_pdt_04036_2' Or dwname.dataobject = 'd_adt_00250_1' Then
		 Lgrow =	dwname.insertrow(0)
		
		 dwname.setitem(Lgrow, "lotsno", 		dw_1.getitemstring(Lrow, "lotno"))
		 dwname.setitem(Lgrow, "itnbr", 			dw_1.getitemstring(Lrow, "itnbr"))
		 dwname.setitem(Lgrow, "itdsc", 			dw_1.getitemstring(Lrow, "itdsc"))
		 dwname.setitem(Lgrow, "ispec", 			dw_1.getitemstring(Lrow, "ispec"))
		 dwname.setitem(Lgrow, "jijil", 			dw_1.getitemstring(Lrow, "jijil"))
		 dwname.setitem(Lgrow, "itm_shtnm", 	dw_1.getitemstring(Lrow, "itm_shtnm"))
		 dwname.setitem(Lgrow, "ispec_code",	dw_1.getitemstring(Lrow, "ispec_code"))
		 dwname.setitem(Lgrow, "pspec", 			dw_1.getitemstring(Lrow, "pspec"))	 
		 dwname.setitem(Lgrow, "jego_qty", 		dw_1.getitemdecimal(Lrow, "jego_qty"))
		 dwname.setitem(Lgrow, "jego_temp", 	dw_1.getitemdecimal(Lrow, "jego_temp"))
		 dwname.setitem(Lgrow, "valid_qty", 	dw_1.getitemdecimal(Lrow, "valid_qty"))
		 dwname.setitem(Lgrow, "outqty", 		dw_1.getitemdecimal(Lrow, "valid_qty"))
		 dwname.setitem(Lgrow, "lotgub", 		dw_1.getitemstring(Lrow, "lotgub"))
		 dwname.setitem(Lgrow, "grpno2", 		dw_1.getitemstring(Lrow, "grpno2"))
		 
		 // 입고처를 찾지 못한경우 자사코드 입력
		 sCustNo = Trim(dw_1.getitemstring(Lrow, "cust_no"))
		 If IsNull(sCustNo) Or scustNo = '' Then sCustNo = isjasa
			
		 dwname.setitem(Lgrow, "cust_no",	sCustNo)		// 입고처(최초)
	End If
Next
dwname.setredraw(true)
Close(Parent)

end event

type p_inq from uo_picture within w_mat_01020_banpum
integer x = 3077
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sittyp, sitcls
IF dw_2.AcceptText() = -1 THEN RETURN 

sittyp = TRIM(dw_2.GetItemString(1,"ittyp"))
sitcls = TRIM(dw_2.GetItemString(1,"itcls"))

IF sitcls ="" OR IsNull(sitcls) THEN sitcls ='%'

IF dw_1.Retrieve(isdepot, sittyp, sitcls, gs_saupj) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_2.SetColumn("ittyp")
	dw_2.SetFocus()
	Return
END IF

dw_1.SetFocus()


end event

type dw_2 from datawindow within w_mat_01020_banpum
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 20
integer width = 2990
integer height = 136
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_04037_01"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;str_itnct str_sitnct

setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" Then
		this.accepttext()
		gs_code = this.getitemstring(1, 'ittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
	
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"itcls", str_sitnct.s_sumgub)
		this.SetItem(1,"itnm", str_sitnct.s_titnm)
      p_inq.TriggerEvent(Clicked!)
   End If
END IF

end event

event itemchanged;string	s_Itcls, s_Name, s_itt, snull
int      ireturn 

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_1.reset()
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_1.reset()
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
//      cb_inq.TriggerEvent(Clicked!)
   end if
ELSEIF this.GetColumnName() = "itcls"	THEN
	s_itcls = this.gettext()
   IF s_itcls = "" OR IsNull(s_itcls) THEN 
		this.SetItem(1,'itnm', snull)
      dw_1.reset()
   ELSE
		s_itt  = this.getitemstring(1, 'ittyp')
		ireturn = f_get_name2('품목분류', 'Y', s_itcls, s_name, s_itt)
		This.setitem(1, 'itcls', s_itcls)
		This.setitem(1, 'itnm', s_name)
   END IF
	return ireturn 
END IF
end event

event itemerror;return 1
end event

event rbuttondown;string sname

if this.GetColumnName() = 'itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itnm", lstr_sitnct.s_titnm)
   p_inq.TriggerEvent(Clicked!)
end if	
end event

type dw_1 from datawindow within w_mat_01020_banpum
integer x = 50
integer y = 164
integer width = 3529
integer height = 1796
integer taborder = 30
string dataobject = "d_pdt_04037_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_mat_01020_banpum
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 156
integer width = 3561
integer height = 1816
integer cornerheight = 40
integer cornerwidth = 55
end type


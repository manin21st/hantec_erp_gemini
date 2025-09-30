$PBExportHeader$w_sal_02000_2.srw
$PBExportComments$수주 등록(재고 상세 조회)
forward
global type w_sal_02000_2 from window
end type
type p_2 from uo_picture within w_sal_02000_2
end type
type p_1 from uo_picture within w_sal_02000_2
end type
type p_inq from uo_picture within w_sal_02000_2
end type
type dw_ip from u_key_enter within w_sal_02000_2
end type
type dw_rtv from datawindow within w_sal_02000_2
end type
type rr_2 from roundrectangle within w_sal_02000_2
end type
end forward

global type w_sal_02000_2 from window
integer x = 110
integer y = 200
integer width = 3433
integer height = 2096
boolean titlebar = true
string title = "재고 상세 조회"
windowtype windowtype = response!
long backcolor = 32106727
p_2 p_2
p_1 p_1
p_inq p_inq
dw_ip dw_ip
dw_rtv dw_rtv
rr_2 rr_2
end type
global w_sal_02000_2 w_sal_02000_2

on w_sal_02000_2.create
this.p_2=create p_2
this.p_1=create p_1
this.p_inq=create p_inq
this.dw_ip=create dw_ip
this.dw_rtv=create dw_rtv
this.rr_2=create rr_2
this.Control[]={this.p_2,&
this.p_1,&
this.p_inq,&
this.dw_ip,&
this.dw_rtv,&
this.rr_2}
end on

on w_sal_02000_2.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.p_inq)
destroy(this.dw_ip)
destroy(this.dw_rtv)
destroy(this.rr_2)
end on

event open;String  sMsgParm, sItnbr, sSpec, sDepotNo, sItDsc, sIspec, sJijil, sIspecCode
Integer iPos

sMsgParm = Message.StringParm

dw_ip.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

iPos = Pos(sMsgParm,'|')

sItnbr = Left(sMsgParm,iPos - 1)
sMsgParm = Mid(sMsgParm,iPos + 1)

iPos = Pos(sMsgParm,'|')
sSpec  = Left(sMsgparm,iPos - 1)

sDepotNo = Mid(sMsgparm,iPos + 1)

If sItnbr <> '' Then
	SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", 
			 "ITEMAS"."JIJIL", "ITEMAS"."ISPEC_CODE"
	  INTO :sItDsc,   		 :sIspec, 		    
			 :sJijil, 			  :sIspecCode
	  FROM "ITEMAS"
	 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;
		 
	dw_ip.SetItem(1, 'itnbr', sItnbr)
	dw_ip.SetItem(1, 'itdsc', sItdsc)
	dw_ip.SetItem(1, 'ispec', sIspec)
	dw_ip.SetItem(1, 'jijil', sjijil)
	dw_ip.SetItem(1, 'ispec_code', sIspecCode)
	dw_ip.SetItem(1, 'pspec', sSpec)
End If

f_window_center_response(this)

p_inq.TriggerEvent(Clicked!)
end event

type p_2 from uo_picture within w_sal_02000_2
integer x = 3218
integer y = 28
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;closeWithReturn(w_sal_02000_2,'cancle')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_1 from uo_picture within w_sal_02000_2
integer x = 3035
integer y = 28
integer width = 178
string picturename = "C:\erpman\image\선택_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;String  sItnbr , ls_gubun
Integer iSelectedRow

iSelectedRow = dw_rtv.GetSelectedRow(0)
IF iSelectedRow <=0 THEN
	f_message_chk(36,'')
	Return
ELSE
	ls_gubun = dw_ip.getitemstring(1,'gubun')
	
	if ls_gubun = '1' then
		sItnbr = dw_rtv.GetItemString(iSelectedRow,"itnbr")
	elseif ls_gubun = '2' then
		sItnbr = left(dw_rtv.GetItemString(iSelectedRow,"itnbr"),11)
	end if
END IF

closeWithReturn(w_sal_02000_2,sItnbr)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_sal_02000_2
integer x = 2853
integer y = 28
integer width = 178
string picturename = "C:\erpman\image\조회_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;String sDepotNo, sItnbr

If dw_ip.AcceptText() <> 1 Then Return 

sDepotNo = Trim(dw_ip.GetItemString(1, 'depot_no'))
sItnbr   = Trim(dw_ip.GetItemString(1, 'itnbr'))

If IsNull(sDepotNo) Then sDepotNo = '%'
If IsNull(sItnbr) Then sItnbr = '%'

dw_rtv.Retrieve(sDepotNo, sItnbr)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type dw_ip from u_key_enter within w_sal_02000_2
event ue_key pbm_dwnkey
integer x = 18
integer y = 180
integer width = 3397
integer height = 240
integer taborder = 10
string dataobject = "d_sal_02000_21"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		RETURN 1
	End If
END IF
end event

event itemchanged;call super::itemchanged;String sNull, sCvcod, sget_name, sItnbr, sItdsc, sIspec, sJijil, sIspecCode ,ls_gubun
long   lcount, ireturn

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case 'gubun'
		ls_gubun = Trim(this.gettext())
		
		dw_rtv.setredraw(false)
		if ls_gubun = '1' then
			dw_rtv.dataobject = 'd_sal_02000_2'
		elseif ls_gubun ='2'then
			dw_rtv.dataobject = 'd_sal_02000_22'
		end if
		dw_rtv.settransobject(sqlca)
		dw_rtv.setredraw(true)
	Case "vndcod"
		scvcod = trim(this.GetText())
		
		IF scvcod ="" OR IsNull(scvcod) THEN 
			this.SetItem(1,"vndnm",snull)
			RETURN
		END IF
		
		SELECT "VNDMST"."CVNAS2"  INTO :sget_name  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :scvcod   ;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"vndnm",sget_name)
		ELSE
			this.TriggerEvent(RbuttonDown!)
			
			IF gs_code ="" OR IsNull(gs_code) THEN 
				this.Setitem(1,"vndcod",snull)
				this.SetItem(1,"vndnm",snull)
			END IF
			Return 1
		END IF
	Case "fr_date"
		IF f_datechk(trim(this.gettext())) = -1	then
			this.setitem(1, "fr_date", sNull)
			return 1
		END IF
	Case "to_date"
		IF f_datechk(trim(this.gettext())) = -1	then
			this.setitem(1, "to_date", sNull)
			return 1
		END IF
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* 재질 */
	Case "jijil"
		sJijil = trim(GetText())
	
		ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* 규격코드 */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
END Choose
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = "vndcod" THEN
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN gs_code =""
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	this.SetItem(1, "vndcod", gs_Code)
	this.SetItem(1, "vndnm", gs_Codename)
//	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	triggerevent(itemchanged!)
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	triggerevent(itemchanged!) 
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	triggerevent(itemchanged!)
END IF
end event

type dw_rtv from datawindow within w_sal_02000_2
event ue_key pbm_dwnkey
integer x = 37
integer y = 440
integer width = 3328
integer height = 1516
integer taborder = 20
string dataobject = "d_sal_02000_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_key;choose case key
	case keypageup!
		dw_rtv.scrollpriorpage()
	case keypagedown!
		dw_rtv.scrollnextpage()
	case keyhome!
		dw_rtv.scrolltorow(1)
	case keyend!
		dw_rtv.scrolltorow(dw_rtv.rowcount())
end choose
end event

event rowfocuschanged;
dw_rtv.SelectRow(0,False)
dw_rtv.SelectRow(currentrow,True)

dw_rtv.ScrollToRow(currentrow)
end event

event clicked;IF Row <=0 THEN RETURN

dw_rtv.SelectRow(0,False)
dw_rtv.SelectRow(row,True)


end event

event doubleclicked;p_1.PostEvent(Clicked!)
end event

type rr_2 from roundrectangle within w_sal_02000_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 432
integer width = 3369
integer height = 1540
integer cornerheight = 40
integer cornerwidth = 55
end type


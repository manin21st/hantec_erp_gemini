$PBExportHeader$w_sal_02310.srw
$PBExportComments$기획출고 분류 등록
forward
global type w_sal_02310 from w_inherite
end type
type dw_ip from u_key_enter within w_sal_02310
end type
end forward

global type w_sal_02310 from w_inherite
integer width = 3657
integer height = 2404
string title = "기획출고 분류 등록"
dw_ip dw_ip
end type
global w_sal_02310 w_sal_02310

on w_sal_02310.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
end on

on w_sal_02310.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
end on

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_ip.InsertRow(0)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02310
integer y = 192
integer height = 1736
string dataobject = "d_sal_02310"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type cb_exit from w_inherite`cb_exit within w_sal_02310
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_sal_02310
integer x = 2496
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;If dw_insert.AcceptText() <> 1 Then Return 

if dw_insert.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		

end event

type cb_ins from w_inherite`cb_ins within w_sal_02310
boolean visible = false
integer y = 2324
integer taborder = 0
end type

type cb_del from w_inherite`cb_del within w_sal_02310
boolean visible = false
integer y = 2324
integer taborder = 0
end type

type cb_inq from w_inherite`cb_inq within w_sal_02310
integer x = 151
integer y = 1956
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;String sItcls, sIttyp

If dw_ip.AcceptText() <> 1 Then Return

sIttyp = dw_ip.GetItemString(1,'ittyp')
sItcls = dw_ip.GetItemString(1,'itcls')

if isnull(sItcls) or sItcls = "" then
	f_message_chk(30,'[중분류코드]')
	dw_ip.Setcolumn('itcls')
	dw_ip.SetFocus()
	return
end if	

dw_insert.Retrieve(sIttyp, sItcls)

ib_any_typing = FALSE


end event

type cb_print from w_inherite`cb_print within w_sal_02310
boolean visible = false
integer y = 2324
integer taborder = 0
end type

type st_1 from w_inherite`st_1 within w_sal_02310
end type

type cb_can from w_inherite`cb_can within w_sal_02310
integer x = 2857
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;dw_insert.Reset()
end event

type cb_search from w_inherite`cb_search within w_sal_02310
boolean visible = false
integer y = 2324
integer taborder = 0
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02310
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02310
end type

type dw_ip from u_key_enter within w_sal_02310
integer x = 137
integer y = 60
integer width = 2153
integer height = 116
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_02310_1"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String sNull, sItcls, get_nm, sIttyp

SetNull(sNull)

Choose Case GetColumnName()
	Case 'ittyp'
		SetItem(1, 'itcls', snull)
		SetItem(1, 'titnm', snull)
	Case 'itcls'
		sItcls = GetText()
		
		IF sItcls = "" or isnull(sItcls) then
			this.SetItem(1,"titnm",snull)
			return  
		END IF
		
		sIttyp = this.getitemstring(1, 'ittyp')
		
		if sIttyp = "" or isnull(sIttyp) then 
			SetItem(1,"itcls",snull)
			messagebox("확인", "품목구분을 먼저 입력하세요!!") 
			this.setcolumn("ittyp")
			this.setfocus()
			return 1
		end if
	
		SELECT "ITNCT"."TITNM"  
		  INTO :get_nm
		  FROM "ITNCT"  
		 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
				 ( "ITNCT"."ITCLS" = :sItcls )   ;
	
		IF SQLCA.SQLCODE <> 0 then 
			this.triggerevent(rbuttondown!)
			IF gs_code ="" OR IsNull(gs_code) THEN
				setitem(1, "itcls", snull)
				setitem(1, "titnm", snull)
			END IF
			RETURN 1
		ELSE
			setitem(1, "titnm", get_nm)
			cb_inq.TriggerEvent(Clicked!)
		END IF
End Choose
end event

event rbuttondown;call super::rbuttondown;string snull

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)
setnull(snull)

IF GetColumnName() = "itcls" THEN

	gs_gubun = getitemstring(1, 'ittyp')
	
	open(w_itnct_m_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  RETURN

	string s_large, get_nm
	
	s_large = left(gs_code, 2)
	
   SELECT "ITNCT"."TITNM"  
     INTO :get_nm  
     FROM "ITNCT"  
    WHERE ( "ITNCT"."ITTYP" = :gs_gubun ) AND  
          ( "ITNCT"."ITCLS" = :s_large )   ; 
		
   if sqlca.sqlcode <> 0 then 
		f_message_chk(52, "")
		SetItem(1, "ittyp", snull)
		SetItem(1, "itcls", snull)
		SetItem(1, "titnm", snull)
	   return 1 
	end if	
	
	SetItem(1, "ittyp", gs_gubun)
	SetItem(1, "itcls", gs_code)
	SetItem(1, "titnm", gs_Codename)
   cb_inq.TriggerEvent(Clicked!)
   return 1 
END If
end event


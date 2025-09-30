$PBExportHeader$w_sal_06160.srw
$PBExportComments$품목별 내수및 수출 단가 비교
forward
global type w_sal_06160 from w_standard_print
end type
type p_inq from uo_picture within w_sal_06160
end type
type rr_1 from roundrectangle within w_sal_06160
end type
end forward

global type w_sal_06160 from w_standard_print
string title = "품목별 내수및 수출 단가 비교"
p_inq p_inq
rr_1 rr_1
end type
global w_sal_06160 w_sal_06160

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_gubun , ls_kdate , ls_ittyp ,ls_itcls , ls_itnbr , ls_itdsc , ls_ispec ,ls_jijil
long   ll_count1 ,ll_count2 
decimal{4} ll_biul 
decimal{2} ll_rate1 , ll_rate2

if dw_ip.accepttext() <> 1 then return -1

ls_gubun = dw_ip.getitemstring(1,'gubun')
ls_kdate = Trim(dw_ip.getitemstring(1,'kdate'))
ls_ittyp = Trim(dw_ip.getitemstring(1,'ittyp'))
ls_itcls = Trim(dw_ip.getitemstring(1,'itcls'))
ls_itnbr = Trim(dw_ip.getitemstring(1,'itnbr'))
ls_itdsc = Trim(dw_ip.getitemstring(1,'itdsc'))
ls_ispec = Trim(dw_ip.getitemstring(1,'ispec'))
ls_jijil = Trim(dw_ip.getitemstring(1,'jijil'))
ll_biul  = dw_ip.getitemnumber(1,'biul')

////////환율 적용값 구하기...
if ls_gubun = '1' then
   SELECT RSTAN ,COUNT(*) 
	INTO   :ll_rate1 , :ll_count1
	FROM   RATEMT
	WHERE  RCURR = 'USD' AND
			 RDATE = :ls_kdate
	GROUP BY RSTAN ;
	
	SELECT RSTAN ,COUNT(*)
	INTO   :ll_rate2 , :ll_count2
	FROM   RATEMT
	WHERE  RCURR = 'DEM' AND
			 RDATE = :ls_kdate
	GROUP BY RSTAN ;
	
else
   SELECT EXCHRATE , COUNT(*)
	INTO   :ll_rate1 , :ll_count1
	FROM   EXCHRATE_FORECAST 
	WHERE  RATUNIT = 'USD'   AND
			 BASE_YYMM = SUBSTR(:ls_kdate,1,6)
	GROUP BY EXCHRATE  ;
	
	SELECT EXCHRATE , COUNT(*)
	INTO   :ll_rate2 , :ll_count2
	FROM   EXCHRATE_FORECAST 
	WHERE  RATUNIT = 'DEM'   AND
			 BASE_YYMM = SUBSTR(:ls_kdate,1,6)
	GROUP BY EXCHRATE  ;
	
		
end if

if ll_count1 < 1 then ll_rate1 = 1
if ll_count2 < 1 then ll_rate2 = 1

//////////////////////////////////////////////////////////

if ls_kdate = "" or isnull(ls_kdate) then
	f_message_chk(30,'[기준일자]')
	dw_ip.setcolumn('kdate')
	dw_ip.setfocus()
	return -1
end if

if ls_ittyp = "" or isnull(ls_ittyp) then
	f_message_chk(30,'[품목구분]')
	dw_ip.setcolumn('ittyp')
	dw_ip.setfocus()
	return -1
end if

if ls_itcls = "" or isnull(ls_itcls) then ls_itcls = '%'
if ls_itnbr = "" or isnull(ls_itnbr) then ls_itnbr = '%'
if ls_itdsc = "" or isnull(ls_itdsc) then ls_itdsc = '%'
if ls_ispec = "" or isnull(ls_ispec) then ls_ispec = '%'
if ls_jijil = "" or isnull(ls_jijil) then ls_jijil = '%'
if isnull(ll_biul) then ll_biul = 1 

if dw_print.retrieve(ll_rate1 ,ll_biul,ls_ittyp,ls_itcls, ls_itnbr,ls_itdsc,ls_ispec,ls_jijil,ll_rate2,ls_gubun) < 1 then
	f_message_chk(300,'')
	dw_ip.setcolumn('kdate')
	dw_ip.setfocus()
	Return -1
else
	dw_print.sharedata(dw_list)
end if

dw_print.object.tx_kdate.text = left(ls_kdate,4) + '.' + mid(ls_kdate,5,2) + '.' + mid(ls_kdate,7,2)
	
return 1
end function

on w_sal_06160.create
int iCurrent
call super::create
this.p_inq=create p_inq
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_inq
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_06160.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_inq)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'kdate',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_sal_06160
end type

type p_exit from w_standard_print`p_exit within w_sal_06160
end type

type p_print from w_standard_print`p_print within w_sal_06160
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06160
boolean visible = false
integer x = 4247
integer y = 2888
string picturename = "c:\erpman\image\retrieve_1.bmp"
end type







type st_10 from w_standard_print`st_10 within w_sal_06160
end type



type dw_print from w_standard_print`dw_print within w_sal_06160
string dataobject = "d_sal_06160_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06160
integer x = 46
integer y = 24
integer width = 3698
integer height = 388
string dataobject = "d_sal_06160_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sNull, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sDateFrom ,ls_jijil, sjijil, sispeccode
String  sItemCls, sItemGbn, sItemClsName
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	Case "kdate"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[수주기간]')
			this.SetItem(1,GetColumnName(),snull)
			Return 1
		END IF
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'titnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		SetItem(nRow,'jijil',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'titnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		SetItem(nRow,'jijil',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"titnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "titnm"
		SetItem(1,"itcls",snull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
		SetItem(nRow,'ispec',sNull)
		SetItem(nRow,'jijil',sNull)
		
		sItemClsName = this.GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			 FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
		  IF SQLCA.SQLCODE <> 0 THEN
			 this.TriggerEvent(RButtonDown!)
			 Return 2
		  ELSE
			 this.SetItem(1,"itcls",sItemCls)
		  END IF
		END IF
	/* 품번 */
	  Case	"itnbr" 
		 sItnbr = Trim(this.GetText())
		 IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetItem(nRow,'jijil',sNull)
			Return
		 END IF
		
		 SELECT  "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC","ITNCT"."TITNM" ,"ITEMAS"."JIJIL"
			INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName ,:ls_jijil
			FROM "ITEMAS","ITNCT"
		  WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				  "ITEMAS"."ITNBR" = :sItnbr ;
	
		 IF SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		 END IF
		
		 SetItem(nRow,"ittyp", sIttyp)
		 SetItem(nRow,"itdsc", sItdsc)
		 SetItem(nRow,"ispec", sIspec)
		 SetItem(nRow,"itcls", sItcls)
		 SetItem(nRow,"titnm", sItemClsName)
		 SetItem(nRow,'jijil', ls_jijil)
		 
	/* 품명 */
	 Case "itdsc"
		 sItdsc = trim(this.GetText())	
		 IF sItdsc ="" OR IsNull(sItdsc) THEN
			 SetItem(nRow,'itnbr',sNull)
			 SetItem(nRow,'itdsc',sNull)
			 SetItem(nRow,'ispec',sNull)
			 SetItem(nRow,'jijil',sNull)
			Return
		 END IF
		 
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		 If IsNull(sItnbr ) Then
			 Return 1
		 ElseIf sItnbr <> '' Then
			 SetItem(nRow,"itnbr",sItnbr)
			 SetColumn("itnbr")
			 SetFocus()
			 TriggerEvent(ItemChanged!)
			 Return 1
		 ELSE
			 SetItem(nRow,'itnbr',sNull)
			 SetItem(nRow,'itdsc',sNull)
			 SetItem(nRow,'ispec',sNull)
			 SetItem(nRow,'jijil',sNull)
			 SetColumn("itdsc")
			 Return 1
		End If	
	/* 규격 */
	Case "ispec"
		sIspec = trim(this.GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetItem(nRow,'jijil',sNull)
			Return
		END IF
	
	   /* 규격으로 품번찾기 */
	   f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			SetItem(nRow,'jijil',sNull)
			SetColumn("ispec")
			Return 1
	  End If
END Choose

end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

str_itnct  str_sitnct

Choose Case GetcolumnName() 
  Case "itcls"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    str_sitnct = Message.PowerObjectParm	
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"titnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
  Case "titnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"titnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
/* ---------------------------------------- */
  Case "itnbr" ,"itdsc", "ispec" ,"jijil"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	  this.SetItem(1,"itnbr",gs_code)
	  this.SetFocus()
	  this.SetColumn('itnbr')
	  this.PostEvent(ItemChanged!)
END Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_06160
integer x = 55
integer y = 428
integer width = 4539
integer height = 1896
string dataobject = "d_sal_06160"
boolean border = false
end type

type p_inq from uo_picture within w_sal_06160
integer x = 3922
integer y = 20
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="1"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
SetPointer(Arrow!)

/*참고 */ 
/* 
	wf_retrieve() 코딩시 주의 할 사항 
	데이타 윈도우가 두개( dw_list, dw_print ) 있는 중에서 먼저 dw_print를 retrieve 시키고
	그기에 dw_list를 sharedata 한다.
	(예 :	IF dw_print.Retrieve() <= 0 THEN
				f_message_chk(50, '')
				dw_list.Reset()
				Return -1
			END IF
			
			dw_print.ShareData(dw_list)
			dw_list.ShareDataOff()
			Return 1	
	)
	예제와 같이 기술한다.
*/
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type rr_1 from roundrectangle within w_sal_06160
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 424
integer width = 4567
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type


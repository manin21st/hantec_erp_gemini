$PBExportHeader$w_imt_04640_jig.srw
$PBExportComments$치공구 마스타  현황
forward
global type w_imt_04640_jig from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_04640_jig
end type
end forward

global type w_imt_04640_jig from w_standard_print
string title = "치공구 마스타  현황"
boolean maxbox = true
rr_1 rr_1
end type
global w_imt_04640_jig w_imt_04640_jig

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_frkum_name, s_tokum_name,S_gubun, sMin, sMax, sKumgrp, sKumsub, tx_name, sCvcod, sgbn

If dw_ip.AcceptText() <> 1 Then Return -1

s_frkum_name = trim(dw_ip.object.fr_kumno[1])
//s_tokum_name = trim(dw_ip.object.to_kumno[1])
S_gubun      = trim(dw_ip.object.gubun[1])
//sKumgubn     = trim(dw_ip.object.kumgubn[1])
scvcod       = trim(dw_ip.object.cvcod[1]) 
//sgbn         = trim(dw_ip.object.prtgbn[1])
//sKumgrp     = Trim(dw_ip.GetItemString(1, 'grp'))
//sKumsub      = Trim(dw_ip.GetItemString(1, 'sub'))
//If sKumgrp = '' OR IsNull(sKumgrp) Then sKumgrp = '%'
//If sKumsub = '' OR IsNull(sKumsub) Then sKumsub = '%'


//SELECT MIN(KUMNO), MAX(KUMNO) INTO :sMin, :sMax
//  FROM KUMMST;
// 
//If IsNull(sMin) Then sMin = '.'
//If IsNull(sMax) Then sMax = 'z'

if (IsNull(s_frkum_name) or s_frkum_name = "")  then 
	s_frkum_name = '%'
//	s_tokum_name = 'zzzzzzzzzzz'
//else
//	s_tokum_name = s_frkum_name
end if

//If IsNull(sKumgubn) Or sKumgubn = '' Then sKumGubn = '%'
if (IsNull(S_gubun) or S_gubun = "")  then S_gubun = "%"
if (IsNull(scvcod) or scvcod = "")  then scvcod = "%"

//if s_frkum_name > s_tokum_name then 
//	f_message_chk(34, '[관리번호]')
//   dw_ip.setcolumn('fr_kumno')
//	dw_ip.setfocus()
//   return -1
//end if

//if dw_print.Retrieve(gs_sabu, s_frkum_name, s_tokum_name,S_gubun, sKumgrp, sKumsub, scvcod) <= 0 then
if dw_print.Retrieve(gs_sabu, s_frkum_name, S_gubun, scvcod) <= 0 then
	f_message_chk(50,'[치공구 마스타 현황]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1
end function

on w_imt_04640_jig.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_04640_jig.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;//

Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

DataWindowChild ldw_grp
dw_ip.GetChild('grp', ldw_grp)
ldw_grp.SetTransObject(SQLCA)
ldw_grp.Retrieve('%')

DataWindowChild ldw_sub
dw_ip.GetChild('sub', ldw_sub)
ldw_sub.SetTransObject(SQLCA)
ldw_sub.Retrieve('%')

dw_ip.SetTransObject(SQLCA)
//dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_xls from w_standard_print`p_xls within w_imt_04640_jig
boolean visible = true
integer x = 4270
integer y = 28
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//
If this.Enabled Then wf_excel_down(dw_list)
end event

type p_sort from w_standard_print`p_sort within w_imt_04640_jig
boolean visible = true
integer x = 3662
integer y = 32
end type

type p_preview from w_standard_print`p_preview within w_imt_04640_jig
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_imt_04640_jig
integer y = 28
end type

type p_print from w_standard_print`p_print within w_imt_04640_jig
boolean visible = false
integer x = 4430
integer y = 184
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04640_jig
integer y = 28
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
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
//	p_print.Enabled =False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'	
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'	
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
//	p_print.Enabled =True
//	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	
end event











type dw_print from w_standard_print`dw_print within w_imt_04640_jig
integer x = 4288
integer y = 196
string dataobject = "d_imt_04640_jig_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04640_jig
integer x = 23
integer y = 24
integer width = 2674
integer height = 160
string dataobject = "d_imt_04640_jig_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::ue_key;string snull
str_itnct str_sitnct

setnull(gs_code)
SetNull(Gs_Gubun)
SetNull(Gs_codename)

setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "sitcls" OR This.GetColumnName() = "sittyp" Then
   	this.accepttext()
		gs_code = this.getitemstring(1, 'sittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
		
		this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"sitcls", str_sitnct.s_sumgub)
		this.TriggerEvent(ItemChanged!)
	END IF
END IF

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 치공구번호 */
	Case "fr_kumno"
		gs_gubun = 'J'
		OPEN(w_imt_04630_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		SetItem(1,'fr_kumno', gs_code)
		SetItem(1,'kumname',gs_codename)
//	Case "to_kumno"
//		OPEN(w_imt_04630_popup)
//		If IsNull(gs_code) Or gs_code = '' Then Return
//		SetItem(1,'to_kumno', gs_code)
	Case "cvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		SetItem(1, "cvcod", gs_code)
	   SetItem(1, "cvnas", gs_codename)
End Choose

end event

event dw_ip::itemchanged;string  svndcod, svndnm, svndnm2, sgbn, s_cod, s_nam1
int     ireturn


IF this.GetColumnName() = 'fr_kumno' then 
	if IsNull(s_cod) or s_cod = "" then 
		this.SetItem(1,'kumname','')
		return 
	end if
	
	select mchnam into :s_nam1 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
		f_message_chk(33, ' 관리 번호 ')
		this.SetItem(1,'fr_kumno','')
		this.SetItem(1,'kumname','')
		Return 1
	end if
	
	this.SetItem(1,'fr_kumno',s_cod)
	this.SetItem(1,'kumname',s_nam1)	

elseif this.GetColumnName() = "cvcod"	THEN
	svndcod = trim(this.GetText())
	ireturn = f_get_name2('V0', 'Y', svndcod, svndnm, svndnm2)   
	this.setitem(1, "cvcod", svndcod)	
	this.setitem(1, "cvnas", svndnm)	
	RETURN ireturn
elseif this.GetColumnName() = 'prtgbn' then 
	
	sgbn = Trim(this.getText())
	
	if sgbn = '1' then 
		dw_list.dataobject = 'd_imt_04640_4'
		dw_print.dataobject = 'd_imt_04640_p4'
	else
		dw_list.dataobject = 'd_imt_04640_3'
		dw_print.dataobject = 'd_imt_04640_p3'
	end if
	dw_list.SetTransObject(Sqlca)
	dw_print.SetTransObject(Sqlca)
	dw_list.Sharedata(dw_print)

ElseIf This.GetColumnName() = 'grp' Then
	DataWindowChild ldw_sub
	This.GetChild('sub', ldw_sub)
	ldw_sub.SetTransObject(SQLCA)

	If Trim(data) = '' OR IsNull(data) Then
		ldw_sub.Retrieve('%')
	Else
		ldw_sub.Retrieve(data)
	End If
END IF
end event

type dw_list from w_standard_print`dw_list within w_imt_04640_jig
integer x = 41
integer y = 208
integer width = 4558
integer height = 2028
string dataobject = "d_imt_04640_jig_4"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_04640_jig
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 196
integer width = 4590
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type


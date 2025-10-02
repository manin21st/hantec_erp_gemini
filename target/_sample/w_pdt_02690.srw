$PBExportHeader$w_pdt_02690.srw
$PBExportComments$** 공정납기준수율
forward
global type w_pdt_02690 from w_standard_print
end type
type st_1 from statictext within w_pdt_02690
end type
type ddlb_1 from dropdownlistbox within w_pdt_02690
end type
end forward

global type w_pdt_02690 from w_standard_print
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean border = false
st_1 st_1
ddlb_1 ddlb_1
end type
global w_pdt_02690 w_pdt_02690

forward prototypes
public function integer wf_retrieve_02690 ()
public function integer wf_retrieve_02700 ()
public function integer wf_retrieve ()
public function integer wf_retrieve_02705 ()
end prototypes

public function integer wf_retrieve_02690 ();string sdate, edate, itnbr1, itnbr2

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11111111"
if (IsNull(edate) or edate = "")  then edate = "99999999"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"

dw_print.object.txt_ymd.text = String(trim(dw_ip.object.sdate[1]), "@@@@.@@.@@") + " - " + &
                              String(trim(dw_ip.object.edate[1]),"@@@@.@@.@@") 
if dw_print.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2) <= 0 then
	f_message_chk(50,"[공정납기준수율[품목별]]")
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1
end function

public function integer wf_retrieve_02700 ();string sdate, edate, wk1, wk2

dw_ip.accepttext()

sdate 	= trim(dw_ip.object.sdate[1])
edate 	= trim(dw_ip.object.edate[1])
wk1 	= trim(dw_ip.object.wkctr1[1])
wk2 	= trim(dw_ip.object.wkctr2[1])

if 	(IsNull(sdate) or sdate = "")  then sdate = "11111111"
if 	(IsNull(edate) or edate = "")  then edate = "99999999"
if 	(IsNull(wk1) or wk1 = "")  then wk1 = "."
if 	(IsNull(wk2) or wk2 = "")  then wk2 = "ZZZZZZ"

dw_print.object.txt_ymd.text = String(trim(dw_ip.object.sdate[1]), "@@@@.@@.@@") + " - " + &
                              String(trim(dw_ip.object.edate[1]),"@@@@.@@.@@") 
if 	dw_print.Retrieve(gs_sabu, sdate, edate, wk1, wk2) <= 0 then
	f_message_chk(50,"[공정납기준수율[작업장별]]")
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)
return 1
end function

public function integer wf_retrieve ();if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if

Choose	Case	ddlb_1.text
	Case 	'품목별' 
		return wf_retrieve_02690()
	Case 	'작업장별' 
   		return wf_retrieve_02700()
	Case 	'공정별' 
   		return wf_retrieve_02705()
	Case Else
		MessageBox("출력구분 확인","출력구분을 먼저 선택하세요!")
		ddlb_1.SetFocus()
End Choose

return -1
end function

public function integer wf_retrieve_02705 ();string sdate, edate, wk1, wk2

dw_ip.accepttext()

sdate 	= trim(dw_ip.object.sdate[1])
edate 	= trim(dw_ip.object.edate[1])
wk1 	= trim(dw_ip.object.wkctr1[1])
wk2 	= trim(dw_ip.object.wkctr2[1])

if 	(IsNull(sdate) or sdate = "")  then sdate = "11111111"
if 	(IsNull(edate) or edate = "")  then edate = "99999999"
if 	(IsNull(wk1) or wk1 = "")  then wk1 = "."
if 	(IsNull(wk2) or wk2 = "")  then wk2 = "ZZZZZZ"

dw_print.object.txt_ymd.text = String(trim(dw_ip.object.sdate[1]), "@@@@.@@.@@") + " - " + &
                              String(trim(dw_ip.object.edate[1]),"@@@@.@@.@@") 
if 	dw_print.Retrieve(gs_sabu, sdate, edate, wk1, wk2) <= 0 then
	f_message_chk(50,"[공정납기준수율[공정별]]")
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_02690.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_1=create ddlb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_1
end on

on w_pdt_02690.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_1)
end on

event open;integer  li_idx

is_today = f_today()
is_totime = f_totime() 

w_mdi_frame.sle_msg.Text = ""

is_window_id = this.ClassName() 

w_mdi_frame.st_window.Text = Upper(is_window_id)

idw_name = dw_list

SELECT nvl(A.OPEN_HISTORY, 'N') as OPEN_HISTORY, 
			A.IO_GUBUN 
  INTO :is_usegub,
  			:is_io_gubun 
  FROM SUB2_T A  
 WHERE A.WINDOW_NAME = :is_window_id;
 
if sqlca.sqlcode <> 0 then
	is_usegub = "N"
	is_io_gubun = ""
end if

IF is_usegub = "Y" THEN
	INSERT INTO PGM_HISTORY  
					(L_USERID,
					CDATE,       STIME,      WINDOW_NAME,
					EDATE,       ETIME,
					IPADD,       USER_NAME)  
		VALUES (:gs_userid,
					:is_today,     :is_totime,   :is_window_id,
					null,           null,
					:gs_ipaddress, :gs_comname);

   if sqlca.sqlcode = 0 then 
	   commit;
   else 	  
	   rollback;
   end if	  
end if	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent("ue_open")
end event

type dw_list from w_standard_print`dw_list within w_pdt_02690
integer height = 1964
string dataobject = "d_pdt_02690_02"
end type

type cb_print from w_standard_print`cb_print within w_pdt_02690
end type

type cb_excel from w_standard_print`cb_excel within w_pdt_02690
end type

type cb_preview from w_standard_print`cb_preview within w_pdt_02690
end type

type cb_1 from w_standard_print`cb_1 within w_pdt_02690
end type

type dw_print from w_standard_print`dw_print within w_pdt_02690
integer x = 3698
integer width = 178
integer height = 84
string dataobject = "d_pdt_02690_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02690
integer y = 56
integer height = 188
string dataobject = "d_pdt_02690_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2, sNull
integer i_rtn

s_cod = Trim(this.GetText())
SetNull(sNull)

Choose 	Case	this.GetColumnName()
	Case 	"sdate" 
		if IsNull(s_cod) or s_cod = "" then return 
		if f_datechk(s_cod) = -1 then
			f_message_chk(35, "[시작일자]")
			this.object.sdate[1] = ""
			return 1
		end if
	Case 	"edate" 
		if IsNull(s_cod) or s_cod = "" then return 
		if f_datechk(s_cod) = -1 then
			f_message_chk(35, "[끝일자]")
			this.object.edate[1] = ""
			return 1
		end if
	Case 	"itnbr1" 
		i_rtn = f_get_name2("품번","N", s_cod, s_nam1, s_nam2)
		this.object.itnbr1[1] = s_cod
		this.object.itdsc1[1] = s_nam1
		return i_rtn
	Case 	"itnbr2" 
		i_rtn = f_get_name2("품번","N", s_cod, s_nam1, s_nam2)
		this.object.itnbr2[1] = s_cod
		this.object.itdsc2[1] = s_nam1
		return i_rtn
	Case 	"wkctr1"
		if	ddlb_1.text = '작업장별'	then
			i_rtn = f_get_name2("작업장", "N", s_cod, s_nam1, s_nam2)
			this.object.wkctr1[1] = s_cod
			this.object.wcdsc1[1] = s_nam1
			return i_rtn
		Else                                              // - 공정별
			SELECT "REFFPF"."RFNA1"  
			  INTO :s_nam1  
			  FROM "REFFPF"  
			 WHERE ( "REFFPF"."SABU" = '1' ) AND  
					 ( "REFFPF"."RFCOD" = '21' ) AND  
					 ( "REFFPF"."RFGUB" = :s_cod )   ;
		
			IF SQLCA.SQLCODE <> 0 THEN
				this.SetItem(1,"wcdsc1",sNull)
			ELSE	
				this.SetItem(1,"wcdsc1", left(s_nam1, 20))
			END IF
		End if
	Case 	"wkctr2"
		if	ddlb_1.text = '작업장별'	then
			i_rtn = f_get_name2("작업장", "N", s_cod, s_nam1, s_nam2)
			this.object.wkctr2[1] = s_cod
			this.object.wcdsc2[1] = s_nam1
			return i_rtn
		Else                                              // - 공정별
			SELECT "REFFPF"."RFNA1"  
			  INTO :s_nam1  
			  FROM "REFFPF"  
			 WHERE ( "REFFPF"."SABU" = '1' ) AND  
					 ( "REFFPF"."RFCOD" = '21' ) AND  
					 ( "REFFPF"."RFGUB" = :s_cod )   ;
		
			IF SQLCA.SQLCODE <> 0 THEN
				this.SetItem(1,"wcdsc2",sNull)
			ELSE	
				this.SetItem(1,"wcdsc2", left(s_nam1, 20))
			END IF
		End If
End Choose

return
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF keydown(keyF2!) THEN
	if this.GetColumnName() = "itnbr1" then
	   open(w_itemas_popup2)
	   this.object.itnbr1[1] = gs_code
	   this.object.itdsc1[1] = gs_codename
		return
   elseif this.GetColumnName() = "itnbr2" then
	   open(w_itemas_popup2)
	   this.object.itnbr2[1] = gs_code
	   this.object.itdsc2[1] = gs_codename
		return
   end if	
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose	Case 	this.GetColumnName()
	Case 	"itnbr1" 
		open(w_itemas_popup)
		this.object.itnbr1[1] = gs_code
		this.object.itdsc1[1] = gs_codename
	Case 	"itnbr2" 
		open(w_itemas_popup)
		this.object.itnbr2[1] = gs_code
		this.object.itdsc2[1] = gs_codename
	Case 	"wkctr1" 
		if	ddlb_1.text = '작업장별'	then
			open(w_workplace_popup)
			this.object.wkctr1[1] = gs_code
			this.object.wcdsc1[1] = gs_codename
		End If
	Case 	"wkctr2" 
		if	ddlb_1.text = '작업장별'	then
			open(w_workplace_popup)
			this.object.wkctr2[1] = gs_code
			this.object.wcdsc2[1] = gs_codename
		End If
End Choose

return
end event

type r_1 from w_standard_print`r_1 within w_pdt_02690
end type

type r_2 from w_standard_print`r_2 within w_pdt_02690
end type

type st_1 from statictext within w_pdt_02690
integer x = 64
integer y = 84
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
boolean enabled = false
string text = "* 출력구분"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_pdt_02690
integer x = 361
integer y = 72
integer width = 640
integer height = 284
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = true
boolean border = false
boolean sorted = false
boolean vscrollbar = true
string item[] = {"품목별","작업장별","공정별"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;dw_ip.SetRedraw(False)
CHOOSE CASE index
	CASE 1   //품목별
		dw_ip.DataObject 	= "d_pdt_02690_01"
      	dw_list.DataObject 	= "d_pdt_02690_02"
	   	dw_print.DataObject = "d_pdt_02690_02_p"
   CASE 2   //작업장별
		dw_ip.DataObject 	= "d_pdt_02700_01"
      	dw_list.DataObject 	= "d_pdt_02700_02"
      	dw_print.DataObject = "d_pdt_02700_02_p" 
   CASE 3   //공정별
		dw_ip.DataObject 	= "d_pdt_02700_05"
      	dw_list.DataObject 	= "d_pdt_02700_06"
      	dw_print.DataObject = "d_pdt_02700_06_p" 
END CHOOSE
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)

dw_ip.SetFocus()



end event


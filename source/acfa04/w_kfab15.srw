$PBExportHeader$w_kfab15.srw
$PBExportComments$제조일반구분별 감가상각명세서
forward
global type w_kfab15 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfab15
end type
end forward

global type w_kfab15 from w_standard_print
integer x = 0
integer y = 0
string title = "제조일반구분별 감가상각명세서"
boolean maxbox = true
rr_1 rr_1
end type
global w_kfab15 w_kfab15

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sSaupj, sKfCod1F, sKfCod2F, sBaseDate, gbn
Long  lKfCod1T,  lKfCod2T

sle_msg.text =""

dw_ip.AcceptText()

sSaupj    = dw_ip.GetItemString(1,"saupj")
sBaseDate = Trim(dw_ip.getitemstring(1, 'basedate'))
sKfCod1F  = dw_ip.GetItemString(1,"kfcod1_from")
lKfCod1T  = dw_ip.GetItemNumber(1,"kfcod1_to")
sKfCod2F  = dw_ip.GetItemString(1,"kfcod2_from")
lKfCod2T  = dw_ip.GetItemNumber(1,"kfcod2_to")
gbn  = dw_ip.GetItemString(1, "gbn")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sSaupj = "99" THEN sSaupj = '%'

IF IsNUll(sBaseDate) OR sBaseDate = "" THEN
	F_MessageChk(1,'[감가상각일자]')
	dw_ip.SetColumn('basedate')
	dw_ip.SetFocus()
	Return -1
END IF

if IsNUll(sKfCod1F) then sKfCod1F = 'A'
if IsNUll(lKfCod1T) then lKfCod1T = 0
if IsNUll(sKfCod2F) then sKfCod2F = 'Z'
if IsNUll(lKfCod2T) then lKfCod2T = 99999999
if isnull(gbn) or gbn = "" then gbn = '%'

//IF F_AccountRange('1',sBaseDate,sBaseDate,'','') = -1 THEN
//   Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
//   dw_ip.SetColumn('basedate')
//   dw_ip.SetFocus()	
//   return -1
//END IF

if sKfCod1F > sKfCod2F then
   Messagebox("확 인","고정자산 약칭코드의 범위를 확인하시오. !")
   dw_ip.SetColumn("kfcod1_from")
   dw_ip.SetFocus()	
   return -1
else
   if sKfCod1F = sKfCod2F and lKfCod1T > lKfCod2T then
      Messagebox("확 인","고정자산 SEQ의 범위를 확인하시오. !")
      dw_ip.SetColumn("kfcod2")
	   dw_ip.SetFocus()	
      return -1
    end if
end if

setpointer(hourglass!)

IF dw_print.Retrieve(sSaupj, sBaseDate, sKfCod1F,lKfCod1T,sKfCod2F,lKfCod2T, gbn) <=0 THEN
   F_MessageChk(14,'')
   dw_ip.SetFocus()
   return -1
end if

setpointer(ARROW!)
dw_print.sharedata(dw_list)

Return 1
end function

on w_kfab15.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfab15.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String   sRfgub
Integer  iRtnVal

SELECT MAX("REFFPF"."RFGUB")
 INTO :sRfgub 
 FROM "REFFPF"  
WHERE "REFFPF"."RFCOD" = 'F1'   ;

dw_ip.SetItem(1, 'saupj', gs_saupj)
dw_ip.SetItem(1, 'basedate', f_today())
dw_ip.SetItem(1, 'kfcod1_from', "A")
dw_ip.SetItem(1, 'kfcod1_to', 1)
dw_ip.SetItem(1, 'kfcod2_from', sRfgub)
dw_ip.SetItem(1, 'kfcod2_to', 99999999)
dw_ip.SetItem(1, 'gbn', '1')
dw_ip.SetItem(1, 'gubun', '1')

iRtnVal = F_Authority_Chk(Gs_Dept)
IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
	
	dw_ip.Modify("saupj.protect = 1")
ELSE
	dw_ip.Modify("saupj.protect = 0")
END IF	

dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kfab15
integer x = 4087
end type

type p_exit from w_standard_print`p_exit within w_kfab15
integer x = 4434
end type

type p_print from w_standard_print`p_print within w_kfab15
integer x = 4261
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfab15
integer x = 3913
end type







type st_10 from w_standard_print`st_10 within w_kfab15
end type



type dw_print from w_standard_print`dw_print within w_kfab15
string dataobject = "dw_kfab15_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfab15
integer x = 18
integer y = 20
integer width = 3808
integer height = 240
string dataobject = "dw_kfab15_1"
end type

event dw_ip::itemchanged;String ls_saupj, ls_datebase, snull, sGubun

SetNull(snull)

dw_ip.AcceptText()

If dw_ip.GetColumnName() = 'saupj' then
	ls_saupj = dw_ip.GetText()
	If ls_saupj = "" or isnull(ls_saupj) then return
	
	If isnull(f_get_refferance('AD', ls_saupj)) then
		f_messagechk(20, "사업장")
		dw_ip.setItem(1,"saupj",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'basedate' THEN
	ls_datebase = Trim(this.GetText())
	IF ls_datebase = "" OR isnull(ls_datebase) THEN Return
	
	IF F_DateChk(ls_datebase) = -1 THEN
		F_MessageChk(21,'[상각년월기간]')
		dw_ip.setItem(1,'basedate', snull)			
		Return 1
	END IF
END IF

if this.getcolumnname() = 'gubun' then
	sGubun = this.GetText()
	
	dw_list.SetRedraw(False)
	if sGubun = '1' then	
		dw_list.DataObject = 'dw_kfab15_2'
		dw_print.DataObject = 'dw_kfab15_2_p'
	else
		dw_list.DataObject = 'dw_kfab15_3'
		dw_print.DataObject = 'dw_kfab15_3_p'
	end if
	dw_print.SetTransObject(Sqlca)
	dw_list.Reset()
	dw_list.SetRedraw(True)
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::getfocus;call super::getfocus;dw_ip.AcceptText()
end event

event dw_ip::rbuttondown;String ls_kfcod1_from, ls_kfcod2_from
Long ll_kfcod1_to, ll_kfcod2_to, row_num, ll_retrieve_row

SetNull(gs_code)
SetNull(gs_codename)

dw_ip.AcceptText()

if this.getcolumnname() = 'kfcod1_to' then
	row_num = dw_ip.getrow()
	
	ls_kfcod1_from = dw_ip.getitemstring(row_num, 'kfcod1_from')
	ll_kfcod1_to = dw_ip.getitemnumber(row_num, 'kfcod1_to')
	
	if isnull(ls_kfcod1_from) then ls_kfcod1_from = ""
	if isnull(ll_kfcod1_to) then ll_kfcod1_to = 0
	
	gs_code = ls_kfcod1_from
	gs_codename = string(ll_kfcod1_to)
	
	open(w_kfaa02b)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), 'kfcod1_from', gs_code)
	dw_ip.setitem(dw_ip.getrow(), 'kfcod1_to', integer(gs_codename))
	
end if

if this.getcolumnname() = 'kfcod2_to' then
	row_num = dw_ip.getrow()
	
	ls_kfcod2_from = dw_ip.getitemstring(row_num, 'kfcod2_from')
	ll_kfcod2_to = dw_ip.getitemnumber(row_num, 'kfcod2_to')
	
	if isnull(ls_kfcod2_from) then ls_kfcod2_from = ""
	if isnull(ll_kfcod2_to) then ll_kfcod2_to = 0
	
	gs_code = ls_kfcod2_from
	gs_codename = string(ll_kfcod2_to)
	
	open(w_kfaa02b)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), 'kfcod2_from', gs_code)
	dw_ip.setitem(dw_ip.getrow(), 'kfcod2_to', integer(gs_codename))
	
end if


dw_ip.setfocus()

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfab15
integer x = 41
integer y = 264
integer width = 4553
integer height = 1940
string dataobject = "dw_kfab15_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfab15
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_kfab16.srw
$PBExportComments$기간별 감가상각명세서
forward
global type w_kfab16 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfab16
end type
end forward

global type w_kfab16 from w_standard_print
integer x = 0
integer y = 0
string title = "기간별 감가상각명세서 조회출력"
boolean maxbox = true
rr_1 rr_1
end type
global w_kfab16 w_kfab16

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sSaupj, sKfCod1F, sKfCod1T, sDateF, sDateT, ls_getcod1, ls_getcod2
Long  lKfCod2F, lKfCod2T

sle_msg.text =""

dw_ip.AcceptText()

sSaupj    = dw_ip.GetItemString(1,"saupj")
sDateF = Trim(dw_ip.getitemstring(1, 'kfym_from'))
sDateT = Trim(dw_ip.getitemstring(1, 'kfym_to'))
sKfCod1F  = dw_ip.GetItemString(1,"kfcod1_from")
sKfCod1T  = dw_ip.GetItemString(1,"kfcod1_to")
lKfCod2F  = dw_ip.GetItemNumber(1,"kfcod2_from")
lKfCod2T  = dw_ip.GetItemNumber(1,"kfcod2_to")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sSaupj = "99" THEN sSaupj = '%'

IF IsNUll(sDateF) OR sDateF = "" THEN
	F_MessageChk(1,'[감가상각일자]')
	dw_ip.SetColumn('kfym_from')
	dw_ip.SetFocus()
	Return -1
END IF

IF IsNUll(sDateT) OR sDateT = "" THEN
	F_MessageChk(1,'[감가상각일자]')
	dw_ip.SetColumn('kfym_to')
	dw_ip.SetFocus()
	Return -1
END IF

if IsNUll(sKfCod1F) then sKfCod1F = 'A'
if IsNUll(sKfCod1T) then sKfCod1T = 'Z'
if IsNUll(lKfCod2F) then lKfCod2F = 0
if IsNUll(lKfCod2T) then lKfCod2T = 99999999

//IF F_AccountRange('1',sDateF+'01',sDateT+'01',sDateF,sDateT) = -1 THEN
//   Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
//   dw_ip.SetColumn('kfym_from')
//   dw_ip.SetFocus()	
//   return -1
//END IF

if sKfCod1F > sKfCod1T then
   Messagebox("확 인","고정자산 약칭코드의 범위를 확인하시오. !")
   dw_ip.SetColumn("kfcod1_from")
   dw_ip.SetFocus()	
   return -1
else
   if sKfCod1F = sKfCod1T and lKfCod2F > lKfCod2T then
      Messagebox("확 인","고정자산 SEQ의 범위를 확인하시오. !")
      dw_ip.SetColumn("kfcod2")
	   dw_ip.SetFocus()	
      return -1
    end if
end if

  SELECT MAX("KFA10OT0"."KFCOD1"), MAX("KFA10OT0"."KFCOD2")
      INTO :ls_getcod1, :ls_getcod2
      FROM "KFA10OT0"  
   WHERE ("KFA10OT0"."KFYYMM" = :sDateT )  ;
if sqlca.sqlcode <> 0 then
   Messagebox("확 인","해당상각년월의 To기간의 자료가 존재하지 않습니다. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn('saupj')
   return -1
end if

setpointer(hourglass!)

IF dw_print.Retrieve(sSaupj, sDateF, sDateT, sKfCod1F,lKfCod2F,sKfCod1T,lKfCod2T) <=0 THEN
   F_MessageChk(14,'')
   dw_ip.SetFocus()
   //return -1
	dw_list.insertrow(0)
end if

setpointer(ARROW!)
dw_print.sharedata(dw_list)

Return 1
end function

on w_kfab16.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfab16.destroy
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
dw_ip.SetItem(1, 'kfym_from', left(f_today(), 4)+"01")
dw_ip.SetItem(1, 'kfym_to', left(f_today(), 6))
dw_ip.SetItem(1, 'kfcod1_from', "A")
dw_ip.SetItem(1, 'kfcod2_from', 1)
dw_ip.SetItem(1, 'kfcod1_to', sRfgub)
dw_ip.SetItem(1, 'kfcod2_to', 99999999)
dw_ip.SetItem(1, 'gubun', '1')

iRtnVal = F_Authority_Chk(Gs_Dept)
IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
	
	dw_ip.Modify("saupj.protect = 1")
	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_ip.Modify("saupj.protect = 0")
	dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
END IF	
	
dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kfab16
end type

type p_exit from w_standard_print`p_exit within w_kfab16
end type

type p_print from w_standard_print`p_print within w_kfab16
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfab16
end type







type st_10 from w_standard_print`st_10 within w_kfab16
end type



type dw_print from w_standard_print`dw_print within w_kfab16
string dataobject = "dw_kfab16_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfab16
integer x = 32
integer width = 3689
integer height = 200
string dataobject = "dw_kfab16_1"
end type

event dw_ip::getfocus;call super::getfocus;dw_ip.AcceptText()
end event

event dw_ip::itemchanged;String ls_saupj, ls_datefrom, ls_dateto, snull, sGubun

SetNull(snull)
dw_ip.AcceptText()

If dw_ip.GetColumnName() = 'saupj' then
	ls_saupj = dw_ip.GetText()
	If ls_saupj = "" or isnull(ls_saupj) then return
	
	If isnull(f_get_refferance('AD', ls_saupj)) then
		f_messagechk(20, "회계단위")
		dw_ip.setItem(1,"saupj",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'kfym_from' THEN
	ls_datefrom = Trim(this.GetText())
	IF ls_datefrom = "" OR isnull(ls_datefrom) THEN Return
	
	IF F_DateChk(ls_datefrom+'01') = -1 THEN
		F_MessageChk(21,'[상각년월기간]')
		dw_ip.setItem(1,'kfym_from', snull)			
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'kfym_to' THEN
	ls_dateto = Trim(this.GetText())
	IF ls_dateto = "" OR isnull(ls_dateto) THEN Return
	
	IF F_DateChk(ls_dateto+'01') = -1 THEN
		F_MessageChk(21,'[상각년월기간]')
		dw_ip.setItem(1,'kfym_to', snull)			
		Return 1
	END IF
END IF

if this.getcolumnname() = 'gubun' then
	sGubun = this.GetText()
	
	dw_list.SetRedraw(False)
	if sGubun = '1' then	
		dw_list.Title = '기간별 감가상각 명세서'
		dw_list.DataObject = 'dw_kfab16_2'
		dw_print.DataObject = 'dw_kfab16_2_p'
	else
		dw_list.Title = '기간별 감가상각 집계표'
		dw_list.DataObject = 'dw_kfab16_3'
		dw_print.DataObject = 'dw_kfab16_3_p'
	end if
	dw_list.SetTransObject(Sqlca)
	dw_print.SetTransObject(Sqlca)
	dw_list.Reset()
	dw_list.SetRedraw(True)
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;String ls_kfcod1_from, ls_kfcod1_to, sGubun
Integer ikfcod2_from, ikfcod2_to, row_num, iretrieve_row

SetNull(gs_code)
SetNull(gs_codename)

dw_ip.AcceptText()

if this.getcolumnname() = 'kfcod2_from' then
	row_num = dw_ip.getrow()
	
	ls_kfcod1_from = dw_ip.getitemstring(row_num, 'kfcod1_from')
	ikfcod2_from = dw_ip.getitemnumber(row_num, 'kfcod2_from')
	
	if isnull(ls_kfcod1_from) then ls_kfcod1_from = ""
	if isnull(ikfcod2_from) then ikfcod2_from = 0
	
	gs_code = ls_kfcod1_from
	gs_codename = string(ikfcod2_from)
	
	open(w_kfaa02b)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), 'kfcod1_from', gs_code)
	dw_ip.setitem(dw_ip.getrow(), 'kfcod2_from', integer(gs_codename))
	
end if

if this.getcolumnname() = 'kfcod2_to' then
	row_num = dw_ip.getrow()
	
	ls_kfcod1_to = dw_ip.getitemstring(row_num, 'kfcod1_to')
	ikfcod2_to = dw_ip.getitemnumber(row_num, 'kfcod2_to')
	
	if isnull(ls_kfcod1_to) then ls_kfcod1_to = ""
	if isnull(ikfcod2_to) then ikfcod2_to = 0
	
	gs_code = ls_kfcod1_to
	gs_codename = string(ikfcod2_to)
	
	open(w_kfaa02b)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), 'kfcod1_to', gs_code)
	dw_ip.setitem(dw_ip.getrow(), 'kfcod2_to', integer(gs_codename))
		
end if

dw_ip.setfocus()

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfab16
integer x = 50
integer y = 228
integer width = 4553
integer height = 1984
string dataobject = "dw_kfab16_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfab16
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 220
integer width = 4576
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type


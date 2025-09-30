$PBExportHeader$w_kfab13.srw
$PBExportComments$감가상각명세서(원가부문별)조회 출력
forward
global type w_kfab13 from w_standard_print
end type
type st_wait from statictext within w_kfab13
end type
type rr_1 from roundrectangle within w_kfab13
end type
end forward

global type w_kfab13 from w_standard_print
integer x = 0
integer y = 0
string title = "감가상각명세서(원가부문별) 조회 출력"
boolean maxbox = true
st_wait st_wait
rr_1 rr_1
end type
global w_kfab13 w_kfab13

type variables
String proc_gu
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();char    dkfcod1, dtfcod1
long    dkfcod2, dtfcod2, row_num
string  DCOMPUTE_YEARMMDD, DKFYEAR, yy, TEMP_YMD, DGBN1, DGBN2, dgbn1nm, dgbn2nm, dsaupj, dname
DECIMAL BASICVALUE, DR, CR, DEYEAR, DEMONTH, DEVALUE_MAKE, DEVALUE_COMMON, RAT
INTEGER II, RC


setpointer(hourglass!)
sle_msg.text =""
dw_ip.AcceptText()
row_num = dw_ip.GetRow()

dSAUPJ  = dw_ip.GetItemString(row_num,"kfSACOD")
dkfcod1  = dw_ip.GetItemString(row_num,"kfcod1")
dtfcod1  = dw_ip.GetItemString(row_num,"tfcod1")
dkfcod2  = dw_ip.GetItemNumber(row_num,"kfcod2")
dtfcod2  = dw_ip.GetItemNumber(row_num,"tfcod2")
DCOMPUTE_YEARMMDD = dw_ip.GetItemString(row_num,"COMPUTE_YEARMMDD")
dgbn1    = dw_ip.GetItemString(row_num,"gbn1")
dgbn2    = dw_ip.GetItemString(row_num,"gbn2")

IF dSaupj = "" OR IsNull(dSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("kfSACOD")
	dw_ip.SetFocus()
	Return -1
END IF

if dgbn1 = '1' then
	dgbn1nm = '유형'
elseif dgbn1 ='2' then
	dgbn1nm = '무형'
else
	dgbn1nm = '전체'
end if
if dgbn2 = 'Y' then
	dgbn2nm = '상각완료'
elseif dgbn2 ='N' then
	dgbn2nm = '상각중'
else
	dgbn2nm = '전체'
end if

if IsNUll(dkfcod1) then dkfcod1 = ""
if IsNUll(dtfcod1) then dtfcod1 = ""
if IsNUll(dkfcod2) then dkfcod2 = 0
if IsNUll(dtfcod2) then dtfcod2 = 0
if IsNUll(DCOMPUTE_YEARMMDD) then DCOMPUTE_YEARMMDD = ""

SELECT "KFA07OM0"."KFYEAR"  
  INTO :DKFYEAR  
  FROM "KFA07OM0"  ;

YY = LEFT(DCOMPUTE_YEARMMDD,4)
//if YY <> DKFYEAR Then
//   Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
//   dw_ip.SetFocus()
//   dw_ip.SetColumn(3)
//   return
//end if

SELECT "REFFPF"."RFNA1"    INTO :dname
  FROM "REFFPF"  
 WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
       ( "REFFPF"."RFGUB" = :DSAUPJ )   ;

if dsaupj = '99' then dsaupj = '%'

TEMP_YMD = LEFT(DCOMPUTE_YEARMMDD, 4) + '/' + MID(DCOMPUTE_YEARMMDD, 5 ,2) + '/' + RIGHT(DCOMPUTE_YEARMMDD, 2)
if NOT ISDATE(TEMP_YMD) Then
   Messagebox("확 인","감가상각일자는 유효한 일자 아닙니다. !")
   dw_ip.SetColumn(3)
	dw_ip.SetFocus()
   return -1
end if

if dtfcod1 = "" then
   dtfcod1 = dkfcod1 
   dw_ip.SetItem(row_num,"tfcod1",dtfcod1)
end if

if dtfcod2 = 0 then
   dtfcod2 = dkfcod2
   dw_ip.SetItem(row_num,"tfcod2",dtfcod2)
end if

if dkfcod1 > dtfcod1 then
   Messagebox("확 인","고정자산 약칭코드의 범위를 확인하시오. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(1)
   return -1
else
   if dkfcod1 = dtfcod1 and dkfcod2 > dtfcod2 then
      Messagebox("확 인","고정자산 SEQ의 범위를 확인하시오. !")
      dw_ip.SetFocus()
      dw_ip.SetColumn(2)
      return -1
    end if
end if

row_num = dw_print.Retrieve(dsaupj,dname,dkfcod1,dkfcod2,dtfcod1,dtfcod2,DCOMPUTE_YEARMMDD,DGBN1,DGBN2,dgbn1nm,dgbn2nm)

if row_num <= 0 then
   Messagebox("확 인","출력범위에 해당하는 자료가 없습니다. !")
   dw_ip.SetFocus()
   return -1
end if

ST_WAIT.VISIBLE = FALSE
setpointer(ARROW!)
dw_print.sharedata(dw_list)

Return 1
end function

on w_kfab13.create
int iCurrent
call super::create
this.st_wait=create st_wait
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_wait
this.Control[iCurrent+2]=this.rr_1
end on

on w_kfab13.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_wait)
destroy(this.rr_1)
end on

event w_kfab13::open;call super::open;Int iRtnval
String sRfgub

SELECT MAX("REFFPF"."RFGUB")
 INTO :sRfgub 
 FROM "REFFPF"  
WHERE "REFFPF"."RFCOD" = 'F1'   ;

dw_ip.SetItem(dw_ip.GetRow(), "COMPUTE_YEARMMDD", f_today())
dw_ip.SetItem(dw_ip.GetRow(), "KFCOD1","A")
dw_ip.SetItem(dw_ip.GetRow(), "KFCOD2",1)
dw_ip.SetItem(dw_ip.GetRow(), "TFCOD1",sRfgub)
dw_ip.SetItem(dw_ip.GetRow(), "TFCOD2",99999999)
dw_ip.SetItem(dw_ip.GetRow(), "gbn1","%")
dw_ip.SetItem(dw_ip.GetRow(), "gbn2","%")
dw_ip.SetItem(dw_ip.GetRow(), "kfsacod",gs_saupj)
proc_gu ="95년 이전"

IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
	IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
		dw_ip.SetItem(dw_ip.GetRow(),"kfsacod",   Gs_Saupj)
		
		dw_ip.Modify("kfsacod.protect = 1")
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(192,192,192))+"'")
	ELSE
		dw_ip.Modify("kfsacod.protect = 0")
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(190,225,184))+"'")
	END IF
ELSE
	IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
		iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
	ELSE
		iRtnVal = F_Authority_Chk(Gs_Dept)
	END IF
	IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
		dw_ip.SetItem(dw_ip.GetRow(),"kfsacod",   Gs_Saupj)
		
		dw_ip.Modify("kfsacod.protect = 1")
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(192,192,192))+"'")
	ELSE
		dw_ip.Modify("kfsacod.protect = 0")
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(190,225,184))+"'")
	END IF	
END IF


end event

type p_preview from w_standard_print`p_preview within w_kfab13
end type

type p_exit from w_standard_print`p_exit within w_kfab13
end type

type p_print from w_standard_print`p_print within w_kfab13
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfab13
end type







type st_10 from w_standard_print`st_10 within w_kfab13
end type



type dw_print from w_standard_print`dw_print within w_kfab13
string dataobject = "dw_kfab13_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfab13
integer x = 32
integer y = 20
integer width = 3831
integer height = 216
string dataobject = "dw_kfab03_1"
end type

event dw_ip::itemchanged;call super::itemchanged;

IF dwo.name ="gubun" THEN
	dw_list.SetRedraw(False)
	IF data ="BEFORE" THEN
		dw_list.Title ="95년 이전"
		proc_gu ="95년 이전"
		dw_list.DataObject ="dw_kfab09_2"
	ELSEIF data ="NEXT" THEN
		dw_list.Title ="95년 이후"
		proc_gu ="95년 이후"
		dw_list.DataObject ="dw_kfab09_3"
	ELSE
		dw_list.Title ="전   체"
		proc_gu ="전   체"
		dw_list.DataObject ="dw_kfab09_4"
	END IF
	dw_list.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)
END IF
end event

event dw_ip::rbuttondown;char dkfcod1
long dkfcod2, row_num, retrieve_row 

SetNull(gs_code)
SetNull(gs_codename)

dw_ip.AcceptText()

IF this.GetColumnName() ="kfcod2" THEN 	
	row_num  = dw_ip.Getrow()

	dkfcod1 = dw_ip.GetItemString( row_num, "kfcod1")
	dkfcod2 = dw_ip.GetItemNumber( row_num, "kfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)
	
	IF IsNull(gs_code) THEN RETURN
	
   dw_ip.setitem(dw_ip.Getrow(),"kfcod1",gs_code)
   dw_ip.Setitem(dw_ip.Getrow(),"kfcod2",Long(gs_codename))
END IF

IF this.GetColumnName() ="tfcod2" THEN 	
	row_num  = dw_ip.Getrow()

	dkfcod1 = dw_ip.GetItemString( row_num, "tfcod1")
	dkfcod2 = dw_ip.GetItemNumber( row_num, "tfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)
	
	IF IsNull(gs_code) THEN RETURN
	
   dw_ip.setitem(dw_ip.Getrow(),"tfcod1",gs_code)
   dw_ip.Setitem(dw_ip.Getrow(),"tfcod2",Long(gs_codename))
END IF

dw_ip.setfocus()


end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfab13
integer x = 46
integer y = 240
integer width = 4549
integer height = 1984
string dataobject = "dw_kfab13_2"
boolean border = false
end type

type st_wait from statictext within w_kfab13
boolean visible = false
integer x = 46
integer y = 2272
integer width = 1947
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
boolean enabled = false
string text = "당기상각액을  계산하고 있습니다. 잠시만 기다리십시오."
alignment alignment = center!
boolean border = true
long bordercolor = 255
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfab13
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 236
integer width = 4571
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type


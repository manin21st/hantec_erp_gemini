$PBExportHeader$w_kfab01.srw
$PBExportComments$고정자산마스타 조회 출력
forward
global type w_kfab01 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfab01
end type
end forward

global type w_kfab01 from w_standard_print
integer x = 0
integer y = 0
string title = "고정자산마스타 조회 출력"
boolean maxbox = true
rr_1 rr_1
end type
global w_kfab01 w_kfab01

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Double dkfcod2, dtfcod2, row_num
string dkfmdpt, dkfaqdt, dtfaqdt,dkfcod1, dtfcod1, dkfsacod
int i, dis_row 

setpointer(hourglass!)

dw_ip.AcceptText()
row_num = dw_ip.GetRow()

w_mdi_frame.sle_msg.text =""

dkfsacod = dw_ip.GetItemString(row_num,"kfsacod")

IF dkfsacod = "" OR IsNull(dkfsacod) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("kfsacod")
	dw_ip.SetFocus()
	Return -1
END IF

IF dkfsacod = "99" THEN dkfsacod = "%"

dkfcod1  = dw_ip.GetItemString(row_num,"kfcod1")
dtfcod1  = dw_ip.GetItemString(row_num,"tfcod1")
dkfcod2  = dw_ip.GetItemNumber(row_num,"kfcod2")
dtfcod2  = dw_ip.GetItemNumber(row_num,"tfcod2")
dkfmdpt  = dw_ip.GetItemString(row_num,"kfmdpt")
dkfaqdt  = dw_ip.GetItemString(row_num,"kfaqdt")
dtfaqdt  = dw_ip.GetItemString(row_num,"tfaqdt")

if IsNUll(dkfcod1) then dkfcod1 = ""
if IsNUll(dtfcod1) then dtfcod1 = ""
if IsNUll(dkfcod2) then dkfcod2 = 0
if IsNUll(dtfcod2) then dtfcod2 = 0
if IsNUll(dkfmdpt) then dkfmdpt = ""
if IsNUll(dkfaqdt) then dkfaqdt = ""
if IsNUll(dtfaqdt) then dtfaqdt = ""

if dtfcod1 = "" then
   dtfcod1 = dkfcod1 
   dw_ip.SetItem(row_num,"tfcod1",dtfcod1)
end if

if dtfcod2 = 0 then
   dtfcod2 = dkfcod2
   dw_ip.SetItem(row_num,"tfcod2",dtfcod2)
end if

if dkfmdpt = "" or isnull(dkfmdpt) then dkfmdpt = '%'
if dkfaqdt = "" or isnull(dkfaqdt) then dkfaqdt = '00001231'
if dtfaqdt = "" or isnull(dtfaqdt) then dtfaqdt = '99991231'

if dkfcod1 > dtfcod1 then
   Messagebox("확 인","고정자산 약칭코드의 범위를 확인하시오. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(2)
   return -1
else
   if dkfcod1 = dtfcod1 and dkfcod2 > dtfcod2 then
      Messagebox("확 인","고정자산 번호의 범위를 확인하시오. !")
      dw_ip.SetFocus()
      dw_ip.SetColumn(3)
      return -1
    end if
end if

if dkfaqdt > dtfaqdt then
   Messagebox("확 인","취득일의 범위를 확인하시오. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(5)
   return -1
end if

row_num = dw_print.Retrieve(dkfsacod,dkfcod1,dtfcod1,dkfcod2,dtfcod2,dkfmdpt, &
                           dkfaqdt,dtfaqdt )
if row_num <= 0 then
   F_MessageChk(14,'')
   return -1
end if

dw_print.sharedata(dw_list)

Return 1
end function

on w_kfab01.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfab01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sRfgub
Int irtnval

  SELECT MAX("REFFPF"."RFGUB")
    INTO :sRfgub 
    FROM "REFFPF"  
   WHERE "REFFPF"."RFCOD" = 'F1'   ;
	
	If sqlca.sqlcode = 0 then
	
		dw_ip.SetItem(dw_ip.GetRow(), "kfsacod",gs_saupj)
		dw_ip.SetItem(dw_ip.GetRow(), "kfcod1","A")
		dw_ip.SetItem(dw_ip.GetRow(), "kfcod2",1)
		dw_ip.SetItem(dw_ip.GetRow(), "tfcod1",sRfgub)
		dw_ip.SetItem(dw_ip.GetRow(), "tfcod2",99999999)
		
	End If

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
//		dw_ip.Modify("kfsacod.background.color ='"+String(RGB(255,255,255))+"'")
	END IF	
END IF

//dw_ip.SetItem(dw_ip.GetRow(), "kfaqdt",Left(f_Today(),4)+'0101')
//dw_ip.SetItem(dw_ip.GetRow(), "tfaqdt",F_Today())

end event

type p_preview from w_standard_print`p_preview within w_kfab01
integer x = 4105
end type

type p_exit from w_standard_print`p_exit within w_kfab01
integer x = 4453
end type

type p_print from w_standard_print`p_print within w_kfab01
integer x = 4279
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfab01
integer x = 3931
end type







type st_10 from w_standard_print`st_10 within w_kfab01
end type



type dw_print from w_standard_print`dw_print within w_kfab01
integer x = 4448
integer y = 184
string dataobject = "dw_kfab01_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfab01
integer x = 5
integer y = 28
integer width = 3063
integer height = 228
string dataobject = "dw_kfab01_1"
end type

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

type dw_list from w_standard_print`dw_list within w_kfab01
integer x = 23
integer y = 304
integer width = 4599
integer height = 1948
string dataobject = "dw_kfab01_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfab01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 292
integer width = 4617
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type


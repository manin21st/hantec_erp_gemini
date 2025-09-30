$PBExportHeader$w_kgld50.srw
$PBExportComments$현금출납장 조회출력(입출전표기준)
forward
global type w_kgld50 from w_standard_print
end type
type p_make from picture within w_kgld50
end type
type rr_2 from roundrectangle within w_kgld50
end type
end forward

global type w_kgld50 from w_standard_print
integer x = 0
integer y = 0
string title = "현금출납장 조회 출력"
p_make p_make
rr_2 rr_2
end type
global w_kgld50 w_kgld50

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaupj
string sacc_ymd, eacc_ymd, syy, smm, sdd, symd_text
string eyy, emm, edd, eymd_text
string ref_saup, sabu_z 
string srcode, rcode 		
		
dw_ip.AcceptText()

sSaupj =Trim(dw_ip.GetItemString(1,"saupj"))
IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

sacc_ymd = Trim(dw_ip.GetItemString(1,"k_symd")) 
IF sAcc_Ymd = "" OR IsNull(sAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sacc_ymd) = -1 THEN
		f_messagechk( 23, "")
		dw_ip.SetColumn("k_symd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

eacc_ymd = Trim(dw_ip.GetItemString(1,"k_eymd"))                
IF eAcc_Ymd = "" OR IsNull(eAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(eacc_ymd) = -1 THEN
		f_messagechk(23, "") 
		dw_ip.SetColumn("k_eymd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

if long(sacc_ymd) > long(eacc_ymd) then
	f_messagechk(24,"") 
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return -1
end if	

syy = left(sacc_ymd, 4)
smm = mid(sacc_ymd,5,2)
sdd = right(sacc_ymd,2)
symd_text = syy + '.'+ smm + '.' + sdd
dw_list.modify("symd.text ='"+symd_text+"'")

eyy = left(eacc_ymd, 4)
emm = mid(eacc_ymd,5,2)
edd = right(eacc_ymd,2)
eymd_text = eyy + '.'+ emm + '.' + edd

dw_print.modify("eymd.text ='"+eymd_text+"'")

  SELECT "REFFPF"."RFNA1"  
    INTO :ref_saup  
    FROM "REFFPF"  
	WHERE "REFFPF"."RFCOD" = 'AD'   AND
			"REFFPF"."RFGUB" = :sSaupj;

dw_print.modify("saup.text ='"+ref_saup+"'") // 사업명 move

setpointer(hourglass!)

//계정과목 받아오기(회계통제정보 화일에서)
SELECT "SYSCNFG"."DATANAME"  										//현금
	INTO :srcode
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND  ( "SYSCNFG"."SERIAL" = 1 ) AND  
     		( "SYSCNFG"."LINENO" = '1' )   ;
rcode = mid(srcode, 1, 7) 

dw_list.SetRedraw(false)
if dw_print.retrieve(sSaupj,syy,sabu_f,sabu_t,sacc_ymd,eacc_ymd,rcode) <= 0 then
	F_MessageChk(14,'') 
   dw_list.SetRedraw(true)	
	return -1	 
ELSE
	dw_list.retrieve(sSaupj,syy,sabu_f,sabu_t,sacc_ymd,eacc_ymd,rcode)	
END IF

dw_list.SetRedraw(true)	
setpointer(arrow!)

return 1
end function

on w_kgld50.create
int iCurrent
call super::create
this.p_make=create p_make
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_make
this.Control[iCurrent+2]=this.rr_2
end on

on w_kgld50.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_make)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_ip.SetItem(1,"k_symd", Left(f_today(), 6)+'01')
dw_ip.SetItem(1,"k_eymd",f_today())
dw_ip.SetItem(1,"saupj", gs_saupj)
dw_ip.SetFocus()

w_mdi_frame.sle_msg.text = ''
end event

type p_xls from w_standard_print`p_xls within w_kgld50
end type

type p_sort from w_standard_print`p_sort within w_kgld50
end type

type p_preview from w_standard_print`p_preview within w_kgld50
end type

type p_exit from w_standard_print`p_exit within w_kgld50
end type

type p_print from w_standard_print`p_print within w_kgld50
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld50
end type

type st_window from w_standard_print`st_window within w_kgld50
integer x = 2405
integer width = 466
end type

type sle_msg from w_standard_print`sle_msg within w_kgld50
integer width = 2007
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld50
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld50
end type

type gb_10 from w_standard_print`gb_10 within w_kgld50
integer width = 3607
end type

type dw_print from w_standard_print`dw_print within w_kgld50
integer x = 2578
integer y = 12
integer width = 110
integer height = 108
string dataobject = "dw_kgld502_p"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_kgld50
integer x = 23
integer width = 2432
integer height = 152
string dataobject = "dw_kgld501"
end type

type dw_list from w_standard_print`dw_list within w_kgld50
integer x = 41
integer y = 180
integer width = 4558
integer height = 1976
string title = "현금 출납장"
string dataobject = "dw_kgld502"
boolean border = false
end type

event dw_list::clicked;call super::clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(Row,True)
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)
end event

type p_make from picture within w_kgld50
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3749
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\Erpman\image\생성_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\생성_up.gif'
end event

event clicked;Integer iFunVal
String sSaupj,sSaupj_f,sSaupj_t,sAcc_ymd,eAcc_ymd

SetPointer(Hourglass!)

w_mdi_frame.sle_msg.text = ""

dw_ip.AcceptText()

sSaupj = Trim(dw_ip.GetItemString(1,"saupj"))
If Isnull(sSaupj) Or Len(sSaupj) = 0 Or sSaupj = "99" Then
	sSaupj_f = "1"
	sSaupj_t = "98"
Else
	sSaupj_f = sSaupj
	sSaupj_t = sSaupj
End if

sAcc_ymd = Trim(dw_ip.GetItemString(1,"k_symd"))
If sAcc_Ymd = "" Or IsNull(sAcc_Ymd) Then
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	SetPointer(Arrow!)
	Return
Else
	If f_datechk(sAcc_ymd) = -1 Then
		f_messagechk( 23, "")
		dw_ip.SetColumn("k_symd")
		dw_ip.SetFocus()
		SetPointer(Arrow!)
		Return
	End if
End if

//에러체크 (to 날짜)
eAcc_ymd = Trim(dw_ip.GetItemString(1,"k_eymd"))
If eAcc_Ymd = "" Or IsNull(eAcc_Ymd) Then
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	SetPointer(Arrow!)
	Return
Else
	If f_datechk(eAcc_ymd) = -1 Then
		f_messagechk(23, "") 
		dw_ip.SetColumn("k_eymd")
		dw_ip.SetFocus()
		SetPointer(Arrow!)
		Return
	End if
End if

//날짜범위 체크
If long(sAcc_ymd) > long(eAcc_ymd) Then
	f_messagechk(24,"") 
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	SetPointer(Arrow!)
	Return
End if

iFunVal = sqlca.fun_cashout(sSaupj_f,sSaupj_t,sAcc_ymd,eAcc_ymd)
If iFunVal = -1 Then
	Rollback;
	MessageBox("확인","현금출납 집계 저장 실패!")
	SetPointer(Arrow!)
	Return
End if

Commit;

w_mdi_frame.sle_msg.text = "현금출납 집계작업이 정상적으로 종료되었습니다"

SetPointer(Arrow!)
end event

type rr_2 from roundrectangle within w_kgld50
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 172
integer width = 4590
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type


$PBExportHeader$w_kgld95.srw
$PBExportComments$일계표 조회/출력
forward
global type w_kgld95 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld95
end type
end forward

global type w_kgld95 from w_standard_print
string title = "일계표 조회 출력"
rr_1 rr_1
end type
global w_kgld95 w_kgld95

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String acc_ymd,acc_ymdt,sCashAcc,sBefYmd,sSaupj,ref_saup,sPrtGbn,sJunGbn
int    i, dis_row
Double dCashBef,dCashCur

dw_ip.AcceptText()

sSaupj   = dw_ip.GetItemString(1,"saupj")
acc_ymd  = Trim(dw_ip.GetItemString(1,"k_symd"))
acc_ymdt = Trim(dw_ip.GetItemString(1,"k_eymd"))
sJunGbn  = dw_ip.GetItemString(1,"upmu_gu")
sPrtGbn  = dw_ip.GetItemString(1,"prtgbn")

if acc_ymd = "" or isnull(acc_ymd) then
	f_messagechk( 23,"")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return 1
end if 
if acc_ymdt = "" or isnull(acc_ymdt) then
	f_messagechk( 23,"")
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	return 1
end if 

if acc_ymd > acc_ymdt then
	f_messagechk( 23,"기간을 확인하시오!")
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	return 1
end if

if sPrtGbn = '1' then
	/*현금계정*/
	SELECT "SYSCNFG"."DATANAME"      INTO :sCashAcc  
		FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '1' )   ;
				
	SELECT "REFFPF"."RFNA1"      INTO :ref_saup  
	  FROM "REFFPF"  
	 WHERE "REFFPF"."RFCOD" = 'AD'   AND "REFFPF"."RFGUB" = :sSaupj ;
	
	IF dw_print.Retrieve(sabu_f,sabu_t,acc_ymd,acc_ymdt,sCashAcc) <= 0 THEN
		F_MessageChk(14,'')
		Return -1
	END IF
else
	if sJunGbn = '' or IsNull(sJunGbn) then sJunGbn = '%'
	
	IF dw_print.Retrieve(sabu_f,sabu_t,acc_ymd,acc_ymdt,sJunGbn) <= 0 THEN
		F_MessageChk(14,'')
		Return -1
	END IF
end if

dw_print.sharedata(dw_list)
dw_ip.SetFocus()

Return 1
end function

on w_kgld95.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld95.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"k_symd",  f_today())
dw_ip.SetItem(1,"k_eymd",  f_today())
dw_ip.SetItem(1,"saupj",   gs_saupj)

dw_ip.SetFocus()

dw_list.DataObject = 'dw_kgld95_4'
dw_print.DataObject = 'dw_kgld95_4_p'
		
dw_list.SetTransObject(Sqlca)
dw_list.Reset()
dw_print.SetTransObject(Sqlca)
	


end event

type p_preview from w_standard_print`p_preview within w_kgld95
integer y = 0
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kgld95
integer y = 0
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kgld95
integer y = 0
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld95
integer y = 0
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kgld95
end type



type dw_print from w_standard_print`dw_print within w_kgld95
integer x = 3735
integer y = 24
string dataobject = "dw_kgld95_3_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld95
integer x = 9
integer y = 12
integer width = 3611
integer height = 252
string dataobject = "dw_kgld95"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;
if this.GetColumnName() = 'prtgbn' then
	dw_list.SetRedraw(False)
	dw_print.SetRedraw(False)
	if this.GetText() = '1' then							/*일계표(요약)*/
		dw_list.DataObject = 'dw_kgld95_2'
		dw_print.DataObject = 'dw_kgld95_2_p'
	elseif this.GetText() = '3' then
		dw_list.DataObject = 'dw_kgld95_3'
		dw_print.DataObject = 'dw_kgld95_3_p'
	else
		dw_list.DataObject = 'dw_kgld95_4'
		dw_print.DataObject = 'dw_kgld95_4_p'
	end if
	dw_list.SetTransObject(Sqlca)
	dw_list.Reset()
	dw_print.SetTransObject(Sqlca)
	
	dw_list.SetRedraw(True)
	dw_print.SetRedraw(True)
end if
end event

type dw_list from w_standard_print`dw_list within w_kgld95
integer x = 32
integer y = 272
integer width = 4567
integer height = 1976
string dataobject = "dw_kgld95_3"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::clicked;call super::clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(Row,True)
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

end event

event dw_list::buttonclicked;call super::buttonclicked;String sAcc1,sAcc2,sGbn6

this.AcceptText()
sAcc1 = this.GetItemString(this.GetRow(),"acc1_cd")
sAcc2 = this.GetItemString(this.GetRow(),"acc2_cd")
	
select gbn6 into :sGbn6	from kfz01om0
	where acc1_cd = :sAcc1 and acc2_cd = :sAcc2;
if sqlca.sqlcode = 0 then
	if IsNull(sGbn6) then sGbn6 = 'N'
else
	sGbn6 = 'N'
end if

Gs_Gubun = dw_ip.GetItemString(1,"saupj")
IF dwo.name = 'dcb_remain' THEN										/*잔액 조회*/
	if sGbn6 = 'Y' then
		OpenWithParm(w_kgld69a,Mid(dw_ip.GetItemString(1,"k_symd"),1,6) + &
									  sAcc1+sAcc2)
	end if
END IF

IF dwo.name = 'dcb_report' THEN										/*장부 조회*/
	OpenWithParm(w_kgld69b,Mid(dw_ip.GetItemString(1,"k_symd"),1,6) + &
									  sAcc1+sAcc2)
END IF
end event

type rr_1 from roundrectangle within w_kgld95
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 264
integer width = 4599
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type


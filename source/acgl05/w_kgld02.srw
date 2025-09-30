$PBExportHeader$w_kgld02.srw
$PBExportComments$월계표 조회/출력
forward
global type w_kgld02 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld02
end type
end forward

global type w_kgld02 from w_standard_print
integer x = 0
integer y = 0
string title = "월계표 조회 출력"
rr_1 rr_1
end type
global w_kgld02 w_kgld02

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaupj, sacc_ym, supmu_gu
int    idr_cnt, icr_cnt
double d_dramt,  d_cramt
string t_ymd, f_ymd

dw_ip.AcceptText()

sSaupj =Trim(dw_ip.GetItemString(1,"saupj"))
sacc_ym =dw_ip.GetItemString(1,"acc_ym")
supmu_gu = dw_ip.GetItemString(1,"upmu_gu")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

sacc_ym = Trim(sacc_ym)
if sacc_ym = "" or isnull(sacc_ym) then
	f_messagechk(22,"[회계년월]")
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	return 1
end if 

supmu_gu = Trim(supmu_gu)
IF supmu_gu = "" OR IsNull(supmu_gu) THEN
	supmu_gu = "%"
END IF

f_ymd = sacc_ym + '01'
t_ymd = sacc_ym + '31'

setpointer(hourglass!)
IF dw_print.Retrieve(sabu_f, sabu_t, f_ymd, t_ymd, supmu_gu) <= 0   THEN
	messagebox("확인","조회한 자료가 없습니다.!!") 
	return -1 
ELSE
	dw_print.Modify("saup.text = '"+F_Get_Refferance('AD',sabu_f)+"'")

	dw_print.Modify("ym.text = '"+left(sacc_ym, 4) + "." + mid(sacc_ym, 5, 2)+"'")	
	
	IF sUpmu_gu = '%' THEN
		dw_print.Modify("upmu.text = '전 체'")
	ELSE
		dw_print.Modify("upmu.text = '"+F_Get_Refferance('AG',supmu_gu)+"'")
	END IF
END IF

dw_print.sharedata(dw_list)

setpointer(arrow!)
dw_ip.SetFocus()

Return 1
end function

on w_kgld02.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;

lstr_jpra.flag =True

dw_datetime.settransobject(sqlca)
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_ip.SetItem(1,"acc_ym",Left(f_today(),6))

//dw_ip.SetItem(1,"upmu_gu",'A')

dw_ip.SetItem(1,"saupj", gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_kgld02
integer y = 4
end type

type p_exit from w_standard_print`p_exit within w_kgld02
integer y = 4
end type

type p_print from w_standard_print`p_print within w_kgld02
integer y = 4
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld02
integer y = 4
end type

type st_window from w_standard_print`st_window within w_kgld02
integer width = 494
end type





type st_10 from w_standard_print`st_10 within w_kgld02
end type



type dw_print from w_standard_print`dw_print within w_kgld02
string dataobject = "dw_kgld022_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld02
integer y = 28
integer width = 2903
integer height = 152
string dataobject = "dw_kgld021"
end type

type dw_list from w_standard_print`dw_list within w_kgld02
integer x = 55
integer y = 184
integer width = 4553
integer height = 2024
string title = "월계표"
string dataobject = "dw_kgld022"
boolean minbox = true
boolean border = false
end type

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
		OpenWithParm(w_kgld69a,dw_ip.GetItemString(1,"acc_ym") + &
									  sAcc1+sAcc2)
	end if
END IF

IF dwo.name = 'dcb_report' THEN										/*장부 조회*/
	OpenWithParm(w_kgld69b,dw_ip.GetItemString(1,"acc_ym") + &
									  sAcc1+sAcc2)
END IF

end event

type rr_1 from roundrectangle within w_kgld02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 180
integer width = 4581
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type


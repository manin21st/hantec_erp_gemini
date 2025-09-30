$PBExportHeader$w_kfia04a.srw
$PBExportComments$유가증권 조회 출력
forward
global type w_kfia04a from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia04a
end type
end forward

global type w_kfia04a from w_standard_print
integer x = 0
integer y = 0
string title = "유가증권 조회 출력"
rr_1 rr_1
end type
global w_kfia04a w_kfia04a

type variables
String ssaupjf,ssaupjt,sjz_gbn,sdatef,sdatet,sbnk_gb
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Int ll_rtn_chk

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sabu_f = '1'
sabu_t = 'Z'
sdatef  = dw_ip.getitemstring(dw_ip.getrow(),"datef")
sdatet  = dw_ip.getitemstring(dw_ip.getrow(),"datet")
sjz_gbn = dw_ip.getitemstring(dw_ip.getrow(),"jz_gbn")
sbnk_gb = dw_ip.getitemstring(dw_ip.getrow(),"bnk_gb")

IF sjz_gbn = "" OR isnull(sjz_gbn) THEN sjz_gbn = '%'

IF IsNull(sbnk_gb) OR sbnk_gb = "" THEN
	f_messagechk(20,"보관구분")
	dw_ip.SetColumn("bnk_gb")
	dw_ip.SetFocus()
	Return -1
END IF

ll_rtn_chk = dw_print.Retrieve(sabu_f,sabu_t,sjz_gbn,sdatef,sdatet,sbnk_gb)

IF ll_rtn_chk <=0 THEN
	f_messagechk(14,"")
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_kfia04a.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia04a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(),"datef",String(today(),"yyyymm")+'01')
dw_ip.SetItem(dw_ip.GetRow(),"datet",String(today(),"yyyymmdd"))
dw_ip.SetItem(dw_ip.GetRow(),"gubun",'1')

dw_ip.SetColumn("jz_gbn")
dw_ip.Setfocus()

dw_list.DataObject = "d_kfia04a_1"
dw_list.SetTransObject(SQLCA)

end event

type p_preview from w_standard_print`p_preview within w_kfia04a
end type

type p_exit from w_standard_print`p_exit within w_kfia04a
end type

type p_print from w_standard_print`p_print within w_kfia04a
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia04a
end type







type st_10 from w_standard_print`st_10 within w_kfia04a
end type



type dw_print from w_standard_print`dw_print within w_kfia04a
string dataobject = "d_kfia04a_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia04a
integer x = 5
integer y = 0
integer width = 3026
integer height = 296
string dataobject = "d_kfia04a_0"
end type

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String snull,sgubun,syuga_gu, ls_data

SetNull(snull)
sle_msg.text =""
IF dwo.name ="datef" THEN
	IF f_datechk(data) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datef",snull)
		Return 1
	END IF
END IF

IF dwo.name ="datet" THEN
	IF f_datechk(data) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datet",snull)
		Return 1
	END IF
END IF

IF GetColumnName() ="bnk_gb" THEN
	IF IsNull(data) OR data = "" THEN Return
	IF data <> '1' AND data <> '2' AND data <> '3' THEN
		MessageBox("확  인","보관구분을 확인하십시오!")
		dw_ip.SetColumn("bnk_gb")
		dw_ip.SetFocus()
		Return 1
	END IF
END IF

IF DaysAfter(Date(Left(sdatef,4)+"/"+Mid(sdatef,5,2)+"/"+Right(sdatef,2)),&
				 Date(Left(sdatet,4)+"/"+Mid(sdatet,5,2)+"/"+Right(sdatet,2))) < 0 THEN
	MessageBox("확  인","날짜 범위가 잘못 지정되었습니다. 확인하세요.!!!")
	dw_ip.SetColumn("datet")
	dw_ip.SetFocus()
	Return -1
END IF

IF GetColumnName() ="gubun" THEN
	ls_data = gettext()
	IF ls_data ='2' THEN
		dw_print.DataObject = "d_kfia04a_2_p"
		dw_list.DataObject = "d_kfia04a_2"
	ELSEIF ls_data ='3' THEN
		dw_print.DataObject = "d_kfia04a_3_p"
		dw_list.DataObject = "d_kfia04a_3"
	ELSEIF ls_data ='1' THEN
		dw_print.DataObject = "d_kfia04a_1_p"
		dw_list.DataObject = "d_kfia04a_1"
	END IF
	dw_print.SetTransObject(SQLCA)
   dw_list.SetTransObject(SQLCA)
	dw_print.object.datawindow.print.preview = "yes"
END IF
end event

event dw_ip::rbuttondown;String snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() ="acc1f" OR this.GetColumnName() ="acc2f" THEN
	lstr_account.acc1_cd =dw_ip.GetItemString(1,"acc1f")
	lstr_account.acc2_cd =dw_ip.GetItemString(1,"acc2f")

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
   	lstr_account.acc2_cd = ""
	end if

	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	IF lstr_account.yu_gu = 'Y' OR lstr_account.gbn1 = '7' THEN
		dw_ip.SetItem(1,"acc1f",lstr_account.acc1_cd)
		dw_ip.SetItem(1,"acc2f",lstr_account.acc2_cd)

		dw_ip.SetItem(1,"accf_nm",lstr_account.acc2_nm)
	ELSE
		Messagebox("확 인","유가증권을 조회할 수 없는 계정입니다.!!")
		dw_ip.SetItem(1,"acc1f",snull)
		dw_ip.SetItem(1,"acc2f",snull)
		dw_ip.SetItem(1,"accf_nm",snull)	
	END IF
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia04a
integer y = 312
integer width = 4558
string dataobject = "d_kfia04a_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia04a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 296
integer width = 4608
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type


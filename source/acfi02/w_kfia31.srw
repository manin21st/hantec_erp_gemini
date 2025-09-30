$PBExportHeader$w_kfia31.srw
$PBExportComments$예금장 조회 출력
forward
global type w_kfia31 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia31
end type
end forward

global type w_kfia31 from w_standard_print
integer x = 0
integer y = 0
string title = "예금장 조회 출력"
boolean maxbox = true
rr_1 rr_1
end type
global w_kfia31 w_kfia31

type variables
String sacc1,sacc2,sbnkf,sbnkt,sdatef,sdatet,sgaejnm,sbnknmf,sbnknmt
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_locd, s_tocd, s_fdate, s_tdate

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sabu_f = trim(dw_ip.Getitemstring(1,"saupj"))
s_locd = trim(dw_ip.Getitemstring(1,"kfm04ot0_ab_dpno"))
s_tocd = trim(dw_ip.Getitemstring(1,"to_cd"))

s_fdate = Trim(dw_ip.Getitemstring(1,"ab_fst"))
s_tdate = Trim(dw_ip.Getitemstring(1,"ab_tst"))

if isnull(s_locd) or s_locd = "" then s_locd = '0'
if isnull(s_tocd) or s_tocd = "" then s_tocd = 'zzzzzz'

IF sabu_f = '' OR IsNull(sabu_f) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

if s_locd > s_tocd then
	MessageBOx("확인","예적금번호의 범위를 확인하세요!")
	dw_ip.SetColumn("to_cd")
	dw_ip.setfocus()
	return -1
end if	

IF s_fDate = "" OR IsNull(s_fdate) THEN
	F_MessageChk(1,'[거래기간]')
	dw_ip.SetColumn("ab_fst")
	dw_ip.SetFocus()
	Return -1
END IF

IF s_tDate = "" OR IsNull(s_tdate) THEN
	F_MessageChk(1,'[거래기간]')
	dw_ip.SetColumn("ab_tst")
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_print.Retrieve(sabu_f,sabu_f,s_locd,s_tocd,s_fdate,s_tdate) <=0 THEN
	f_messagechk(14,"")
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_kfia31.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia31.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.getrow(),"saupj", Gs_Saupj)
dw_ip.SetItem(dw_ip.getrow(),"ab_fst",Left(F_Today(),6)+'01')
dw_ip.SetItem(dw_ip.getrow(),"ab_tst",F_today())
dw_ip.SetItem(dw_ip.GetRow(),"gbn",'1')

IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
	//dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
	//dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(190,225,184))+"'")  //MINT COLOR
End if

dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kfia31
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_kfia31
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_kfia31
integer taborder = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia31
integer taborder = 0
end type







type st_10 from w_standard_print`st_10 within w_kfia31
end type



type dw_print from w_standard_print`dw_print within w_kfia31
integer x = 3355
integer y = 40
integer width = 544
integer height = 192
boolean titlebar = true
string dataobject = "d_kfia31_1_p"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ip from w_standard_print`dw_ip within w_kfia31
integer x = 18
integer y = 24
integer width = 3195
integer height = 224
integer taborder = 0
string dataobject = "d_kfia31_0"
end type

event dw_ip::rbuttondown;String snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

IF this.GetColumnName() ="kfm04ot0_ab_dpno" THEN
	gs_code =Trim(dw_ip.GetItemString(dw_IP.GetRow(),"kfm04ot0_ab_dpno"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	OPEN(W_KFM04OT0_POPUP)
	dw_ip.SetItem(1, "kfm04ot0_ab_dpno", gs_code)
	dw_ip.setitem(1, "kfm04ot0_ab_name", gs_codename)
ELSEIF this.GetColumnName() ="to_cd" THEN
	gs_code =Trim(dw_ip.GetItemString(dw_IP.GetRow(),"to_cd"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	OPEN(W_KFM04OT0_POPUP)
	dw_ip.SetItem(1, "to_cd", gs_code)
	dw_ip.setitem(1, "to_nm", gs_codename)
END IF
end event

event dw_ip::itemchanged;string   scode, sname,snull

SetNull(snull)

IF dwo.name = "kfm04ot0_ab_dpno"  THEN

	IF data ="" OR IsNull(data) THEN
		dw_ip.setitem(dw_ip.getrow(), "kfm04ot0_ab_dpno", snull)
		dw_ip.setitem(dw_ip.getrow(), "kfm04ot0_ab_name", snull)
		Return
	END IF
	
	SELECT "KFM04OT0"."AB_NAME"  
   	INTO :SNAME  
    	FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :data ;
   IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확 인","등록된 예적금코드가 아닙니다!!")	
//		dw_ip.setitem(dw_ip.getrow(), "kfm04ot0_ab_dpno", snull)
//		dw_ip.setitem(dw_ip.getrow(), "kfm04ot0_ab_name", snull)
//		Return 1
	ELSE
		dw_ip.setitem(dw_ip.getrow(), "kfm04ot0_ab_name", SNAME) 
	END IF
   
ELSEIF dwo.name = "to_cd" THEN 
	IF data ="" OR IsNull(data) THEN
		dw_ip.setitem(dw_ip.getrow(), "to_cd", snull)
		dw_ip.setitem(dw_ip.getrow(), "to_nm", snull)
		Return
	END IF
	
  	SELECT "KFM04OT0"."AB_NAME"  
   	INTO :SNAME  
    	FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :data ;
	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확 인","등록된 예적금코드가 아닙니다!!")	
//		dw_ip.setitem(dw_ip.getrow(), "to_cd", snull)
//		dw_ip.setitem(dw_ip.getrow(), "to_nm", snull)
//		Return 1
	ELSE
		dw_ip.SetItem(dw_ip.Getrow(), "to_nm", sname)
	END IF
END IF

IF dwo.name ="ab_fst" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF f_datechk(data) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"ab_fst",snull)
		Return 1
	END IF
END IF

IF dwo.name ="ab_tst" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN
	
	IF f_datechk(data) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"ab_tst",snull)
		Return 1
	END IF
END IF

IF dw_ip.Getcolumnname() ="gbn" THEN
	print_gu = this.GetText()

	dw_ip.SetRedraw(False)
	IF print_gu ='2' THEN
		dw_list.DataObject  = "d_kfia31_2"
		dw_print.DataObject = "d_kfia31_2_p"
	ELSEIF print_gu ='1' THEN
		dw_list.DataObject  = "d_kfia31_1"
		dw_print.DataObject = "d_kfia31_1_p"
	END IF
	dw_ip.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
END IF

dw_ip.SetFocus()
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

type dw_list from w_standard_print`dw_list within w_kfia31
integer x = 32
integer y = 256
integer width = 4567
integer height = 1956
integer taborder = 0
string title = "예금장 조회출력(원화)"
string dataobject = "d_kfia31_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia31
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 252
integer width = 4590
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type


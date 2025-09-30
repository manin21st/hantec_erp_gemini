$PBExportHeader$wp_pip5032.srw
$PBExportComments$** 사업소득 지급대장
forward
global type wp_pip5032 from w_standard_print
end type
type dw_1 from datawindow within wp_pip5032
end type
type dw_2 from datawindow within wp_pip5032
end type
type rr_2 from roundrectangle within wp_pip5032
end type
end forward

global type wp_pip5032 from w_standard_print
integer x = 0
integer y = 0
string title = "사업소득 지급대장"
dw_1 dw_1
dw_2 dw_2
rr_2 rr_2
end type
global wp_pip5032 wp_pip5032

type variables

end variables

forward prototypes
public function integer wf_settext ()
public function integer wf_settext2 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_settext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text100.text = '"+sName+"'")
 dw_print.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text101.text = '"+sName+"'")
 dw_print.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text102.text = '"+sName+"'")
 dw_print.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text103.text = '"+sName+"'")
 dw_print.modify("text103.text = '"+sName+"'") 
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text104.text = '"+sName+"'")
 dw_print.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text105.text = '"+sName+"'")
 dw_print.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text106.text = '"+sName+"'")
 dw_print.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text107.text = '"+sName+"'")
 dw_print.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text108.text = '"+sName+"'")
 dw_print.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text109.text = '"+sName+"'")
 dw_print.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text110.text = '"+sName+"'")
 dw_print.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text111.text = '"+sName+"'")
 dw_print.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text112.text = '"+sName+"'")
 dw_print.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text113.text = '"+sName+"'")
 dw_print.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text114.text = '"+sName+"'")
 dw_print.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text115.text = '"+sName+"'")
 dw_print.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text116.text = '"+sName+"'")
 dw_print.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text117.text = '"+sName+"'")
 dw_print.modify("text117.text = '"+sName+"'")
Return 1
end function

public function integer wf_settext2 ();String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text200.text = '"+sName+"'")
 dw_print.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text201.text = '"+sName+"'")
 dw_print.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text202.text = '"+sName+"'")
 dw_print.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text203.text = '"+sName+"'")
 dw_print.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text204.text = '"+sName+"'")
 dw_print.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text205.text = '"+sName+"'")
 dw_print.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text206.text = '"+sName+"'")
 dw_print.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text207.text = '"+sName+"'")
 dw_print.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text208.text = '"+sName+"'")
 dw_print.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text209.text = '"+sName+"'")
 dw_print.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text210.text = '"+sName+"'")
 dw_print.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text211.text = '"+sName+"'")
 dw_print.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text212.text = '"+sName+"'")
 dw_print.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text213.text = '"+sName+"'")
 dw_print.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text214.text = '"+sName+"'")
 dw_print.modify("text214.text = '"+sName+"'")
Return 1
end function

public function integer wf_retrieve ();String sYm,sSaup,ls_gubun,ls_Empno

dw_ip.AcceptText()

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
//ls_gubun = dw_ip.GetITemString(1,"l_gubn")  /*급여,상여구분*/
//ls_Empno = dw_ip.GetITemString(1,"l_empno") 

IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("확인","년월을 확인하세요")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 
IF sSaup = '' OR ISNULL(sSaup) THEN sSaup = '%'

ls_gubun = 'P'

IF ls_Empno = '' OR ISNULL(ls_Empno) THEN
	ls_Empno = '%'
END IF	

IF dw_list.Retrieve(sSaup,sYm,sYm) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
END IF

 Return 1
end function

on wp_pip5032.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_2
end on

on wp_pip5032.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.SetTransObject(Sqlca)
dw_2.SetTransObject(Sqlca)

dw_ip.SetITem(1,"l_ym",Left(f_today(),6))

f_set_saupcd(dw_ip,'l_saup','1')
is_saupcd = gs_saupcd
end event

type p_preview from w_standard_print`p_preview within wp_pip5032
end type

type p_exit from w_standard_print`p_exit within wp_pip5032
end type

type p_print from w_standard_print`p_print within wp_pip5032
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip5032
end type

type st_window from w_standard_print`st_window within wp_pip5032
integer x = 2418
integer y = 2960
end type

type sle_msg from w_standard_print`sle_msg within wp_pip5032
integer x = 439
integer y = 2972
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip5032
integer x = 2907
integer y = 2972
end type

type st_10 from w_standard_print`st_10 within wp_pip5032
integer x = 78
integer y = 2972
end type

type gb_10 from w_standard_print`gb_10 within wp_pip5032
integer x = 64
integer y = 2920
end type

type dw_print from w_standard_print`dw_print within wp_pip5032
string dataobject = "dp_pip5032_2_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip5032
integer x = 471
integer y = 52
integer width = 1819
integer height = 180
string dataobject = "dp_pip5032_1"
end type

event dw_ip::itemchanged;String  SaupCode,sCode,snull

SetNull(snull)

This.AcceptText()

IF dw_ip.GetColumnName() = "l_saup" THEN
   is_saupcd = dw_ip.GetText()
	if is_saupcd = '' or isnull(is_saupcd) then is_saupcd = '%'
//	IF SaupCode = '' OR ISNULL(SaupCode) THEN RETURN
//    SELECT "P0_SAUPCD"."SAUPCODE"  
//     INTO :sCode  
//     FROM  "P0_SAUPCD" 
//	  WHERE "P0_SAUPCD"."SAUPCODE" =:SaupCode ;
//	  IF ISNULL(sCode) OR sCode = '' THEN
//		  MessageBox("확인","사업장코드를  확인하세요")
//		  dw_ip.SetItem(1,"l_saup",snull)
//		  Return 1
//	  END IF
END IF	
end event

event dw_ip::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp_pip5032
integer x = 480
integer y = 264
integer width = 3662
integer height = 1992
string dataobject = "dp_pip5032_2"
boolean border = false
end type

type dw_1 from datawindow within wp_pip5032
integer x = 585
integer y = 2784
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(지급)"
string dataobject = "dp_hsp3010_3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within wp_pip5032
integer x = 1536
integer y = 2784
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(공제)"
string dataobject = "dp_hsp3010_4"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_2 from roundrectangle within wp_pip5032
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 466
integer y = 252
integer width = 3694
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type


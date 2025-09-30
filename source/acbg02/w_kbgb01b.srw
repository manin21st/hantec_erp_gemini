$PBExportHeader$w_kbgb01b.srw
$PBExportComments$조정예산 신청조회(승인등록시사용:조회용)
forward
global type w_kbgb01b from window
end type
type p_exit from uo_picture within w_kbgb01b
end type
type st_2 from statictext within w_kbgb01b
end type
type sle_msg from singlelineedit within w_kbgb01b
end type
type dw_datetime from datawindow within w_kbgb01b
end type
type st_1 from statictext within w_kbgb01b
end type
type dw_ret1 from datawindow within w_kbgb01b
end type
type dw_ret2 from datawindow within w_kbgb01b
end type
type dw_ip from datawindow within w_kbgb01b
end type
type gb_3 from groupbox within w_kbgb01b
end type
type gb_10 from groupbox within w_kbgb01b
end type
end forward

shared variables

end variables

global type w_kbgb01b from window
integer x = 59
integer y = 124
integer width = 3698
integer height = 2256
boolean titlebar = true
string title = "예산조정 신청 조회"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_exit p_exit
st_2 st_2
sle_msg sle_msg
dw_datetime dw_datetime
st_1 st_1
dw_ret1 dw_ret1
dw_ret2 dw_ret2
dw_ip dw_ip
gb_3 gb_3
gb_10 gb_10
end type
global w_kbgb01b w_kbgb01b

type variables
string is_saupj, is_exe_ymd, is_exe_gu
double idb_exe_amt
long il_exe_no
Boolean ib_any_typing
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public function integer wf_get_remain (string smonth, string sacc1, string sacc2, string scdept, ref double dremain)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

public function integer wf_get_remain (string smonth, string sacc1, string sacc2, string scdept, ref double dremain);/*예산마스타 잔액검사		*/
/* 예산 잔액 = 기본금액 + 전월이월 - 차월이월 + 조기집행 + 전용 + 추가 - 집행 - 가집행		*/
String sSaupj,sYear,sExeGbn

dw_ip.AcceptText()
sSaupj  = dw_ip.GetItemString(1,"saupj")
sYear   = Left(dw_ip.GetItemString(1,"exe_ymd"),4)
sExeGbn = dw_ip.GetItemString(1,"exe_gu")

IF sSaupj = "" OR IsNull(sSaupj) THEN 
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -2
END IF

IF sYear = "" OR IsNull(sYear) THEN 
	F_MessageChk(1,'[조정처리일자]')
	dw_ip.SetColumn("exc_ymd")
	dw_ip.SetFocus()
	Return -2
END IF

IF sMonth = "" OR IsNull(sMonth) THEN Return 2
IF sAcc1 = "" OR IsNull(sAcc1) THEN Return 2
IF sAcc2 = "" OR IsNull(sAcc2) THEN Return 2
IF sCdept = "" OR IsNull(sCdept) THEN Return 2

SELECT ( NVL("KFE01OM0"."BGK_AMT1",0) + 
			NVL("KFE01OM0"."BGK_AMT2",0) - 
			NVL("KFE01OM0"."BGK_AMT3",0) + 
			NVL("KFE01OM0"."BGK_AMT4",0) + 
			NVL("KFE01OM0"."BGK_AMT5",0) + 
			NVL("KFE01OM0"."BGK_AMT6",0) - 
			NVL("KFE01OM0"."BGK_AMT7",0) - 
			NVL("KFE01OM0"."BGK_AMT8",0) )  
	INTO :dRemain
	FROM "KFE01OM0"  
	WHERE ( "KFE01OM0"."SAUPJ" = :sSaupj ) AND ( "KFE01OM0"."ACC_YY" = :sYear ) AND  
			( "KFE01OM0"."ACC_MM" = :sMonth ) AND ( "KFE01OM0"."DEPT_CD" = :sCdept ) AND  
			( "KFE01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFE01OM0"."ACC2_CD" = :sAcc2 ) ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(20,'[예산배정자료')
	Return -1
ELSE
	IF sExeGbn <> '50' THEN
		IF IsNull(dRemain) OR dRemain = 0 THEN
			F_MessageChk(20,'[예산잔액')
			Return -1
		END IF
	END IF
END IF

Return 1
end function

event open;string ls_tot, ls_acc1_cd, ls_acc2_cd, sqlfd, sqlfd2, &
       sqlfd3, sqlfd4, ls_acc1_cd1, ls_acc2_cd1,   &
       ls_saupj, ls_exe_ymd, ls_exe_gu
		 
long rowno1, rowno2, ll_exe_no

dw_ip.SetTransObject(sqlca)
dw_ret1.SetTransObject(sqlca)
dw_ret2.SetTransObject(sqlca)

dw_ip.Reset()

dw_ret1.Reset()
dw_ret2.Reset()

sle_msg.text = ""

f_window_center_response(this)

ls_tot = Message.StringParm

ls_saupj = left(ls_tot, 2)
ls_exe_ymd = mid(ls_tot, 3, 8)
ls_exe_gu = mid(ls_tot, 11, 2)   
ll_exe_no = long(mid(ls_tot, 13, 4))  

if dw_ip.Retrieve(ls_saupj, ls_exe_ymd, ll_exe_no) < 1 then 
	close(this)
	halt
	return 
else
	if ls_exe_gu <> "50" then
   	rowno1 = dw_ret1.Retrieve(ls_saupj,ls_exe_ymd,ll_exe_no,"1")
      rowno2 = dw_ret2.Retrieve(ls_saupj,ls_exe_ymd,ll_exe_no,"2")

      ls_acc1_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc1_cd")  
      ls_acc2_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc2_cd")  
		
      ls_acc1_cd1  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc1_cd")  
      ls_acc2_cd1  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc2_cd")  
		
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      	INTO :sqlfd, :sqlfd2
      	FROM "KFZ01OM0"  
      	WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
         	   ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname",Trim(sqlfd) + " - " + Trim(sqlfd2))
      else
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname"," ")
      end if
		
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      INTO :sqlfd3, :sqlfd4
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd1 ) AND  
            ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd1 )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret2.Setitem(dw_ret2.Getrow(),"accname",Trim(sqlfd3) + " - " + Trim(sqlfd4))
      else
         dw_ret2.Setitem(dw_ret2.Getrow(),"accname"," ")
      end if
	else
      rowno1 = dw_ret1.Retrieve(ls_saupj,ls_exe_ymd,ll_exe_no,"1")   
		
      ls_acc1_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc1_cd")  
      ls_acc2_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc2_cd")  
		
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      	INTO :sqlfd, :sqlfd2
      	FROM "KFZ01OM0"  
      	WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
         	   ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname",Trim(sqlfd) + " - " + Trim(sqlfd2))
      else
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname"," ")
      end if

      dw_ret2.visible = False		
		
	end if
end if

end event

on w_kbgb01b.create
this.p_exit=create p_exit
this.st_2=create st_2
this.sle_msg=create sle_msg
this.dw_datetime=create dw_datetime
this.st_1=create st_1
this.dw_ret1=create dw_ret1
this.dw_ret2=create dw_ret2
this.dw_ip=create dw_ip
this.gb_3=create gb_3
this.gb_10=create gb_10
this.Control[]={this.p_exit,&
this.st_2,&
this.sle_msg,&
this.dw_datetime,&
this.st_1,&
this.dw_ret1,&
this.dw_ret2,&
this.dw_ip,&
this.gb_3,&
this.gb_10}
end on

on w_kbgb01b.destroy
destroy(this.p_exit)
destroy(this.st_2)
destroy(this.sle_msg)
destroy(this.dw_datetime)
destroy(this.st_1)
destroy(this.dw_ret1)
destroy(this.dw_ret2)
destroy(this.dw_ip)
destroy(this.gb_3)
destroy(this.gb_10)
end on

event closequery;lstr_jpra.flag =True

end event

type p_exit from uo_picture within w_kbgb01b
integer x = 3419
integer width = 178
integer taborder = 1
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type st_2 from statictext within w_kbgb01b
integer x = 41
integer y = 1132
integer width = 434
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[조정 상세]"
boolean focusrectangle = false
end type

type sle_msg from singlelineedit within w_kbgb01b
boolean visible = false
integer x = 393
integer y = 2120
integer width = 2469
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type dw_datetime from datawindow within w_kbgb01b
boolean visible = false
integer x = 2862
integer y = 2120
integer width = 750
integer height = 88
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_kbgb01b
boolean visible = false
integer x = 32
integer y = 2120
integer width = 361
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_ret1 from datawindow within w_kbgb01b
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 59
integer y = 1196
integer width = 1755
integer height = 824
string dataobject = "dw_kbgb01b_2"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;/* 예산마스타를 검색하여 조정전,후의 예산잔액을 표시하여줌 */

String  sCdept, sAcc1, sAcc2, sMonth,sAccName,sNull
Double  dAmount = 0,dRemain
Integer iValue

SetNull(snull)

dw_ip.AcceptText()
dAmount = dw_ip.GetItemNumber(1,"exe_amt")
IF IsNull(dAmount) THEN dAmount = 0

IF this.GetColumnName() = 'dept_cd' then
	sCdept = this.GetText()
	IF sCdept = "" OR IsNull(sCdept) THEN Return
	
	SELECT DISTINCT "KFE01OM0"."DEPT_CD"  	INTO :sCdept
		FROM "KFE01OM0"  
		WHERE "KFE01OM0"."DEPT_CD" = :sCdept ;

	If sqlca.sqlcode <> 0 then 	
	   F_MessageChk(20,'[예산부서]')						
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		return 1
	end if 
	
	iValue = Wf_Get_Remain(this.GetItemString(this.GetRow(),"acc_mm"),&
						  this.GetItemString(this.GetRow(),"acc1_cd"),&	
						  this.GetItemString(this.GetRow(),"acc2_cd"),&
						  sCdept,dRemain)
						  
	IF iValue < 1 THEN
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain + dAmount)
	END IF
END IF

if this.GetColumnName() = 'acc1_cd' then 
	sAcc1 = this.GetText()
	IF sAcc1 ="" OR IsNull(sAcc1) THEN Return
	
	sAcc2 = this.GetItemString(this.GetRow(), 'acc2_cd')
	IF sAcc2 ="" OR IsNull(sAcc2) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"	INTO :sAccName  		/*계정과목명 표시*/
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) AND
				( "KFZ01OM0"."YESAN_GU" = 'Y' OR "KFZ01OM0"."YESAN_GU" = 'A') ;
	if sqlca.sqlcode = 0 then
	  this.Setitem(this.Getrow(),"accname",sAccName)
	else
		F_MessageChk(25,'')
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
	  	Return 1
	end if
	
	iValue = Wf_Get_Remain(this.GetItemString(this.GetRow(),"acc_mm"),&
						  sAcc1,sAcc2,&
						  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain + dAmount)
	END IF
	
end if

if this.GetColumnName() = 'acc2_cd' then 
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return
	
	sAcc1 = this.GetItemString(this.GetRow(), 'acc1_cd')
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"	INTO :sAccName  		/*계정과목명 표시*/
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) AND
				( "KFZ01OM0"."YESAN_GU" = 'Y' OR "KFZ01OM0"."YESAN_GU" = 'A') ;
	if sqlca.sqlcode = 0 then
	  this.Setitem(this.Getrow(),"accname",sAccName)
	else
		F_MessageChk(25,'')
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
	  	Return 1
	end if
	iValue = Wf_Get_Remain(this.GetItemString(this.GetRow(),"acc_mm"),&
						  sAcc1,sAcc2,&
						  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain + dAmount)
	END IF
end if

if this.GetColumnName() = 'acc_mm' then 
	sMonth = this.GetText()
	IF sMonth = "" OR IsNull(sMonth) THEN Return
	
	IF Integer(sMonth) < 1 OR Integer(sMonth) > 12 THEN
		this.SetItem(this.Getrow(),"acc_mm",snull)
	  	Return 1
	ELSE
		this.SetItem(this.GetRow(),"acc_mm",String(Integer(sMonth),'00'))
	END IF

	iValue = Wf_Get_Remain(sMonth,&
								  this.GetItemString(this.GetRow(),"acc1_cd"),&
								  this.GetItemString(this.GetRow(),"acc2_cd"),&
								  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc_mm", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain + dAmount)
	END IF

end if


end event

event rbuttondown;String ls_gj1, ls_gj2

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "acc1_cd" or  this.GetColumnName() = "acc2_cd" THEN 

	gs_code = Trim(this.GetItemString(this.GetRow(), "acc1_cd"))
	
	IF IsNull(gs_code) then
		gs_code =""
	end if
	
	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
		dw_ret1.SetItem(dw_ret1.GetRow(), "acc1_cd", Left(gs_code,5))
		dw_ret1.SetItem(dw_ret1.GetRow(), "acc2_cd", Mid(gs_code,6,2))
		dw_ret1.SetItem(dw_ret1.GetRow(), "accname", gs_codename)
	end if
	this.TriggerEvent(ItemChanged!)

end if

end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type dw_ret2 from datawindow within w_kbgb01b
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1888
integer y = 1200
integer width = 1760
integer height = 820
string dataobject = "dw_kbgb01b_3"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;/* 예산마스타를 검색하여 조정전,후의 예산잔액을 표시하여줌 */

String  sCdept, sAcc1, sAcc2, sMonth,sAccName,sNull
Double  dAmount = 0,dRemain
Integer iValue

SetNull(snull)

dw_ip.AcceptText()
dAmount = dw_ip.GetItemNumber(1,"exe_amt")
IF IsNull(dAmount) THEN dAmount = 0

IF this.GetColumnName() = 'dept_cd' then
	sCdept = this.GetText()
	IF sCdept = "" OR IsNull(sCdept) THEN Return
	
	SELECT DISTINCT "KFE01OM0"."DEPT_CD"  	INTO :sCdept
		FROM "KFE01OM0"  
		WHERE "KFE01OM0"."DEPT_CD" = :sCdept ;

	If sqlca.sqlcode <> 0 then 	
	   F_MessageChk(20,'[예산부서]')						
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		return 1
	end if 
	
	iValue = Wf_Get_Remain(this.GetItemString(this.GetRow(),"acc_mm"),&
						  this.GetItemString(this.GetRow(),"acc1_cd"),&	
						  this.GetItemString(this.GetRow(),"acc2_cd"),&
						  sCdept,dRemain)
						  
	IF iValue < 1 THEN
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain - dAmount)
	END IF
END IF

if this.GetColumnName() = 'acc1_cd' then 
	sAcc1 = this.GetText()
	IF sAcc1 ="" OR IsNull(sAcc1) THEN Return
	
	sAcc2 = this.GetItemString(this.GetRow(), 'acc2_cd')
	IF sAcc2 ="" OR IsNull(sAcc2) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"	INTO :sAccName  		/*계정과목명 표시*/
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) AND
				( "KFZ01OM0"."YESAN_GU" = 'Y' OR "KFZ01OM0"."YESAN_GU" = 'A') ;
	if sqlca.sqlcode = 0 then
	  this.Setitem(this.Getrow(),"accname",sAccName)
	else
		F_MessageChk(25,'')
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
	  	Return 1
	end if
	
	iValue = Wf_Get_Remain(this.GetItemString(this.GetRow(),"acc_mm"),&
						  sAcc1,sAcc2,&
						  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain - dAmount)
	END IF
	
end if

if this.GetColumnName() = 'acc2_cd' then 
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return
	
	sAcc1 = this.GetItemString(this.GetRow(), 'acc1_cd')
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"	INTO :sAccName  		/*계정과목명 표시*/
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) AND
				( "KFZ01OM0"."YESAN_GU" = 'Y' OR "KFZ01OM0"."YESAN_GU" = 'A') ;
	if sqlca.sqlcode = 0 then
	  this.Setitem(this.Getrow(),"accname",sAccName)
	else
		F_MessageChk(25,'')
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
	  	Return 1
	end if
	iValue = Wf_Get_Remain(this.GetItemString(this.GetRow(),"acc_mm"),&
						  sAcc1,sAcc2,&
						  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain - dAmount)
	END IF
end if

if this.GetColumnName() = 'acc_mm' then 
	sMonth = this.GetText()
	IF sMonth = "" OR IsNull(sMonth) THEN Return
	
	IF Integer(sMonth) < 1 OR Integer(sMonth) > 12 THEN
		this.SetItem(this.Getrow(),"acc_mm",snull)
	  	Return 1
	ELSE
		this.SetItem(this.GetRow(),"acc_mm",String(Integer(sMonth),'00'))
	END IF

	iValue = Wf_Get_Remain(sMonth,&
								  this.GetItemString(this.GetRow(),"acc1_cd"),&
								  this.GetItemString(this.GetRow(),"acc2_cd"),&
								  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc_mm", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain - dAmount)
	END IF

end if


end event

event rbuttondown;String ls_gj1, ls_gj2

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "acc1_cd" or this.GetColumnName() <> "acc2_cd" THEN 

	this.AcceptText()
	gs_code = Trim(dw_ret2.GetItemString(dw_ret2.GetRow(), "acc1_cd"))
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
		dw_ret2.SetItem(dw_ret2.GetRow(), "acc1_cd", Left(gs_code,5))
		dw_ret2.SetItem(dw_ret2.GetRow(), "acc2_cd", Mid(gs_code,6,2))
		dw_ret2.SetItem(dw_ret2.GetRow(), "accname", gs_codename)
	end if
	
end if

end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type dw_ip from datawindow within w_kbgb01b
event ue_pressenter pbm_dwnprocessenter
integer x = 32
integer y = 144
integer width = 3602
integer height = 964
string dataobject = "dw_kbgb01b_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;if this.GetColumnName() = 'exe_desc' or this.GetColumnName() = 'exe_desc2' then return 

Send(Handle(this),256,9,0)

Return 1
end event

event itemchanged;string snull, sqlfd

SetNull(snull)

// 사업장
if this.GetColumnName() = 'saupj' then 
   is_saupj    = this.GetText()
	
	if trim(is_saupj) = '' or isnull(is_saupj) then 
      F_MessageChk(1, "[사업장]")		
		return 1
	end if
	
	SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AD' and
         "REFFPF"."RFGUB" = :is_saupj and 
			"REFFPF"."RFGUB" <> '00'	;
   if sqlca.sqlcode <> 0 then
      F_MessageChk(20, "[사업장]")		
      this.SetItem(row, "saupj", snull)
      return 1
   end if
	
end if


if this.GetColumnName() = 'exe_ymd' then 
	is_exe_ymd = this.GetText()
	
	if trim(is_exe_ymd) = '' or isnull(is_exe_ymd) then 
      F_MessageChk(1, "[조정일자]")				
		return 1
   elseif f_datechk(is_exe_ymd) = -1 then
      F_MessageChk(1, "[조정일자]")				
		return 1
   end if		
	
end if

if this.GetColumnName() = 'exe_gu' then 
	
   is_exe_gu   = this.GetText()
	
	if trim(is_exe_gu) = '' or isnull(is_exe_gu) then 
		return 
	else
		SELECT "REFFPF"."RFGUB"  
		INTO :sqlfd
		FROM "REFFPF"
		WHERE "REFFPF"."RFCOD" = 'AE' and
				"REFFPF"."RFGUB" = :is_exe_gu and  
				"REFFPF"."RFGUB" <> '00';
		if sqlca.sqlcode <> 0 then
			F_MessageChk(20, "[예산조정구분]")		
			dw_ip.SetItem(row, 'exe_gu', snull)
			return 1
		end if
	end if
	
	if is_exe_gu = "50" then  //추가조정//
		dw_ret2.visible = False
	else
		dw_ret2.visible = True
	end if
end if

if this.GetColumnName() = 'exe_amt' then 
	idb_exe_amt = long(this.GetText())
	
	if string(idb_exe_amt) = '' or isnull(idb_exe_amt) then 
      F_MessageChk(1, "[조정금액]")						
		return 1
   end if
end if

il_exe_no   = dw_ip.GetitemNumber(dw_ip.Getrow(),"exe_no")



end event

event itemerror;return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="exe_desc" OR dwo.name ="exe_desc2" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event getfocus;this.AcceptText()
end event

type gb_3 from groupbox within w_kbgb01b
boolean visible = false
integer x = 14
integer y = 2084
integer width = 3607
integer height = 136
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_10 from groupbox within w_kbgb01b
boolean visible = false
integer x = 14
integer y = 2068
integer width = 3607
integer height = 152
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
end type


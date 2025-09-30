$PBExportHeader$w_imt_t_10110.srw
$PBExportComments$**  발주서
forward
global type w_imt_t_10110 from w_standard_print
end type
type pb_2 from u_pb_cal within w_imt_t_10110
end type
type rr_1 from roundrectangle within w_imt_t_10110
end type
end forward

global type w_imt_t_10110 from w_standard_print
string title = "발주서"
boolean maxbox = true
pb_2 pb_2
rr_1 rr_1
end type
global w_imt_t_10110 w_imt_t_10110

type variables
String is_nadat
String is_printgu = 'Y'
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_plncrt_check ()
end prototypes

public function integer wf_retrieve ();string ls_porgu, ls_nadat, ls_nadatm, ls_nadat2, ls_cvcod1, ls_cvcod2, ls_empno, ls_plncrt, ls_baljpno

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_porgu    = trim(dw_ip.object.porgu[1])
ls_nadat    = trim(dw_ip.object.nadat[1])
ls_nadatm   = trim(dw_ip.object.nadatm[1])
ls_nadat2   = trim(dw_ip.object.nadat[1])
ls_cvcod1   = trim(dw_ip.object.cvcod1[1])
ls_cvcod2   = trim(dw_ip.object.cvcod2[1])
ls_empno    = trim(dw_ip.object.empno[1])
ls_plncrt   = trim(dw_ip.object.plncrt[1])
ls_baljpno  = trim(dw_ip.object.baljpno[1])


if (IsNull(ls_porgu) or ls_porgu 		= "") then ls_porgu = "%"
if (IsNull(ls_cvcod1) or ls_cvcod1		= "") then ls_cvcod1 = "."
if (IsNull(ls_cvcod2) or ls_cvcod2		= "") then ls_cvcod2 = "ZZZ"
if (IsNull(ls_empno) or ls_empno			= "") then ls_empno = "%"
if (IsNull(ls_baljpno) or ls_baljpno	= "") then ls_baljpno = "%"

if IsNull(ls_nadat) or ls_nadat = "" then 
	f_message_chk(30,'[ 기준일 ]')
	return -1
End If

if IsNull(ls_nadatm) or ls_nadatm = "" then 
	f_message_chk(30,'[ 기준년월 ]')
	return -1
End If

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

If ls_plncrt = '1' Then
	if dw_print.Retrieve(gs_sabu, ls_nadatm,ls_porgu,ls_cvcod1,ls_cvcod2, ls_empno, ls_plncrt, ls_baljpno) <= 0 then
		f_message_chk(50,'[ 발주서 ]')
		dw_ip.Setfocus()
		return -1
	End If

Else
	if dw_print.Retrieve(gs_sabu, ls_nadat,ls_porgu,ls_cvcod1,ls_cvcod2, ls_empno, ls_plncrt, ls_baljpno  ) <= 0 then
		f_message_chk(50,'[ 발주서 ]')
		dw_ip.Setfocus()
		return -1
	End If
	
	dw_list.Object.t_100.text =  dw_print.getItemString(1,'compute_50')
	dw_list.Object.t_101.text =  dw_print.getItemString(1,'compute_51')
	dw_list.Object.t_102.text =  dw_print.getItemString(1,'compute_52')
	dw_list.Object.t_103.text =  dw_print.getItemString(1,'compute_53')
	dw_list.Object.t_104.text =  dw_print.getItemString(1,'compute_54')
	dw_list.Object.t_105.text =  dw_print.getItemString(1,'compute_55')
	dw_list.Object.t_106.text =  dw_print.getItemString(1,'compute_12')
	
end if

dw_print.ShareData(dw_list)

If ls_plncrt = '2' Then
	dw_print.Object.t_10.text = '('+Mid(ls_nadat2,5,2)+'월 주간)발주서'
ElseIf ls_plncrt = '3' Then
	dw_print.Object.t_10.text = '('+Mid(ls_nadat2,5,2)+'월 수시)발주서'
ElseIf ls_plncrt = '4' Then
	dw_print.Object.t_10.text = '('+Mid(ls_nadat2,5,2)+'월 자동)발주서'
End If

return 1
end function

public function integer wf_plncrt_check ();	String ls_plncrt
	
	ls_plncrt = dw_ip.GetItemString(1, 'plncrt')
	
	If ls_plncrt = '1' Then
		dw_list.DataObject = 'd_imt_t_10110_d_1'
		dw_print.DataObject = 'd_imt_t_10110_p_1'
		dw_ip.Object.t_3.text  = '기준년월'
		dw_ip.Object.nadatm.visible = True
		dw_ip.Object.nadat.visible  = False
//		dw_ip.Object.nadat2.visible = False
//		dw_ip.Object.t_5.visible  = False
	Else
		dw_list.DataObject = 'd_imt_t_10110_d_2'
		dw_print.DataObject = 'd_imt_t_10110_p_2'
//		this.Object.t_5.visible  = True
//		this.Object.t_6.visible  = True
		dw_ip.Object.t_3.text  = '기준입고일'
		dw_ip.Object.nadat.visible  = True
		dw_ip.Object.nadatm.visible = False
//		dw_ip.Object.nadat2.visible = True
//		dw_ip.Object.t_5.visible  = True
	End If

return 1
end function

on w_imt_t_10110.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_imt_t_10110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF

/* User별 사업장 Setting */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'porgu', gs_code)
	if gs_code <> '%' then
      dw_ip.Modify("porgu.protect=1")
		dw_ip.Modify("porgu.background.color = 80859087")
	End if
End If

dw_ip.SetItem(1,'plncrt','1' )

dw_ip.SetItem(1,'nadat',f_today())
dw_ip.SetItem(1,'nadatm',Left(f_today(),6) )
//dw_ip.SetItem(1,'nadat2', f_today())


dw_print.object.datawindow.print.preview = "yes"	

//dw_print.ShareData(dw_list)
//dw_ip.SetItem(1,'nadat',f_today())
end event

type p_preview from w_standard_print`p_preview within w_imt_t_10110
end type

type p_exit from w_standard_print`p_exit within w_imt_t_10110
end type

type p_print from w_standard_print`p_print within w_imt_t_10110
end type

event p_print::clicked;call super::clicked;long k, lCount

//출력시 y로 변경
if is_printgu  = 'Y' then 

	lCount = dw_list.rowcount()
	
	if lCount < 1  then return 
	
	FOR k = 1 TO lCount
		dw_print.setitem(k, 'pomast_printgu', 'Y')
	NEXT
	
	if dw_print.update() = 1 then
		commit ;
	else
		rollback ;
	end if	

   is_printgu  = 'N'
end if
end event

type p_retrieve from w_standard_print`p_retrieve within w_imt_t_10110
end type







type st_10 from w_standard_print`st_10 within w_imt_t_10110
end type



type dw_print from w_standard_print`dw_print within w_imt_t_10110
integer x = 4014
integer y = 184
string dataobject = "d_imt_t_10110_p_1"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_t_10110
integer x = 37
integer y = 24
integer width = 3854
integer height = 260
string dataobject = "d_imt_t_10110_h"
end type

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,snull,sDateFrom, &
        ls_baljpno, ls_baldate, ls_plncrt, ls_cvcod, ls_cvnas, ls_nadat

If GetColumnName() = "baljpno" Then
	sIoCust = this.GetText()
	IF sIoCust ="" OR IsNull(sIoCust) THEN
		this.SetItem(1,"baljpno",snull)
		Return
	END IF
	
	SELECT POMAST.baljpno, POMAST.cvcod, fun_get_cvnas(POMAST.cvcod), POMAST.PLNCRT, MIN(POBLKT.NADAT)
	INTO :ls_baljpno, :sIoCust, :sIoCustName, :ls_plncrt, :ls_nadat
	FROM POMAST, POBLKT
   WHERE POMAST.BALJPNO = :sIoCust
	And	POMAST.SABU = POBLKT.SABU
	AND   POMAST.BALJPNO = POBLKT.BALJPNO
	Group By POMAST.baljpno, POMAST.cvcod, POMAST.PLNCRT;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인", "존재하지 않는 발주번호입니다.")
		this.SetFocus()
		this.SetColumn("baljpno")
		this.SetItem(1,"baljpno",  "")
		Return 2
	ELSE
		this.SetItem(1,"baljpno",  ls_baljpno)
		this.SetItem(1,"cvcod1",  sIoCust)
		this.SetItem(1,"cvnas1",  sIoCustName)
		this.SetItem(1,"cvcod2",  sIoCust)
		this.SetItem(1,"cvnas2",  sIoCustName)
		this.SetItem(1,"plncrt",  ls_plncrt)
		
		If ls_plncrt = '1' Then
			this.SetItem(1,"nadatm", left(ls_nadat,6))
		Else
			this.SetItem(1,"nadat",  ls_nadat)
		End If
		
	END IF

	wf_plncrt_check()

ElseIf this.getcolumnname() = 'cvcod1' then 
	
	ls_cvcod = this.getText()

	Select cvnas2
	Into :ls_cvnas
	From vndmst
	Where cvcod = :ls_cvcod;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인", "거래처 코드를 확인하십시요.")
		this.SetFocus()
		this.SetColumn("cvcod1")
		this.SetItem(1,"cvcod1",  "")
		//this.TriggerEvent(RbuttonDown!)
		Return 2
	ELSE
		this.setitem(1,"cvcod1", ls_cvcod)		
   	this.setitem(1,"cvnas1", ls_cvnas)
	END IF

elseif this.getcolumnname() = 'cvcod2' then   
	ls_cvcod = this.getText()

	Select cvnas2
	Into :ls_cvnas
	From vndmst
	Where cvcod = :ls_cvcod;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인", "거래처 코드를 확인하십시요.")
		this.SetFocus()
		this.SetColumn("cvcod1")
		this.SetItem(1,"cvcod1",  "")
		//this.TriggerEvent(RbuttonDown!)
		Return 2
	ELSE
		this.setitem(1,"cvcod2", ls_cvcod)		
   	this.setitem(1,"cvnas2", ls_cvnas)
	END IF

ElseIf this.getColumnName() = 'plncrt' then
	ls_plncrt = this.getText()

	If ls_plncrt = '1' Then
		dw_list.DataObject = 'd_imt_t_10110_d_1'
		dw_print.DataObject = 'd_imt_t_10110_p_1'
		this.Object.t_3.text  = '기준년월'
		this.Object.nadatm.visible = True
		this.Object.nadat.visible  = False
	Else
		dw_list.DataObject = 'd_imt_t_10110_d_2'
		dw_print.DataObject = 'd_imt_t_10110_p_2'
		this.Object.t_3.text  = '기준입고일'
		this.Object.nadat.visible  = True
		this.Object.nadatm.visible = False
	End If

END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
	
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnas1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)

	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnas2", gs_codename)

ElseIf this.GetColumnName() = "baljpno" then
	//기존 발주서에서 호출하는 POPUp으로 수정함.
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	open(w_poblkt_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.setitem(1, "baljpno", left(gs_code, 12))
	this.triggerevent(itemchanged!)
	
//	open(w_pomast_popup)
//	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
//	this.object.baljpno[1] = gs_code
//	this.TriggerEvent(ItemChanged!)
end if
end event

type dw_list from w_standard_print`dw_list within w_imt_t_10110
integer x = 46
integer y = 320
integer width = 4549
integer height = 1972
string dataobject = "d_imt_t_10110_d_1"
boolean border = false
end type

event dw_list::printend;call super::printend;is_printgu  = 'Y'
end event

type pb_2 from u_pb_cal within w_imt_t_10110
integer x = 1797
integer y = 48
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('nadatm')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'nadat', gs_code)



end event

type rr_1 from roundrectangle within w_imt_t_10110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 316
integer width = 4571
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type


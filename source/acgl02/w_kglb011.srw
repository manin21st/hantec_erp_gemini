$PBExportHeader$w_kglb011.srw
$PBExportComments$미승인전표 조회
forward
global type w_kglb011 from window
end type
type cb_c from commandbutton within w_kglb011
end type
type cb_v from commandbutton within w_kglb011
end type
type cb_w from commandbutton within w_kglb011
end type
type cb_d from commandbutton within w_kglb011
end type
type cb_q from commandbutton within w_kglb011
end type
type p_del from uo_picture within w_kglb011
end type
type p_end from uo_picture within w_kglb011
end type
type p_can from uo_picture within w_kglb011
end type
type p_print from uo_picture within w_kglb011
end type
type p_inq from uo_picture within w_kglb011
end type
type dw_daeche from datawindow within w_kglb011
end type
type dw_daechelst from datawindow within w_kglb011
end type
type dw_delete from datawindow within w_kglb011
end type
type dw_2 from u_d_select_sort within w_kglb011
end type
type dw_print from datawindow within w_kglb011
end type
type dw_cond from datawindow within w_kglb011
end type
type rr_1 from roundrectangle within w_kglb011
end type
end forward

global type w_kglb011 from window
integer x = 73
integer y = 36
integer width = 4206
integer height = 2304
boolean titlebar = true
string title = "미승인 전표 조회"
windowtype windowtype = response!
long backcolor = 32106727
cb_c cb_c
cb_v cb_v
cb_w cb_w
cb_d cb_d
cb_q cb_q
p_del p_del
p_end p_end
p_can p_can
p_print p_print
p_inq p_inq
dw_daeche dw_daeche
dw_daechelst dw_daechelst
dw_delete dw_delete
dw_2 dw_2
dw_print dw_print
dw_cond dw_cond
rr_1 rr_1
end type
global w_kglb011 w_kglb011

type variables
String sAuctive_Upmu
end variables

forward prototypes
public function integer wf_junpoy_chk (string ssaupj, string sbaldate, string supmugu, integer ljunno)
public function integer wf_control_ds_junpoy (string sflag, integer il_currentrow, integer ifrcnt, integer itocnt)
end prototypes

public function integer wf_junpoy_chk (string ssaupj, string sbaldate, string supmugu, integer ljunno);
String sFinanceChk, sAccountChk 

SELECT "KFZ12OT3"."FINANCE_TRANS",   "KFZ12OT3"."ACCOUNT_TRANS"  
	INTO :sFinanceChk,   				 :sAccountChk  
   FROM "KFZ12OT3"  
   WHERE ( "KFZ12OT3"."SAUPJ" = :sSaupj ) AND  ( "KFZ12OT3"."BAL_DATE" = :sbaldate ) AND  
         ( "KFZ12OT3"."UPMU_GU" = :supmugu ) AND ( "KFZ12OT3"."JUN_NO" = :ljunno )   ;
CHOOSE CASE SQLCA.SQLCODE
	CASE 0
		IF IsNull(sFinanceChk) THEN sFinanceChk = 'N'
		IF IsNull(sAccountChk) THEN sAccountChk = 'N'
		IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
			IF sFinanceChk = 'Y' THEN
				F_MessageChk(39,'[자금 송부]')
				Return -1
			END IF
			IF sAccountChk = 'Y' THEN
				F_MessageChk(39,'[경리 송부]')
				Return -1
			END IF
		END IF
	CASE 100
		Return 1
	CASE -1
		MessageBox("확  인","자료 조회 중 에러가 발생하였습니다"+ SQLCA.SQLERRTEXT)
		Return -1
END CHOOSE

Return 1
end function

public function integer wf_control_ds_junpoy (string sflag, integer il_currentrow, integer ifrcnt, integer itocnt);///**************************************************************************************/
///****** 본지점 관리하는 계정(kfz01ot2에 있으면)이면 본지점대체전표 발생            	 **/
///*** 1. 신규 일 때 - 본지점전표 발생,본지점전표정보 저장										 **/
///*** 2. 수정 일 때 - 본지점전표정보를 읽어서 본지점전표내역을 갱신						 **/
///*** 3. 삭제 일 때 - 본지점전표정보를 읽어서 본지점전표 삭제								 **/
///*** * return : 1,   -1																					 **/
///*** call하는 곳 : 수정 후 줄 저장 시('MOD',현재 처리 행,0,0)								 **/
///***               줄 삭제 시('DELETE',현재 처리 행,0,0)										 **/
///***               수정에서 계정 변경 시 이전본지점계정 삭제('DELETE',현재 처리행,0,0)*/
///***               신규입력의 완료 시('NEW',0,1,999)											 **/
///***               수정에서 계정 변경 시의 신규본지점('NEW,0,현재처리행,현재처리행)  **/
///**************************************************************************************/
//Integer k,iLinNoS,iLinNoD,iLstCnt,iJunpoyCnt
//String  sSaupjS,sBalDateS,sUpmuGuS,sAcc1S,sAcc2S,sDcrGuS,sSaupjD,sBalDateD,sUpmuGuD,sAcc1D,&
//		  sAcc2D,sDcrGuD,sDeptCode,sSawon,sJunGu,sChaDae,sYesanGbn,sCusGbn,sRemark1		  
//Long    lBJunNoS,lBJunNoD
//
//dw_DaecheLst.Reset()
//dw_Daeche.Reset()
//
//IF sFlag = 'DELETE' THEN														/*삭제이면*/
//	sSaupjS   = dw_2.GetItemString(il_CurrentRow,"saupj")			/*발생전표*/
//	sBalDateS = dw_2.GetItemString(il_CurrentRow,"bal_date") 
//	sUpmuGuS  = dw_2.GetItemString(il_CurrentRow,"upmu_gu") 
//	lBJunNoS  = dw_2.GetItemNumber(il_CurrentRow,"bjun_no") 
//	iLinNoS   = ifrcnt
//	
//	IF dw_DaeCheLst.Retrieve(sSaupjS,sBalDateS,sUpmuGuS,lBJunNoS,iLinNoS) > 0 THEN
//		sSaupjD   = dw_DaeCheLst.GetItemString(1,"saupj_d")							/*대체전표*/
//		sBalDateD = dw_DaeCheLst.GetItemString(1,"bal_date_d") 
//		sUpmuGuD  = dw_DaeCheLst.GetItemString(1,"upmu_gu_d") 
//		lBJunNoD  = dw_DaeCheLst.GetItemNumber(1,"bjun_no_d") 
//		iLinNoD   = dw_DaeCheLst.GetItemNumber(1,"lin_no_d") 
//	
//		dw_DaeCheLst.DeleteRow(0)
//			
//		iJunpoyCnt = dw_DaeChe.Retrieve(sSaupjD,sBalDateD,sUpmuGuD,lBJunNoD,1,9999) 	
//		IF iJunpoyCnt > 0 THEN
//			FOR k = iJunPoyCnt TO 1 STEP -1
//				dw_DaeChe.DeleteRow(k)
//			NEXT
//		END IF
//		
//		IF dw_DaecheLst.Update() <> 1 THEN
//			F_MessageChk(12,'[본지점대체전표정보]')
//			RollBack;
//			Return -1
//		END IF
//	
//		IF dw_Daeche.Update() <> 1 THEN
////			F_MessageChk(12,'[본지점대체전표]')
//			RollBack;
//			Return -1
//		END IF
//	END IF
//END IF
//
Return 1
end function

event open;String sDeptCode

f_window_center_Response(this)

dw_print.SetTransObject(SQLCA)

dw_delete.SetTransObject(sqlca)
dw_delete.Reset()

dw_cond.SetTransObject(sqlca)
dw_cond.Reset()
dw_cond.InsertRow(0)

dw_2.SetTransObject(sqlca)

dw_daeche.SetTransObject(SQLCA)
dw_daechelst.SetTransObject(SQLCA)

sauctive_upmu =Message.StringParm

dw_cond.SetItem(1,"jun_gu", lstr_jpra.jun_gu)

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_cond.Modify("saupj.protect = 1")	
	
	dw_cond.Modify("dept_cd.protect = 1")
	dw_cond.Modify("t_dept.visible = 1")
ELSE
	dw_cond.Modify("saupj.protect = 0")	
	
	dw_cond.Modify("dept_cd.protect = 0")
	dw_cond.Modify("t_dept.visible = 0")
END IF
dw_cond.SetItem(dw_cond.GetRow(),"upmu_gu",sAuctive_upmu)

IF lstr_jpra.saupjang = "" OR lstr_jpra.dept = "" OR IsNull(lstr_jpra.saupjang) OR &
                                                              IsNull(lstr_jpra.dept) THEN
   dw_cond.SetItem(dw_cond.GetRow(),"saupj",gs_saupj)
	dw_cond.SetItem(dw_cond.GetRow(),"dept_cd",gs_dept)
	dw_cond.SetItem(dw_cond.GetRow(),"sdate",String(today(),"yyyymm")+"01")
	dw_cond.SetItem(dw_cond.GetRow(),"edate",String(today(),"yyyymmdd"))
ELSE
   dw_cond.SetItem(dw_cond.GetRow(),"saupj",lstr_jpra.saupjang)
	dw_cond.SetItem(dw_cond.GetRow(),"dept_cd",lstr_jpra.dept)
	dw_cond.SetItem(dw_cond.GetRow(),"sdate",Left(lstr_jpra.baldate,4)+Mid(lstr_jpra.baldate,5,2)+"01")
	dw_cond.SetItem(dw_cond.GetRow(),"edate",lstr_jpra.baldate)
 	p_inq.TriggerEvent(Clicked!)
END IF 

dw_cond.SetColumn("sdate")
dw_cond.SetFocus()

W_Mdi_Frame.sle_msg.text = '전표를 상세히 보고자 할 때 Double Click하십시오.!!'




end event

on w_kglb011.create
this.cb_c=create cb_c
this.cb_v=create cb_v
this.cb_w=create cb_w
this.cb_d=create cb_d
this.cb_q=create cb_q
this.p_del=create p_del
this.p_end=create p_end
this.p_can=create p_can
this.p_print=create p_print
this.p_inq=create p_inq
this.dw_daeche=create dw_daeche
this.dw_daechelst=create dw_daechelst
this.dw_delete=create dw_delete
this.dw_2=create dw_2
this.dw_print=create dw_print
this.dw_cond=create dw_cond
this.rr_1=create rr_1
this.Control[]={this.cb_c,&
this.cb_v,&
this.cb_w,&
this.cb_d,&
this.cb_q,&
this.p_del,&
this.p_end,&
this.p_can,&
this.p_print,&
this.p_inq,&
this.dw_daeche,&
this.dw_daechelst,&
this.dw_delete,&
this.dw_2,&
this.dw_print,&
this.dw_cond,&
this.rr_1}
end on

on w_kglb011.destroy
destroy(this.cb_c)
destroy(this.cb_v)
destroy(this.cb_w)
destroy(this.cb_d)
destroy(this.cb_q)
destroy(this.p_del)
destroy(this.p_end)
destroy(this.p_can)
destroy(this.p_print)
destroy(this.p_inq)
destroy(this.dw_daeche)
destroy(this.dw_daechelst)
destroy(this.dw_delete)
destroy(this.dw_2)
destroy(this.dw_print)
destroy(this.dw_cond)
destroy(this.rr_1)
end on

type cb_c from commandbutton within w_kglb011
integer x = 4690
integer y = 768
integer width = 402
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;p_can.TriggerEvent(Clicked!)
end event

type cb_v from commandbutton within w_kglb011
integer x = 4686
integer y = 672
integer width = 402
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&V)"
end type

event clicked;p_end.TriggerEvent(Clicked!)
end event

type cb_w from commandbutton within w_kglb011
integer x = 4690
integer y = 576
integer width = 402
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "인쇄(&W)"
end type

event clicked;p_print.TriggerEvent(Clicked!)
end event

type cb_d from commandbutton within w_kglb011
integer x = 4690
integer y = 480
integer width = 402
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;p_del.TriggerEvent(Clicked!)
end event

type cb_q from commandbutton within w_kglb011
integer x = 4690
integer y = 384
integer width = 402
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type p_del from uo_picture within w_kglb011
integer x = 3648
integer y = 4
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;Integer iSelectedRow,iRowCount,i
Long    lJunNo
Integer iLinNo
String  sSaupj,sBalDate,sUpmuGbn,sCurDate

sCurDate = F_Today()

dw_cond.AcceptText()
sUpmuGbn     = dw_cond.GetItemString(dw_cond.GetRow(),"upmu_gu")
if sUpmuGbn <> '' and Not IsNull(sUpmuGbn) then	
	if sUpmuGbn <> 'A' then							/*자동전표*/
		F_MessageChk(60,'')
		Return
	end if
end if

If dw_2.GetSelectedRow(0) <= 0 then
   MessageBox("확 인", "삭제할 전표라인을 선택한 후 삭제를 누르십시오 ")
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
   Return
End if

IF MessageBox("확 인", "삭제하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

SetPointer (HourGlass!)
DO WHILE true
   iSelectedRow = 	dw_2.GetSelectedRow(0)
   If iSelectedRow = 0 then
      exit
   END IF
	
   sSaupj   = dw_2.GetItemString(iSelectedRow, "saupj"  )
	sBalDate = dw_2.GetItemString(iSelectedRow, "bal_date" )
   sUpmuGbn = dw_2.GetItemString(iSelectedRow, "upmu_gu")
   lJunNo   = dw_2.GetItemNumber(iSelectedRow, "bjun_no" )
	
	if sUpmuGbn <> 'A' then							/*자동전표*/
		F_MessageChk(60,'')
		dw_2.SelectRow(iSelectedRow,FALSE)
		Continue
	end if
	
	IF Wf_Junpoy_Chk(sSaupj,sBalDate,sUpmuGbn,lJunNo) = -1 THEN 
	ELSE
		dw_delete.Reset()
		iRowCount = dw_delete.Retrieve(sSaupj,sBalDate,sUpmuGbn,lJunNo)
	
		FOR i = iRowCount TO 1 STEP -1	
			iLinNo = dw_delete.GetItemNumber(i,"lin_no")
			
			dw_delete.deleterow(i)	
			
			IF dw_delete.Update() <> 1 THEN
				Rollback;
				Return
			ELSE
				/*삭제시 각 레코드별로 처리-본지점*/
				IF Wf_Control_Ds_Junpoy('DELETE',iSelectedRow,iLinNo,0) = -1 THEN
					Rollback;
					Return 	
				END IF		
			END IF				
		NEXT
		
		DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
	   WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
	         ( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
	         ( "KFZ12OT1"."UPMU_GU"  = :sUpmuGbn ) AND  
	         ( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
		
		DELETE FROM "KFZ12OT3"  										/*전표송부내역 삭제*/
	   WHERE ( "KFZ12OT3"."SAUPJ"    = :sSaupj ) AND  
	         ( "KFZ12OT3"."BAL_DATE" = :sBalDate ) AND  
	         ( "KFZ12OT3"."UPMU_GU"  = :sUpmuGbn ) AND  
	         ( "KFZ12OT3"."JUN_NO"   = :lJunNo )   ;
		
		/*전표 이력 관리*/
		IF F_Control_Junpoy_History('D',	sSaupj,	sBalDate, sUpmuGbn,  lJunNo,  sBalDate, '', '', 'B') = -1  THEN
			F_MessageChk(12,'[전표 이력]')
			Rollback;
			Return
		END IF	
	END IF
	
	dw_2.SelectRow(iSelectedRow,FALSE)
LOOP

COMMIT;

p_inq.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_end from uo_picture within w_kglb011
integer x = 3822
integer y = 4
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Integer iSelectedRow

iSelectedRow = dw_2.GetSelectedRow(0)
If iSelectedRow <= 0 then
	lstr_jpra.flag =False
   close(parent)
	Return
end if

lstr_jpra.saupjang = dw_2.GetItemString(iSelectedRow, "saupj")
lstr_jpra.baldate  = dw_2.GetItemString(iSelectedRow, "bal_date")
lstr_jpra.upmugu   = dw_2.GetItemString(iSelectedRow, "upmu_gu")
lstr_jpra.bjunno   = dw_2.GetItemNumber(iSelectedRow, "bjun_no")

lstr_jpra.dept     = dw_2.GetItemString(iSelectedRow, "dept_cd")
lstr_jpra.jun_gu   = dw_2.GetItemString(iSelectedRow, "jungu")

lstr_jpra.flag =True

close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\선택_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\선택_up.gif"
end event

type p_can from uo_picture within w_kglb011
integer x = 3995
integer y = 4
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;lstr_jpra.flag =False

close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_print from uo_picture within w_kglb011
boolean visible = false
integer x = 3986
integer y = 156
integer width = 178
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;call super::clicked;Integer iSelectedRow,iRtnVal
Long    lJunNo
String  sSaupj,sBalDate,sUpmuGbn,sPrtGbn = '0',sJunGbn

If dw_2.GetSelectedRow(0) <= 0 then
   MessageBox("확 인", "출력할 전표를 선택하십시요")
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
   Return
End if

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

SetPointer (HourGlass!)
DO WHILE true
   iSelectedRow = 	dw_2.GetSelectedRow(0)
   If iSelectedRow = 0 then
      exit
   END IF
	
   sSaupj   = dw_2.GetItemString(iSelectedRow, "saupj"  )
	sBalDate = dw_2.GetItemString(iSelectedRow, "bal_date" )
   sUpmuGbn = dw_2.GetItemString(iSelectedRow, "upmu_gu")
   lJunNo   = dw_2.GetItemNumber(iSelectedRow, "bjun_no" )
	sJunGbn  = dw_2.GetItemString(iSelectedRow, "jungu" )

	F_Setting_Dw_Junpoy('N',sJunGbn,dw_print)

	iRtnVal = F_Call_JunpoyPrint(dw_print,'N',sJunGbn,sSaupj,sBalDate,sUpmuGbn,lJunNo,sPrtGbn,'P')
	IF iRtnVal = -1 THEN
		F_MessageChk(14,'')
		Return -1
	ELSEIF iRtnVal = -2 THEN
		Return 1
	ELSE	
		sPrtGbn = '1'
	END IF

	dw_2.SelectRow(iSelectedRow,FALSE)
LOOP

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_inq from uo_picture within w_kglb011
integer x = 3474
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;
String sSaupj,sDept,sBalDateFrom,sBalDateTo,sJunGu,sUpmuGbn
Long   lJunNo

dw_cond.AcceptText()
sSaupj       = dw_cond.GetItemString(dw_cond.GetRow(),"saupj")
sDept        = dw_cond.GetItemString(dw_cond.GetRow(),"dept_cd")
sBalDateFrom = dw_cond.GetItemString(dw_cond.GetRow(),"sdate")
sBalDateTo   = dw_cond.GetItemString(dw_cond.GetRow(),"edate")
sJunGu       = dw_cond.GetItemString(dw_cond.GetRow(),"jun_gu")
sUpmuGbn     = dw_cond.GetItemString(dw_cond.GetRow(),"upmu_gu")

IF sSaupj = "" or IsNull(sSaupj) THEN
   F_MessageChk(1,"[사업장]")
   dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	return
END IF

IF sDept = "" or IsNull(sDept) THEN
	sDept = '%'
END IF

IF sBalDateFrom = "" or IsNull(sBalDateFrom) THEN
   F_MessageChk(1,"[작성일자(from)]")
   dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	return
END IF

IF sBalDateTo = "" or IsNull(sBalDateTo) THEN
   F_MessageChk(1,"[작성일자(to)]")
   dw_cond.SetColumn("edate")
	dw_cond.SetFocus()
	return
END IF

IF sBalDateFrom > sBalDateto THEN
   MessageBox("확 인", "날짜의 범위 지정이 잘못되었습니다! 작성일자를 확인하십시오")
	dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	return
END IF
if sUpmuGbn = '' or IsNull(sUpmuGbn) then sUpmuGbn = '%'

dw_2.SetRedraw(False)

dw_2.Reset()
IF dw_2.Retrieve(sSaupj,sDept,sBalDateFrom,sBalDateTo,sUpmuGbn,sJunGu) <=0 THEN
   F_MessageChk(14,'')
	
	dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	
	dw_2.SetRedraw(True)
   return
end if

dw_2.SetRedraw(True)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type dw_daeche from datawindow within w_kglb011
boolean visible = false
integer x = 1627
integer y = 2396
integer width = 1321
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "본지점전표 추가"
string dataobject = "dw_kglb01_7"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;
String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax

OpenWithParm(w_error, db_error_msg)

RETURN 1

end event

type dw_daechelst from datawindow within w_kglb011
boolean visible = false
integer x = 1627
integer y = 2284
integer width = 1321
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "생성된 본지점전표번호 저장"
string dataobject = "dw_kglb01_8"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_delete from datawindow within w_kglb011
boolean visible = false
integer x = 805
integer y = 2280
integer width = 768
integer height = 100
boolean titlebar = true
string title = "전표의 라인 삭제"
string dataobject = "dw_kglb011_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;
String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax

OpenWithParm(w_error, db_error_msg)

RETURN 1

end event

type dw_2 from u_d_select_sort within w_kglb011
integer x = 41
integer y = 232
integer width = 4096
integer height = 1916
integer taborder = 30
string dataobject = "dw_kglb011_2"
boolean border = false
end type

event doubleclicked;
If Row <= 0 then
   return
END IF

lstr_jpra.saupjang  = dw_2.GetItemString(Row, "saupj")
lstr_jpra.baldate   = dw_2.GetItemString(Row, "bal_date")
lstr_jpra.upmugu    = dw_2.GetItemString(Row, "upmu_gu")
lstr_jpra.bjunno    = dw_2.GetItemNumber(Row, "bjun_no")

Open(w_kglc01a)

W_Mdi_Frame.sle_msg.text = '전표를 상세히 보고자 할 때 Double Click하십시오.!!'
end event

event clicked;
If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event rbuttondown;IF Row <=0 THEN Return

SelectRow(Row,False)
end event

type dw_print from datawindow within w_kglb011
boolean visible = false
integer x = 805
integer y = 2388
integer width = 768
integer height = 100
boolean titlebar = true
string title = "인쇄(전표)"
string dataobject = "dw_kglb01_4"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_cond from datawindow within w_kglb011
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 12
integer width = 3241
integer height = 216
integer taborder = 10
string dataobject = "dw_kglb011_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;
Return 1
end event

event getfocus;this.AcceptText()
end event

event itemchanged;String  sSaupj,  sDate,sDeptCode,sDeptName,sNull
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()

this.AcceptText()
IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "dept_cd" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	sDeptName = F_Get_PersonLst('3',sDeptCode,'1')
	IF IsNull(sDeptName) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(iCurRow,"dept_cd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "sdate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[작성일자]')
		this.SetItem(iCurRow,"sdate",snull)
		Return 1
	else
		p_inq.TriggerEvent(Clicked!)
	END IF
END IF

IF this.GetColumnName() = "edate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[작성일자]')
		this.SetItem(iCurRow,"edate",snull)
		Return 1
	ELSE
		p_inq.TriggerEvent(Clicked!)
	END IF
END IF


end event

type rr_1 from roundrectangle within w_kglb011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 228
integer width = 4123
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type


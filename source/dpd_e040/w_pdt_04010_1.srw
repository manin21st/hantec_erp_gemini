$PBExportHeader$w_pdt_04010_1.srw
$PBExportComments$출고의뢰 발주검토
forward
global type w_pdt_04010_1 from window
end type
type p_create from picture within w_pdt_04010_1
end type
type p_save from uo_picture within w_pdt_04010_1
end type
type p_inq from uo_picture within w_pdt_04010_1
end type
type p_exit from uo_picture within w_pdt_04010_1
end type
type dw_update from datawindow within w_pdt_04010_1
end type
type dw_1 from datawindow within w_pdt_04010_1
end type
type dw_2 from datawindow within w_pdt_04010_1
end type
type p_can from uo_picture within w_pdt_04010_1
end type
type rr_4 from roundrectangle within w_pdt_04010_1
end type
type dw_from from datawindow within w_pdt_04010_1
end type
type rr_2 from roundrectangle within w_pdt_04010_1
end type
type rr_1 from roundrectangle within w_pdt_04010_1
end type
end forward

global type w_pdt_04010_1 from window
integer x = 96
integer y = 136
integer width = 4325
integer height = 2220
boolean titlebar = true
string title = "발주내역 출고의뢰"
windowtype windowtype = response!
long backcolor = 32106727
p_create p_create
p_save p_save
p_inq p_inq
p_exit p_exit
dw_update dw_update
dw_1 dw_1
dw_2 dw_2
p_can p_can
rr_4 rr_4
dw_from dw_from
rr_2 rr_2
rr_1 rr_1
end type
global w_pdt_04010_1 w_pdt_04010_1

type variables
string  is_buseo
String  is_sysno // 할당번호
//string 	ispordno  // 작업지시번호

end variables

forward prototypes
public subroutine wf_reset ()
end prototypes

public subroutine wf_reset ();dw_from.setredraw(false)

dw_1.reset()
dw_2.reset()

dw_1.insertrow(0)
dw_From.SetFocus()

dw_from.setredraw(true)

end subroutine

event open;is_buseo = message.stringparm

f_window_center_response(this)

dw_from.settransobject(sqlca)
dw_update.settransobject(sqlca)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_from.InsertRow(0)


end event

on w_pdt_04010_1.create
this.p_create=create p_create
this.p_save=create p_save
this.p_inq=create p_inq
this.p_exit=create p_exit
this.dw_update=create dw_update
this.dw_1=create dw_1
this.dw_2=create dw_2
this.p_can=create p_can
this.rr_4=create rr_4
this.dw_from=create dw_from
this.rr_2=create rr_2
this.rr_1=create rr_1
this.Control[]={this.p_create,&
this.p_save,&
this.p_inq,&
this.p_exit,&
this.dw_update,&
this.dw_1,&
this.dw_2,&
this.p_can,&
this.rr_4,&
this.dw_from,&
this.rr_2,&
this.rr_1}
end on

on w_pdt_04010_1.destroy
destroy(this.p_create)
destroy(this.p_save)
destroy(this.p_inq)
destroy(this.p_exit)
destroy(this.dw_update)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.p_can)
destroy(this.rr_4)
destroy(this.dw_from)
destroy(this.rr_2)
destroy(this.rr_1)
end on

type p_create from picture within w_pdt_04010_1
integer x = 1874
integer y = 24
integer width = 178
integer height = 144
string picturename = "C:\erpman\image\자료생성_up.gif"
boolean focusrectangle = false
end type

event clicked;
String	nToday, sBaljpno, xError,  sBuseo
Integer	nN

p_inq.TriggerEvent(Clicked!)


IF 	MessageBox("확인", "자료를 처리 하시겠습니까?", question!, yesno!) = 2	THEN	
	RETURN
End if
/////////////////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '할당내역을 적상중입니다....!!'
sBaljpno = trim(dw_from.GetItemString(1, "baljpno"))
	/* 할당내역을 삭제 */
If	sBaljpno <> "" and NOT isNull(sBaljpno) 	then
	Delete From holdstock_copy Where sabu = :gs_sabu and pjt_cd = :sBaljpno;	
	if 	sqlca.sqlcode <> 0 then
		messagebox("DELETE Error", sqlca.sqlerrtext + ' ' + string(sqlca.sqlcode), stopsign!)
		rollback;
		return
	end if
	commit;
End If	

//-------------------------------------------------------------------------------------------------------//


ntoday = f_today()
// 할당번호 채번(모든 계산단위는 작업지시 기준번호를 기준으로 한다)
Nn 	= sqlca.fun_junpyo(gs_sabu, nToday, 'B0')
if 	Nn < 1 then
	f_message_chk(51,'[할당번호]') 
	rollback;
	return -1
end if

iS_sysno 	= nToday + String(nN,'0000') 
Xerror = 'X'
sqlca.erp000000840_chul(gs_sabu, sBaljpno, iS_sysno, is_buseo, xerror)

Choose Case xError
		 Case 'X'
				Rollback;
				F_message_chk(41,'[자동할당내역 Procedure]')
				return;
		 Case 'Y'
				Rollback;
				F_message_chk(89,'[자동할당내역 계산]')
				return;			
End Choose

Commit;

iS_sysno	= gs_code

SetPointer(Arrow!)

If 	dw_2.Retrieve(gs_sabu , sBaljpno)	 < 1 then
	f_message_Chk(50, '[할당내역]')
	w_mdi_frame.sle_msg.text = ''
End if
w_mdi_frame.sle_msg.text = '적상 완료입니다....!!'

return  1

end event

type p_save from uo_picture within w_pdt_04010_1
integer x = 2057
integer y = 24
integer width = 178
integer taborder = 50
boolean bringtotop = true
string picturename = "C:\erpman\image\복사_up.gif"
end type

event clicked;call super::clicked;String		sBaljpno
long		lRow
Integer	ls_cnt

p_inq.TriggerEvent(Clicked!)

IF 	dw_1.RowCount() < 1	THEN	return  

IF 	MessageBox("확인", "자료를 처리 하시겠습니까?", question!, yesno!) = 2	THEN	
	RETURN
End if
/////////////////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

sBaljpno = trim(dw_from.GetItemString(1, "baljpno"))

//-------------------------------------------------------------------------------------------------------//

/* 작업지시에 대한 할당을 작성 - 단 할당생성을 check한 경우 */
w_mdi_frame.sle_msg.text = '할당내역을 복사중입니다....!!'

		INSERT  INTO  HOLDSTOCK
		          ( SABU, 		HOLD_NO, 	HOLD_DATE, 		HOLD_GU, 	ITNBR, 		PSPEC, 	HOLD_QTY,	ADDQTY, 
				  ISQTY,		UNQTY,		HOLD_STORE,	OUT_STORE,	REQ_DEPT,	RQDAT,	OUT_CHK,	NAOUGU,
				  IN_STORE,	HOSTS,		OPSEQ,			BUWAN,		HYEBIA3,		HYEBIA4,		PJT_CD)
		(SELECT SABU, 		HOLD_NO, 	HOLD_DATE, 		HOLD_GU, 	ITNBR, 		PSPEC, 	HOLD_QTY,	ADDQTY, 
				  ISQTY,		UNQTY,		HOLD_STORE,	OUT_STORE,	REQ_DEPT,	RQDAT,	OUT_CHK,	NAOUGU,
				  IN_STORE,	HOSTS,		OPSEQ,			'N',			'2',				'Y',	PJT_CD
		  FROM    HOLDSTOCK_COPY
		  WHERE  SABU = :gs_sabu AND PJT_CD	= :sBaljpno);
		  
if 	sqlca.sqlcode <> 0 then
	messagebox("Insert Error", sqlca.sqlerrtext + ' ' + string(sqlca.sqlcode), stopsign!)
	setNull(gs_code)
	rollback;
	return
end if				
	
Commit;
// ---- 할당 번호를 입력...
SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = '복사 완료입니다....!!'

SELECT     SUBSTR(HOLD_NO,1,12) INTO :gs_code
	FROM   HOLDSTOCK_COPY
   WHERE   HOLDSTOCK_COPY.SABU = :gs_sabu AND HOLDSTOCK_COPY.PJT_CD = :sBaljpno
	   AND ROWNUM = 1;
		
//-------------------------------------------------------------------------------------------------------//
Messagebox("복사완료", "복사되었읍니다")
p_inq.TriggerEvent(Clicked!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type p_inq from uo_picture within w_pdt_04010_1
integer x = 1691
integer y = 24
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;string		sBaljpno, sparent, sittyp, scinbr, sError
Integer nn

IF	dw_from.AcceptText() = -1	THEN	RETURN

sBaljpno = trim(dw_from.GetItemString(1, "baljpno"))

IF 	sBaljpno ="" OR IsNull(sBaljpno) THEN
	Messagebox("확 인","발주번호를 입력하세요!!")
   	dw_from.setcolumn('baljpno')
   	dw_from.setfocus()
	Return
END IF


If 	dw_1.Retrieve(gs_sabu , sBaljpno)	 < 1 then
	f_message_Chk(50, '[발주내역]')
	w_mdi_frame.sle_msg.text = ''
	Return
End if

dw_2.Retrieve(gs_sabu , sBaljpno)



end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type p_exit from uo_picture within w_pdt_04010_1
integer x = 2423
integer y = 24
integer width = 178
integer taborder = 70
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''
close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

type dw_update from datawindow within w_pdt_04010_1
boolean visible = false
integer x = 695
integer y = 2220
integer width = 1303
integer height = 160
string dataobject = "d_pdm_11713_5"
boolean border = false
boolean livescroll = true
end type

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type dw_1 from datawindow within w_pdt_04010_1
integer x = 91
integer y = 508
integer width = 1755
integer height = 1604
string dataobject = "d_pdt_04010_12"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_2 from datawindow within w_pdt_04010_1
integer x = 1897
integer y = 508
integer width = 2386
integer height = 1604
string dataobject = "d_pdt_04010_13"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type p_can from uo_picture within w_pdt_04010_1
integer x = 2240
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;String snull

SetNull(snull)

dw_from.reset()
dw_from.insertrow(0)

dw_1.reset()
dw_2.reset()

dw_from.setcolumn('baljpno')
dw_from.SetFocus()

w_mdi_frame.sle_msg.text = ''

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

type rr_4 from roundrectangle within w_pdt_04010_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1655
integer y = 16
integer width = 978
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_from from datawindow within w_pdt_04010_1
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 105
integer y = 208
integer width = 3086
integer height = 216
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_04010_11"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

String sGubun

IF this.GetColumnName() = "baljpno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	gs_code  = '3' //발주구분 => 외주
	open(w_poblkt_popup)
	
	IF 	isnull(gs_Code)  or  gs_Code = ''	then  RETURN
	SetItem(1, "baljpno",gs_code)
   	TriggerEvent(ItemChanged!)

   return 1 

END IF	
end event

event itemerror;return 1
end event

event itemchanged;string snull, sbaljno, get_nm, sGubun 

setnull(snull)

IF 	this.GetColumnName() ="baljpno" THEN
	sbaljno = trim(this.GetText())
	
	IF	Isnull(sbaljno)  or  sbaljno = ''	Then
		wf_reset()
		RETURN 
   END IF

  SELECT "POMAST"."BALJPNO", 
  			"POMAST"."BALGU" 
    INTO :get_nm, :sGubun  
    FROM "POMAST"  
   WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
         ( "POMAST"."BALJPNO" = :sbaljno )   ;

	IF 	SQLCA.SQLCODE <> 0 Then
		this.triggerevent(rbuttondown!)
		IF 	gs_code ="" OR IsNull(gs_code) THEN
   			wf_reset()
     END IF
    	RETURN 1
	ElseIF sGubun <> '3' Then
		Messagebox("발주번호", "외주발주내역이 아닙니다", stopsign!)
      RETURN 1		
ELSE
      this.retrieve(gs_sabu, sbaljno)
		p_inq.triggerevent(clicked!)
	END IF
END IF

end event

type rr_2 from roundrectangle within w_pdt_04010_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1883
integer y = 456
integer width = 2418
integer height = 1680
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pdt_04010_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 456
integer width = 1801
integer height = 1680
integer cornerheight = 40
integer cornerwidth = 55
end type


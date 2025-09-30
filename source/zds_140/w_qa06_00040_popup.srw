$PBExportHeader$w_qa06_00040_popup.srw
$PBExportComments$**품질지수 목표 등록
forward
global type w_qa06_00040_popup from window
end type
type p_2 from picture within w_qa06_00040_popup
end type
type p_1 from picture within w_qa06_00040_popup
end type
type dw_2 from datawindow within w_qa06_00040_popup
end type
type rr_1 from roundrectangle within w_qa06_00040_popup
end type
end forward

global type w_qa06_00040_popup from window
integer width = 4009
integer height = 1132
boolean titlebar = true
string title = "품질지수 목표 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
p_2 p_2
p_1 p_1
dw_2 dw_2
rr_1 rr_1
end type
global w_qa06_00040_popup w_qa06_00040_popup

on w_qa06_00040_popup.create
this.p_2=create p_2
this.p_1=create p_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.Control[]={this.p_2,&
this.p_1,&
this.dw_2,&
this.rr_1}
end on

on w_qa06_00040_popup.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;dw_2.SetTransObject(SQLCA)

f_window_center_response(this) 

// gs_gubun 은 기준년도 4자리
If dw_2.Retrieve(gs_gubun) < 1 Then
	INSERT INTO MOKPYO
	(	YYYY,		SAUPJ,		GUBUN,		VAL_YEAR,
		VAL_01,	VAL_02,		VAL_03,		VAL_04,		VAL_05,		VAL_06,		VAL_07,		VAL_08,		VAL_09,		VAL_10,		VAL_11,		VAL_12,		BIGO	)
	SELECT
		:gs_gubun,	'99',		'고객불만',		0,
		0,			0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				'품질 지수 현황'
	  FROM DUAL
	UNION
	SELECT
		:gs_gubun,	'99',		'출하검사',		0,
		0,			0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				'품질 지수 현황'
	  FROM DUAL
	UNION
	SELECT
		:gs_gubun,	'99',		'수입검사',		0,
		0,			0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				'품질 지수 현황'
	  FROM DUAL
	UNION
	SELECT
		:gs_gubun,	'99',		'공정검사',		0,
		0,			0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				'품질 지수 현황'
	  FROM DUAL
	UNION
	SELECT
		:gs_gubun,	'99',		'협력사품질',		0,
		0,			0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				0,				'품질 지수 현황'
	  FROM DUAL;
	
	COMMIT;
	
	dw_2.Retrieve(gs_gubun)
	
End If

SetNull(gs_gubun)

end event

type p_2 from picture within w_qa06_00040_popup
integer x = 3749
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\취소_up.gif"
boolean focusrectangle = false
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_1 from picture within w_qa06_00040_popup
integer x = 3561
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;If dw_2.AcceptText() <> 1 Then Return -1

Setpointer(Hourglass!)	

dw_2.AcceptText()
If dw_2.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return
Else
	Commit;
End if

messagebox('확인','자료저장이 완료되었습니다!!!')
gs_code = 'OK'
close(parent)
end event

type dw_2 from datawindow within w_qa06_00040_popup
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 172
integer width = 3909
integer height = 832
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa06_00040_popup_1"
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sNull, sDate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case "yymmdd"  , "arrymd"
		sDate = Trim(GetText())
		if f_DateChk(sDate) = -1 then
			f_Message_Chk(35, '[일자]')
			SetItem(1,GetColumnName(),sNull)
			return 1
		end if
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			
			SetItem(1,"cvnas",	scvnas)
		END IF
End Choose

end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type rr_1 from roundrectangle within w_qa06_00040_popup
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 160
integer width = 3941
integer height = 860
integer cornerheight = 40
integer cornerwidth = 55
end type


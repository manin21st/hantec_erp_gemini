$PBExportHeader$w_data_import.srw
$PBExportComments$데이타 컨버젼(임시)
forward
global type w_data_import from w_inherite
end type
type dw_1 from u_key_enter within w_data_import
end type
end forward

global type w_data_import from w_inherite
string title = "회기 등록"
dw_1 dw_1
end type
global w_data_import w_data_import

type variables
Boolean itemerr
end variables

on w_data_import.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_data_import.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

IF dw_1.Retrieve() <=0 THEN
	MessageBox("확 인","회기 자료가 없습니다.!!")
	dw_1.InsertRow(0)
END IF
ib_any_typing =False
end event

type dw_insert from w_inherite`dw_insert within w_data_import
boolean visible = false
integer x = 50
integer y = 2400
end type

type p_delrow from w_inherite`p_delrow within w_data_import
boolean visible = false
integer x = 3543
integer y = 2932
end type

type p_addrow from w_inherite`p_addrow within w_data_import
boolean visible = false
integer x = 3369
integer y = 2932
end type

type p_search from w_inherite`p_search within w_data_import
boolean visible = false
integer x = 2651
integer y = 2960
end type

type p_ins from w_inherite`p_ins within w_data_import
boolean visible = false
integer x = 3195
integer y = 2932
end type

type p_exit from w_inherite`p_exit within w_data_import
end type

type p_can from w_inherite`p_can within w_data_import
boolean visible = false
integer x = 3986
integer y = 2988
end type

type p_print from w_inherite`p_print within w_data_import
boolean visible = false
integer x = 2848
integer y = 2932
end type

type p_inq from w_inherite`p_inq within w_data_import
boolean visible = false
integer x = 3022
integer y = 2932
end type

type p_del from w_inherite`p_del within w_data_import
boolean visible = false
integer x = 3771
integer y = 2952
end type

type p_mod from w_inherite`p_mod within w_data_import
integer x = 4265
end type

event p_mod::clicked;call super::clicked;string  snull, ls_d_frymd, ls_d_toymd,ls_j_frymd, ls_j_toymd,sValYm[]
long    ll_row, ll_d_ses, ll_j_ses, lnull,iStartCnt,k
String  sColYm[]={"dym01","dym02","dym03","dym04","dym05","dym06","dym07","dym08","dym09","dym10","dym11","dym12","dym00"}

SetNull(snull)
SetNull(lnull)

IF dw_1.AcceptText() = -1 THEN RETURN

ll_row = dw_1.getrow()

if ll_row <=0 then return 

ll_d_ses = dw_1.GetItemNumber(ll_row, 'd_ses')     //당기

ls_d_frymd = dw_1.GetItemString(ll_row, 'd_frymd') //당기 시작일자
ls_d_toymd = dw_1.GetItemString(ll_row, 'd_toymd') //당기 종료일자

ll_j_ses = dw_1.GetItemNumber(ll_row, 'j_ses')     //전기
ls_j_frymd = dw_1.GetItemString(ll_row, 'j_frymd') //당기 시작일자
ls_j_toymd = dw_1.GetItemString(ll_row, 'j_toymd') //당기 종료일자


IF trim(string(ll_d_ses)) ="" OR IsNull(ll_d_ses) THEN 
	F_MessageChk(1, '[당기]')
	dw_1.SetItem(ll_row, 'd_ses', lnull)	
	RETURN 
elseif Not IsNumber(string(ll_d_ses)) THEN
	MessageBox("확 인","당기는 숫자를 입력하세요.!!")
	dw_1.SetItem(ll_row, 'd_ses', lnull)	
	RETURN 
END IF

IF trim(ls_d_frymd) ="" OR IsNull(ls_d_frymd) THEN 
	F_MessageChk(1, '[당기일자]')	
	RETURN 
elseif f_datechk(ls_d_frymd) = -1 THEN 
	F_MessageChk(21, '[당기일자]')	
	dw_1.SetItem(ll_row,"d_frymd",snull)
	Return 
END IF

IF trim(ls_d_toymd) ="" OR IsNull(ls_d_toymd) THEN 
	F_MessageChk(1, '[당기일자]')		
	RETURN 
elseif f_datechk(ls_d_toymd) = -1 THEN 
	F_MessageChk(21, '[당기일자]')	
	dw_1.SetItem(ll_row,"d_toymd",snull)
	Return 
END IF

IF trim(string(ll_j_ses)) ="" OR IsNull(ll_j_ses) THEN 
	F_MessageChk(1, '[전기]')
	dw_1.SetItem(ll_row, 'j_ses', lnull)	
	RETURN 
elseif Not IsNumber(string(ll_j_ses)) THEN
	MessageBox("확 인","당기는 숫자를 입력하세요.!!")
	dw_1.SetItem(ll_row, 'j_ses', lnull)	
	RETURN 
END IF

IF trim(ls_j_frymd) ="" OR IsNull(ls_j_frymd) THEN 
	F_MessageChk(1, '[전기일자]')	
	RETURN 
elseif f_datechk(ls_j_frymd) = -1 THEN 
	F_MessageChk(21, '[전기일자]')	
	dw_1.SetItem(ll_row,"j_frymd",snull)
	Return 
END IF

IF trim(ls_j_toymd) ="" OR IsNull(ls_j_toymd) THEN 
	F_MessageChk(1, '[전기일자]')		
	RETURN 
elseif f_datechk(ls_j_toymd) = -1 THEN 
	F_MessageChk(21, '[전기일자]')	
	dw_1.SetItem(ll_row,"j_toymd",snull)
	Return 
END IF

w_mdi_frame.sle_msg.text = '자료 저장 중...'
SetPointer(HourGlass!)

/*당기의 시작년월~종료년월 setting*/
iStartCnt = 1

sValYm[1] 	= Left(ls_d_frymd,6)
sValYm[12] = Left(ls_d_toymd,6)

FOR k = 1 TO 10
	IF Integer(Right(sValYm[iStartCnt],2)) + 1 > 12 THEN
		sValYm[k + 1] = String(Long(Left(sValYm[iStartcnt],4)) + 1,'0000')+'01'
	ELSE
		sValYm[k + 1] = Left(sValYm[iStartcnt],4) + String(Integer(Right(sValYm[iStartCnt],2)) + 1,'00')
	END IF
	IF sValYm[k + 1] >= sValYm[12] THEN
		F_Messagechk(26,'[12개월 미만]')
		dw_1.SetColumn('d_toymd')
		dw_1.SetFocus()
		Return -1
	END IF
	iStartCnt = iStartCnt + 1
NEXT

IF Integer(Right(sValYm[11],2)) + 1 = 13 AND &
		String(Long(Left(sValYm[11],4)) + 1,'0000')+'01' = sValYm[12] THEN
ELSEIF Integer(Right(sValYm[11],2)) + 1 = Integer(Right(sValYm[12],2)) THEN
ELSE
	F_Messagechk(26,'[12개월 초과]')
	dw_1.SetColumn('d_toymd')
	dw_1.SetFocus()
	Return -1
END IF

FOR k = 1 TO 12
	dw_1.SetItem(1,sColYm[k],sValYm[k])
NEXT
dw_1.SetItem(1,sColYm[13],Left(sValYm[1],4)+'00')

IF dw_1.Update() <> 1 THEN
	MessageBox("확 인","회기 수정 실패 !!")
	ROLLBACK;
	RETURN
END IF
COMMIT;
w_mdi_frame.sle_msg.text = '자료 저장 완료'
SetPointer(Arrow!)

ib_any_typing =False

end event

type cb_exit from w_inherite`cb_exit within w_data_import
boolean visible = false
integer x = 2153
integer y = 2508
integer taborder = 30
end type

type cb_mod from w_inherite`cb_mod within w_data_import
boolean visible = false
integer x = 1787
integer y = 2512
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;string  snull, ls_d_frymd, ls_d_toymd,ls_j_frymd, ls_j_toymd,sValYm[]
long    ll_row, ll_d_ses, ll_j_ses, lnull,iStartCnt,k
String  sColYm[]={"dym01","dym02","dym03","dym04","dym05","dym06","dym07","dym08","dym09","dym10","dym11","dym12","dym00"}

SetNull(snull)
SetNull(lnull)

IF dw_1.AcceptText() = -1 THEN RETURN

ll_row = dw_1.getrow()

if ll_row <=0 then return 

ll_d_ses = dw_1.GetItemNumber(ll_row, 'd_ses')     //당기

ls_d_frymd = dw_1.GetItemString(ll_row, 'd_frymd') //당기 시작일자
ls_d_toymd = dw_1.GetItemString(ll_row, 'd_toymd') //당기 종료일자

ll_j_ses = dw_1.GetItemNumber(ll_row, 'j_ses')     //전기
ls_j_frymd = dw_1.GetItemString(ll_row, 'j_frymd') //당기 시작일자
ls_j_toymd = dw_1.GetItemString(ll_row, 'j_toymd') //당기 종료일자


IF trim(string(ll_d_ses)) ="" OR IsNull(ll_d_ses) THEN 
	F_MessageChk(1, '[당기]')
	dw_1.SetItem(ll_row, 'd_ses', lnull)	
	RETURN 
elseif Not IsNumber(string(ll_d_ses)) THEN
	MessageBox("확 인","당기는 숫자를 입력하세요.!!")
	dw_1.SetItem(ll_row, 'd_ses', lnull)	
	RETURN 
END IF

IF trim(ls_d_frymd) ="" OR IsNull(ls_d_frymd) THEN 
	F_MessageChk(1, '[당기일자]')	
	RETURN 
elseif f_datechk(ls_d_frymd) = -1 THEN 
	F_MessageChk(21, '[당기일자]')	
	dw_1.SetItem(ll_row,"d_frymd",snull)
	Return 
END IF

IF trim(ls_d_toymd) ="" OR IsNull(ls_d_toymd) THEN 
	F_MessageChk(1, '[당기일자]')		
	RETURN 
elseif f_datechk(ls_d_toymd) = -1 THEN 
	F_MessageChk(21, '[당기일자]')	
	dw_1.SetItem(ll_row,"d_toymd",snull)
	Return 
END IF

IF trim(string(ll_j_ses)) ="" OR IsNull(ll_j_ses) THEN 
	F_MessageChk(1, '[전기]')
	dw_1.SetItem(ll_row, 'j_ses', lnull)	
	RETURN 
elseif Not IsNumber(string(ll_j_ses)) THEN
	MessageBox("확 인","당기는 숫자를 입력하세요.!!")
	dw_1.SetItem(ll_row, 'j_ses', lnull)	
	RETURN 
END IF

IF trim(ls_j_frymd) ="" OR IsNull(ls_j_frymd) THEN 
	F_MessageChk(1, '[전기일자]')	
	RETURN 
elseif f_datechk(ls_j_frymd) = -1 THEN 
	F_MessageChk(21, '[전기일자]')	
	dw_1.SetItem(ll_row,"j_frymd",snull)
	Return 
END IF

IF trim(ls_j_toymd) ="" OR IsNull(ls_j_toymd) THEN 
	F_MessageChk(1, '[전기일자]')		
	RETURN 
elseif f_datechk(ls_j_toymd) = -1 THEN 
	F_MessageChk(21, '[전기일자]')	
	dw_1.SetItem(ll_row,"j_toymd",snull)
	Return 
END IF

sle_msg.text = '자료 저장 중...'
SetPointer(HourGlass!)

/*당기의 시작년월~종료년월 setting*/
iStartCnt = 1

sValYm[1] 	= Left(ls_d_frymd,6)
sValYm[12] = Left(ls_d_toymd,6)

FOR k = 1 TO 10
	IF Integer(Right(sValYm[iStartCnt],2)) + 1 > 12 THEN
		sValYm[k + 1] = String(Long(Left(sValYm[iStartcnt],4)) + 1,'0000')+'01'
	ELSE
		sValYm[k + 1] = Left(sValYm[iStartcnt],4) + String(Integer(Right(sValYm[iStartCnt],2)) + 1,'00')
	END IF
	IF sValYm[k + 1] >= sValYm[12] THEN
		F_Messagechk(26,'[12개월 미만]')
		dw_1.SetColumn('d_toymd')
		dw_1.SetFocus()
		Return -1
	END IF
	iStartCnt = iStartCnt + 1
NEXT

IF Integer(Right(sValYm[11],2)) + 1 = 13 AND &
		String(Long(Left(sValYm[11],4)) + 1,'0000')+'01' = sValYm[12] THEN
ELSEIF Integer(Right(sValYm[11],2)) + 1 = Integer(Right(sValYm[12],2)) THEN
ELSE
	F_Messagechk(26,'[12개월 초과]')
	dw_1.SetColumn('d_toymd')
	dw_1.SetFocus()
	Return -1
END IF

FOR k = 1 TO 12
	dw_1.SetItem(1,sColYm[k],sValYm[k])
NEXT
dw_1.SetItem(1,sColYm[13],Left(sValYm[1],4)+'00')

IF dw_1.Update() <> 1 THEN
	MessageBox("확 인","회기 수정 실패 !!")
	ROLLBACK;
	RETURN
END IF
COMMIT;
sle_msg.text = '자료 저장 완료'
SetPointer(Arrow!)

ib_any_typing =False

end event

type cb_ins from w_inherite`cb_ins within w_data_import
boolean visible = false
integer x = 878
integer y = 2432
end type

type cb_del from w_inherite`cb_del within w_data_import
boolean visible = false
integer x = 1591
integer y = 2428
end type

type cb_inq from w_inherite`cb_inq within w_data_import
boolean visible = false
integer x = 1947
integer y = 2424
end type

type cb_print from w_inherite`cb_print within w_data_import
integer x = 2304
integer y = 2428
end type

type st_1 from w_inherite`st_1 within w_data_import
integer width = 306
end type

type cb_can from w_inherite`cb_can within w_data_import
boolean visible = false
integer x = 2661
integer y = 2424
end type

type cb_search from w_inherite`cb_search within w_data_import
integer x = 3017
integer y = 2428
end type

type dw_datetime from w_inherite`dw_datetime within w_data_import
integer x = 2825
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_data_import
integer x = 343
integer width = 2482
end type

type gb_10 from w_inherite`gb_10 within w_data_import
integer width = 3575
end type

type gb_button1 from w_inherite`gb_button1 within w_data_import
boolean visible = false
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_data_import
boolean visible = false
integer x = 1737
integer y = 2456
integer width = 814
end type

type dw_1 from u_key_enter within w_data_import
integer x = 1403
integer y = 748
integer width = 1733
integer height = 456
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kgle04_0"
boolean border = false
end type

event itemerror;call super::itemerror;String sColName

IF itemerr =True THEN
	itemerr =False
	Return 1
END IF

sColName =dwo.name+"_t.text"

sle_msg.text ="필수 입력:"+Describe(sColName)+" 은 필수입력입니다.!!"
Return 1
end event

event itemchanged;String snull
Int lnull

SetNull(lnull)
SetNull(snull)

IF dwo.name ="d_ses" THEN
	IF data ="" OR IsNull(data) THEN RETURN 1
	IF Not IsNumber(data) THEN
		MessageBox("확 인","당기는 숫자를 입력하세요.!!")
		dw_1.SetItem(dw_1.Getrow(),"d_ses",lnull)
		itemerr =True
		Return 1
	END IF
END IF

IF dwo.name ="d_frymd" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	IF f_datechk(data) = -1 THEN 
		MessageBox("확 인","당기일자를 확인하세요.!!")
		dw_1.SetItem(dw_1.Getrow(),"d_frymd",snull)
		itemerr =True
		Return 1
	END IF
END IF

IF dwo.name ="d_toymd" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	IF f_datechk(data) = -1 THEN 
		MessageBox("확 인","당기일자를 확인하세요.!!")
		dw_1.SetItem(dw_1.Getrow(),"d_toymd",snull)
		itemerr =True
		Return 1
	END IF
END IF

IF dwo.name ="j_ses" THEN
	IF data ="" OR IsNull(data) THEN RETURN 1
	IF Not IsNumber(data) THEN
		MessageBox("확 인","전기는 숫자를 입력하세요.!!")
		dw_1.SetItem(dw_1.Getrow(),"j_ses",lnull)
		itemerr =True
		Return 1
	END IF
END IF

IF dwo.name ="j_frymd" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	IF f_datechk(data) = -1 THEN 
		MessageBox("확 인","전기일자를 확인하세요.!!")
		dw_1.SetItem(dw_1.Getrow(),"j_frymd",snull)
		itemerr =True
		Return 1
	END IF
END IF

IF dwo.name ="j_toymd" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	IF f_datechk(data) = -1 THEN 
		MessageBox("확 인","전기일자를 확인하세요.!!")
		dw_1.SetItem(dw_1.Getrow(),"j_toymd",snull)
		itemerr =True
		Return 1
	END IF
END IF
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event


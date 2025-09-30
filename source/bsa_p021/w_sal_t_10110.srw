$PBExportHeader$w_sal_t_10110.srw
$PBExportComments$**검수 집계현황
forward
global type w_sal_t_10110 from w_standard_print
end type
type rb_1 from radiobutton within w_sal_t_10110
end type
type rb_2 from radiobutton within w_sal_t_10110
end type
type rb_3 from radiobutton within w_sal_t_10110
end type
type rb_4 from radiobutton within w_sal_t_10110
end type
type rb_5 from radiobutton within w_sal_t_10110
end type
type rb_6 from radiobutton within w_sal_t_10110
end type
type rb_7 from radiobutton within w_sal_t_10110
end type
type pb_1 from u_pb_cal within w_sal_t_10110
end type
type pb_2 from u_pb_cal within w_sal_t_10110
end type
type gb_1 from groupbox within w_sal_t_10110
end type
type gb_2 from groupbox within w_sal_t_10110
end type
type rr_1 from roundrectangle within w_sal_t_10110
end type
type rr_3 from roundrectangle within w_sal_t_10110
end type
end forward

global type w_sal_t_10110 from w_standard_print
string title = "검수 집계현황"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
pb_1 pb_1
pb_2 pb_2
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
rr_3 rr_3
end type
global w_sal_t_10110 w_sal_t_10110

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_cvcod, s_datef,s_datet, ssaupj, ls_itnbr1, ls_itnbr2

If dw_ip.accepttext() <> 1 Then Return -1

s_datef 	= dw_ip.getitemstring(1,"sdatef")
s_datet 	= dw_ip.getitemstring(1,"sdatet")
s_cvcod 	= dw_ip.getitemstring(1,"custcode")
ssaupj	= dw_ip.getitemstring(1,"saupj")
ls_itnbr1	= dw_ip.getitemstring(1,"itnbr1")
ls_itnbr2	= dw_ip.getitemstring(1,"itnbr2")
			
//필수입력항목 체크///////////////////////////////////
if 	f_datechk(s_datef) <> 1 Or f_datechk(s_datet) <> 1 then
	f_message_chk(30,'[출고기간]')
	dw_ip.setfocus()
	return -1
end if
	
If 	IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
If 	IsNull(s_cvcod ) Then s_cvcod = ''
If 	IsNull(ls_itnbr1) Or ls_itnbr1 = '' Then ls_itnbr1 = '.'
If 	IsNull(ls_itnbr2) Or ls_itnbr2 = '' Then ls_itnbr2 = 'ZZZZ'


dw_list.SetRedraw(False)
			
//조회////////////////////////////////////////////////
IF 	dw_list.retrieve(gs_sabu, s_datef, s_datet, s_cvcod+'%',ssaupj, ls_itnbr1, ls_itnbr2) <= 0 THEN
	f_message_chk(50,'')
	dw_list.SetRedraw(True)
	Return -1
END IF
	
dw_list.SetRedraw(True)
dw_list.ShareData(dw_print)

Return 0
end function

on w_sal_t_10110.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
this.pb_1=create pb_1
this.pb_2=create pb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_7
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.rr_3
end on

on w_sal_t_10110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)

/* User별 사업장 Setting */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

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
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_t_10110
end type

type p_exit from w_standard_print`p_exit within w_sal_t_10110
end type

type p_print from w_standard_print`p_print within w_sal_t_10110
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_t_10110
end type







type st_10 from w_standard_print`st_10 within w_sal_t_10110
end type



type dw_print from w_standard_print`dw_print within w_sal_t_10110
string dataobject = "d_sal_t_10110_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_t_10110
integer x = 809
integer y = 32
integer width = 3205
integer height = 212
string dataobject = "d_sal_t_10110_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sDateFrom, sDateTo, snull, scvnas, scvcod, sispec,  sarea, steam, sSaupj, sName1, ls_saupj, scode
integer ireturn


SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF 	sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
			
		IF 	f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[검수일자]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF 	sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF 	f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[검수일자]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
	Case 'itnbr1' 
		
		sCvcod = Trim(GetText())
		IF 	sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"itnbr1",snull)
			Return
		END IF

		ireturn = f_get_name2("품번", "N", sCvcod, scvnas, sispec)
		this.setitem(1, "itnbr1", scvcod)
		this.setitem(1, "itnbr2", scvcod)
	Case 'itnbr2' 
		
		sCvcod = Trim(GetText())
		IF 	sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"itnbr2",snull)
			Return
		END IF

		ireturn = f_get_name2("품번", "N", sCvcod, scvnas, sispec)
		this.setitem(1, "itnbr2", scvcod)
		
/////////////////////////////////////////////////////////////////////////////////////////////////////		
		
		
	Case "custcode"
		sCvcod = Trim(GetText())
		IF 	sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custname", scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 
		END IF
		
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		If 	f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custname", scvnas)
				SetItem(1, 'custcode', sNull)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 
		END IF

	case 'saupj' 
		
		//거래처
		ls_saupj = gettext() 
		sCode 	= this.object.custcode[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 


End Choose

end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)


Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode", "custname"

		gs_code = this.GetText()
		IF IsNull(gs_code) THEN gs_code =""
	
		gs_gubun = '1'
		Open(w_vndmst_popup)

		IF isnull(gs_Code)  or  gs_Code = ''	then  return

		this.SetItem(1, "custcode", gs_Code)
		this.setitem(1, "custname", gs_CodeName)
		
		TriggerEvent(ItemChanged!)
	Case 'itnbr1'
		gs_code = this.GetText()
		IF IsNull(gs_code) THEN gs_code =""
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
	
		this.SetItem(1,"itnbr1",gs_code)
		this.TriggerEvent(ItemChanged!)

	Case 'itnbr2'
		gs_code = this.GetText()
		IF IsNull(gs_code) THEN gs_code =""
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
	
		this.SetItem(1,"itnbr2",gs_code)
		this.TriggerEvent(ItemChanged!)
END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_t_10110
integer x = 55
integer y = 380
integer width = 4544
integer height = 1928
string dataobject = "d_sal_t_10110_02"
boolean border = false
end type

type rb_1 from radiobutton within w_sal_t_10110
integer x = 55
integer y = 84
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "제품별"
boolean checked = true
end type

event clicked;dw_list.setredraw(false)
dw_list.dataobject = 'd_sal_t_10110_02'
dw_print.dataobject = 'd_sal_t_10110_02_p'
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_list.setredraw(true)

//p_preview.Enabled = False
//p_print.Enabled = False
//p_preview.PictureName= "C:\erpman\image\미리보기_d.gif"
//p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
end event

type rb_2 from radiobutton within w_sal_t_10110
integer x = 443
integer y = 84
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "일자별"
end type

event clicked;dw_list.setredraw(false)
dw_list.dataobject = 'd_sal_t_10110_03'
dw_print.dataobject = 'd_sal_t_10110_03_p'
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_list.setredraw(true)
end event

type rb_3 from radiobutton within w_sal_t_10110
integer x = 507
integer y = 272
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;dw_list.setFilter("")
dw_list.Filter()

dw_print.setFilter("")
dw_print.Filter()
end event

type rb_4 from radiobutton within w_sal_t_10110
integer x = 873
integer y = 272
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "OEM"
end type

event clicked;dw_list.SetFilter( "imhist_pspec = 'OEM'")
dw_list.Filter()

dw_print.SetFilter( "imhist_pspec = 'OEM'")
dw_print.Filter()
end event

type rb_5 from radiobutton within w_sal_t_10110
integer x = 1253
integer y = 272
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "CKD"
end type

event clicked;dw_list.SetFilter( "imhist_pspec = 'CKD'")
dw_list.Filter()

dw_print.SetFilter( "imhist_pspec = 'CKD'")
dw_print.Filter()
end event

type rb_6 from radiobutton within w_sal_t_10110
integer x = 1641
integer y = 272
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "내수"
end type

event clicked;dw_list.SetFilter( "imhist_lclgbn = 'V'")
dw_list.Filter()

dw_print.SetFilter( "imhist_lclgbn = 'V'")
dw_print.Filter()
end event

type rb_7 from radiobutton within w_sal_t_10110
integer x = 2021
integer y = 272
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "수출"
end type

event clicked;dw_list.SetFilter( "imhist_lclgbn = 'L'")
dw_list.Filter()

dw_print.SetFilter( "imhist_lclgbn = 'L'")
dw_print.Filter()
end event

type pb_1 from u_pb_cal within w_sal_t_10110
integer x = 1504
integer y = 52
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_t_10110
integer x = 1966
integer y = 52
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type gb_1 from groupbox within w_sal_t_10110
integer x = 37
integer y = 16
integer width = 768
integer height = 184
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "집계구분"
end type

type gb_2 from groupbox within w_sal_t_10110
integer x = 37
integer y = 220
integer width = 2359
integer height = 144
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "출력 Filter"
end type

type rr_1 from roundrectangle within w_sal_t_10110
integer linethickness = 1
long fillcolor = 16777215
integer x = 896
integer y = 52
integer width = 165
integer height = 144
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_sal_t_10110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 372
integer width = 4581
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 46
end type


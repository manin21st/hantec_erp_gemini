$PBExportHeader$w_sal_01650.srw
$PBExportComments$ ===> 연동 판매 계획서 출력
forward
global type w_sal_01650 from w_standard_print
end type
type st_1 from statictext within w_sal_01650
end type
type rr_1 from roundrectangle within w_sal_01650
end type
end forward

global type w_sal_01650 from w_standard_print
string title = "연동 판매 계획서"
boolean maxbox = true
st_1 st_1
rr_1 rr_1
end type
global w_sal_01650 w_sal_01650

type variables
dec idMeter
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sYearMon, sjMon[3], shMon[4], sItclsCode, sName
Long    lYear, lMonth
Integer i
String  sSalegu , sCvcod, sCvcodto, sPorgu

If dw_ip.AcceptText() <> 1 Then Return -1

/* 계획년월 */
sYearMon = Trim(dw_ip.GetItemString(1,'sym'))

if	(sYearMon = '') or isNull(sYearMon) then
	f_Message_Chk(35, '[계획년월]')
	dw_ip.setcolumn('sym')
	dw_ip.setfocus()
	Return -1
END IF

/* 거래처코드 (From - To) */
sCvcod 	= Trim(dw_ip.GetItemString(1,'cvcod'))
sCvcodto 	= Trim(dw_ip.GetItemString(1,'cvcodto'))

//sPorgu 	= Trim(dw_ip.GetItemString(1,'porgu'))

/* 3개월전 실적년월 */
select to_char(add_months(to_date(:sYearMon,'yyyymm'),-3),'yyyymm') ,
       to_char(add_months(to_date(:sYearMon,'yyyymm'),-2),'yyyymm') ,
       to_char(add_months(to_date(:sYearMon,'yyyymm'),-1),'yyyymm') 
  into :sjMon[3], :sjMon[2], :sjMon[1]
  from dual;

lYear 	= Long(Left(sYearMon,4))
lMonth 	= Long(Right(sYearMon,2))
for i = 1 to 4 
	if lMonth + 1 > 12 then
		lYear = lYear + 1
		lMonth = 1
	else
		lMonth = lMonth + 1
	end if
	shMon[i] = String(lYear) + Mid('0'+String(lMonth), len(String(lMonth)), 2)
next
	

sItclsCode = Trim(dw_ip.getItemString(1, 'sitcls'))
if isNull(sItclsCode) or (sItclsCode = '') then
	sItclsCode = ''
end if
sItclsCode = sItclsCode + '%'

sName = Trim(dw_ip.GetItemString(1,'stitnm'))
if isNull(sName) or (sName = '') then
	sName = '전 체'
end if

if	(sYearMon='') or isNull(sYearMon) then
	f_Message_Chk(35, '[계획년월]')
	dw_ip.setcolumn('sym')
	dw_ip.setfocus()
	Return -1
end if

If dw_print.Retrieve(gs_sabu, sYearMon,sjMon[3],sjMon[2],sjMon[1],sItclsCode,shMon[1],shMon[2],shMon[3],shMon[4], &
                                 sCvcod, sCvcodto,idMeter ) <= 0 Then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.Reset()
	dw_ip.InsertRow(0)
 	dw_ip.setcolumn('sym')
	dw_list.Reset()
	Return -1
END IF
			
dw_print.ShareData(dw_list)

//if dw_list.Retrieve(gs_sabu,sYearMon,sjMon[3],sjMon[2],sjMon[1],sItclsCode,shMon[1],shMon[2],shMon[3],shMon[4],sSalegu ) < 1 then
//   f_message_Chk(300, '[출력조건 CHECK]')
//	dw_ip.Reset()
//	dw_ip.InsertRow(0)
//  	dw_ip.setcolumn('sym')
//   dw_ip.setfocus()
//  	return -1
//end if
//
dw_print.object.r_ym.Text = left(sYearMon,4) + '년 ' + right(sYearMon,2) + '월'
dw_print.object.r_itcls.Text = sName

dw_list.object.t_fym3.text = String(sJmon[3],'@@@@.@@')
dw_list.object.t_fym2.text = String(sJmon[2],'@@@@.@@')
dw_list.object.t_fym1.text = String(sJmon[1],'@@@@.@@')
//messagebox(syearmon, shmon[1])
dw_list.object.t_yymm.text = String(sYearMon,'@@@@.@@')
dw_list.object.t_ym1.text = String(shMon[1],'@@@@.@@')
dw_list.object.t_ym2.text = String(shMon[2],'@@@@.@@')
dw_list.object.t_ym3.text = String(shMon[3],'@@@@.@@')
dw_list.object.t_ym4.text = String(shMon[4],'실행계획')

return 1
end function

on w_sal_01650.create
int iCurrent
call super::create
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_01650.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;string s_min, s_max

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
dw_ip.setitem(1,'sym',left(f_today(),6))

SELECT MIN(RPAD(I.CVCOD,15)||I.CVNAS2), MAX(RPAD(I.CVCOD,15)||I.CVNAS2)
 	INTO :s_min, :s_max  
   		FROM VNDMST I
		WHERE I.CVGU = '1'	;
		
dw_ip.SetItem(1,"cvcod", 		Trim(Mid(s_min,1,15)))
dw_ip.SetItem(1,"cvnas2", 		Mid(s_min,16,40))
dw_ip.SetItem(1,"cvcodto",   	Trim(Mid(s_max,1,15)))
dw_ip.SetItem(1,"cvnas2to", 	Mid(s_max,16,40))

/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'porgu')

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'porgu', gs_saupj ) 

//m환산기준
SELECT TO_NUMBER(DATANAME) INTO :idMeter FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 2 AND LINENO = :gs_saupj;
If IsNull(idMeter) Then idMeter = 500000


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
//dw_ip.Reset()
//dw_ip.InsertRow(0)

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

type p_preview from w_standard_print`p_preview within w_sal_01650
end type

event p_preview::clicked;call super::clicked;// Override 한 것을 해제 
//dw_print.Reset()
//dw_list.RowsCopy(1, dw_list.RowCount(), Primary!, dw_print, 1, Primary!)
//dw_print.AcceptText()
//OpenWithParm(w_print_preview, dw_print)	

end event

type p_exit from w_standard_print`p_exit within w_sal_01650
end type

type p_print from w_standard_print`p_print within w_sal_01650
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01650
end type

event p_retrieve::clicked;call super::clicked;String s_min, s_max
//
s_min = dw_ip.GetItemString(1,"cvcod") 	+ dw_ip.GetItemString(1,"cvnas2")
s_max = dw_ip.GetItemString(1,"cvcodto") 	+ dw_ip.GetItemString(1,"cvnas2to")

if s_min = "" or isNull(s_min) then	
	SELECT MIN(RPAD(I.CVCOD,15)||I.CVNAS2)
 	  INTO :s_min
     FROM VNDMST I
	 WHERE I.CVGU = '1'	;
	dw_ip.SetItem(1,"cvcod", 		Trim(Mid(s_min,1,15)))
	dw_ip.SetItem(1,"cvnas2", 		Mid(s_min,16,40))
End If			

if 	s_max = "" or isNull(s_max) then	
	SELECT MAX(RPAD(I.CVCOD,15)||I.CVNAS2)
 	  INTO :s_max
     FROM VNDMST I
	  WHERE I.CVGU = '1'	;
	dw_ip.SetItem(1,"cvcodto",   	Trim(Mid(s_max,1,15)))
	dw_ip.SetItem(1,"cvnas2to", 	Mid(s_max,16,40))
End If			
		

end event







type st_10 from w_standard_print`st_10 within w_sal_01650
end type



type dw_print from w_standard_print`dw_print within w_sal_01650
integer x = 2907
integer y = 68
integer width = 183
integer height = 132
string dataobject = "d_sal_01650_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01650
integer x = 46
integer y = 32
integer width = 2706
integer height = 292
string dataobject = "d_sal_01650_01"
end type

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
str_itnct str_sitnct

Choose Case GetColumnName()
	// 품목분류 에디트에 Right 버턴클릭시 Popup 화면
	Case "sitcls"		
		OpenWithParm(w_ittyp_popup, '1')
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"sitcls",str_sitnct.s_sumgub)
		SetItem(1,"stitnm", str_sitnct.s_titnm)
		

//		gs_code = sPdtgu
//		gs_codename = sPdtguNm
//		Open(w_pdtgu_ittyp)
//
//		this.SetItem(1, 'sitcls', gs_code)
//		this.SetItem(1, 'stitnm', gs_codename)
//		return 1
	/* 거래처 */
	Case "cvcod"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)

	Case "cvcodto"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		SetItem(1,"cvcodto",gs_code)
		SetColumn("cvcodto")
		TriggerEvent(ItemChanged!)

end Choose
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sNull, sCol_Name, sCode, sName, scvnas, sarea, steam, sSaupj, sName1
string ls_saupj 

SetNull(sNull)

sCol_Name = This.GetColumnName()

Choose Case sCol_Name
	Case "sitcls"

		sCode = Trim(This.GetText())
		if isNull(sCode) then 
			return
   	else
	   	Select titnm Into :sName From itnct
		   Where ittyp = '1' and itcls = :sCode;
			
      	if (sName = '') or (isNull(sName)) then
	      	MessageBox("자료 확인", "해당 품목분류명이 존재하지 않거나." + '~r~r' + &
				                        "해당 생산팀의 품목분류가 아닙니다")
		     	this.SetItem(1, "sitcls", sNull)
		     	this.SetItem(1, "stitnm", sNull)				  
				return 1
   	   else
	   	  	this.SetItem(1, "stitnm", sName)
   	   end if					
		end if
	/* 거래처 From */
	Case "cvcod"
		sCode 	= Trim(This.GetText())
		IF 	sCode ="" OR IsNull(sCode) THEN
			SetItem(1,"cvnas2",snull)
			Return
		END IF

		If 	f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas2', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.porgu[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod",  		sCode)
				SetItem(1,"cvnas2",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCode +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF
	/* 거래처 To */
	Case "cvcodto"
		sCode 	= Trim(This.GetText())
		IF 	sCode ="" OR IsNull(sCode) THEN
			SetItem(1,"cvnas2to",snull)
			Return
		END IF

		If 	f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcodto', sNull)
			SetItem(1, 'cvnas2to', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.porgu[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcodto",  		sCode)
				SetItem(1,"cvnas2to",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCode +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 

		END IF
	case 'porgu' 
		
		//거래처
		ls_saupj = gettext() 
		sCode 	= this.object.cvcod[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
				SetItem(1,"cvcod",  		sCode)
				SetItem(1,"cvnas2",		scvnas)
		End if 
		//거래처 To
		sCode 	= this.object.cvcodto[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'cvcodto', sNull)
			SetItem(1, 'cvnas2to', snull)
		End if 

end choose
end event

type dw_list from w_standard_print`dw_list within w_sal_01650
integer x = 59
integer y = 360
integer width = 4530
integer height = 1956
string dataobject = "d_sal_01650"
boolean border = false
end type

type st_1 from statictext within w_sal_01650
boolean visible = false
integer x = 3186
integer y = 216
integer width = 1408
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "[범례 : ↑증가, ↓감소, ◎생성,×삭제]"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sal_01650
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 344
integer width = 4553
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type


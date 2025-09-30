$PBExportHeader$w_imt_03090_1.srw
$PBExportComments$B/L수입원가 계산서-자금내역
forward
global type w_imt_03090_1 from window
end type
type cb_2 from commandbutton within w_imt_03090_1
end type
type cb_1 from commandbutton within w_imt_03090_1
end type
type dw_1 from datawindow within w_imt_03090_1
end type
end forward

global type w_imt_03090_1 from window
integer width = 1801
integer height = 576
windowtype windowtype = response!
long backcolor = 67108864
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
end type
global w_imt_03090_1 w_imt_03090_1

on w_imt_03090_1.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1}
end on

on w_imt_03090_1.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;F_WINDOW_CENTER_RESPONSE(THIS)

dw_1.settransobject(sqlca)
if dw_1.retrieve(gs_sabu, gs_code) = 0 then
	dw_1.insertrow(0)
	dw_1.setitem(1, "polcbl_custom_sabu", gs_sabu)
	dw_1.setitem(1, "polcbl_custom_poblno", gs_code)	
end if

setnull(gs_code)

end event

type cb_2 from commandbutton within w_imt_03090_1
integer x = 1161
integer y = 420
integer width = 430
integer height = 116
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료"
end type

event clicked;CLOSE(PARENT)
end event

type cb_1 from commandbutton within w_imt_03090_1
integer x = 718
integer y = 420
integer width = 430
integer height = 116
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장"
end type

event clicked;dw_1.update()
commit;

close(parent)

end event

type dw_1 from datawindow within w_imt_03090_1
integer width = 1769
integer height = 380
integer taborder = 10
string title = "none"
string dataobject = "d_imt_03097"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string  snull, sdate, scode, sname1, sname2, sNo, get_nm
int     ireturn, icount 

setnull(snull)

IF this.GetColumnName() = "polcbl_custom_sucvcod" THEN
	
	sCode = this.GetText()								
	
	if scode = '' or isnull(scode) then 
		this.setitem(1, 'vndmst_cvnas', sNull)
      return 
	end if	
	
	//거래처는 국내, 해외, 은해만 선택할 수 있음
   SELECT CVNAS2
     INTO :sName1
     FROM VNDMST 
    WHERE CVCOD = :sCode   AND
	 		 CVSTATUS = '0'   AND 
			 CVGU  IN ('1', '2', '3') ;
	 		 
	IF sqlca.sqlcode = 100 	THEN
		f_message_chk(33,'[거래처]')
		this.setitem(1, 'polcbl_custom_sucvcod', sNull)
		this.setitem(1, 'vndmst_cvnas', snull)
	   return 1
	ELSE
		this.setitem(1,  'vndmst_cvnas', sName1)
   END IF
END IF
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "polcbl_custom_sucvcod"	THEN		
	open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	this.SetItem(1, "polcbl_custom_sucvcod", gs_code)
	this.SetItem(1, "vndmst_cvnas", gs_codename)
	this.triggerevent(itemchanged!)	
END IF


end event

